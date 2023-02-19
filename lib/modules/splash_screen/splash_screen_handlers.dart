import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/utils/basic_utils.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'splash_bloc.dart';
import 'splash_bloc_provider.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';




class SplashScreenHandlers{


  Future<void> signInWithGoogle({@required BuildContext context})async{

    SplashBloc bloc = SplashBlocProvider.of(context).bloc;


    bloc.signInWithGoogle().then((user){

      if (user != null){


        // Sets user id to be used by other screens in the app
        AppBlocProvider.of(context).bloc.setCurrentUserId = user.uid;


        AppBlocProvider.of(context).bloc.isNewUser(userId: user.uid).then((bool isNewUser)async{

          if (isNewUser){


            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.account_setup_screen, (Route<dynamic> route) => true);
          }else{


            // // updates user device token if user is not a new user
            user.getIdToken().then((IdTokenResult idTokenResult){

              String deviceToken = idTokenResult.token;

              AppBlocProvider.of(context).bloc.updateUserDeviceToken(currentUserId: user.uid, deviceToken: deviceToken);
            });


            // sets account setup to null to indicate it is not a fresh new user and does not need an account setup since his data is still in the database
            // This will help solve the problem of overwitting the user data with same phone number when user uninstalls the app and installs it back
            // The user when reinstalling the app will have to skip the account setup process if he did not sign out
            SharedPreferences.getInstance().then((SharedPreferences prefs){


              prefs.setBool(SharedPrefsKeys.account_setup_complete, null);

              print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home_screen, (Route<dynamic> route) => false);
            });
          }
        });

        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.account_setup_screen, (Route<dynamic> route ) => true);
      }else{

        Navigator.pop(context);
        BasicUI.showSnackBar(context: context, message: "An error occured");
      }

    });

  }



  Future<void> signInWithFacebook({@required BuildContext context})async{

    SplashBloc bloc = SplashBlocProvider.of(context).bloc;


    bloc.signInWithFacebook().then((FacebookLoginResult facebookLoginResult){

      switch(facebookLoginResult.status){

        case FacebookLoginStatus.cancelledByUser:

          Navigator.pop(context);
          BasicUI.showSnackBar(context: context, message: "Operation was cancelled by user");

          break;

        case FacebookLoginStatus.error:

          Navigator.pop(context);
          BasicUI.showSnackBar(context: context, message: "An error occured");

          break;

        case FacebookLoginStatus.loggedIn:



          AuthCredential authCredential = FacebookAuthProvider.getCredential(accessToken: facebookLoginResult.accessToken.token);

          FirebaseAuth.instance.signInWithCredential(authCredential).then((AuthResult authResult){

            FirebaseUser firebaseUser = authResult.user;

            if (firebaseUser != null){


              // Sets user id to be used by other screens in the app
              AppBlocProvider.of(context).bloc.setCurrentUserId = firebaseUser.uid;


              AppBlocProvider.of(context).bloc.isNewUser(userId: firebaseUser.uid).then((bool isNewUser)async{

                if (isNewUser){

                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.account_setup_screen, (Route<dynamic> route) => true);
                }else{

                  // // updates user device token if user is not a new user
                  firebaseUser.getIdToken().then((IdTokenResult idTokenResult){

                    String deviceToken = idTokenResult.token;

                    AppBlocProvider.of(context).bloc.updateUserDeviceToken(currentUserId: firebaseUser.uid, deviceToken: deviceToken);
                  });

                  // sets account setup to null to indicate it is not a fresh new user and does not need an account setup since his data is still in the database
                  // This will help solve the problem of overwitting the user data with same phone number when user uninstalls the app and installs it back
                  // The user when reinstalling the app will have to skip the account setup process if he did not sign out
                  SharedPreferences.getInstance().then((SharedPreferences prefs){
                    prefs.setBool(SharedPrefsKeys.account_setup_complete, null);

                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home_screen, (Route<dynamic> route) => false);
                  });
                }
              });

              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.account_setup_screen, (Route<dynamic> route ) => true);
            }else{


              Navigator.pop(context);
              BasicUI.showSnackBar(context: context, message: "An error occured");
            }

          });

          break;
      }


    });

  }



}