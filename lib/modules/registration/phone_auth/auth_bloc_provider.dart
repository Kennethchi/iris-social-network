import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'auth_bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

import 'package:iris_social_network/modules/registration/phone_auth/phone_auth_views_widgets.dart';

import 'phone_auth_views.dart';

import 'firebase_auth_provider.dart';

import 'package:meta/meta.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';




class AuthBlocProvider extends InheritedWidget{

  final Key key;
  final AuthBloc bloc;
  final Widget child;

  Country selectedCountry;


  PageController pageController;


  AuthBlocProvider({@required this.bloc, this.key, this.child, @required this.pageController}) : super(child: child, key: key ){

    this.selectedCountry = CountryPickerUtils.getCountryByIsoCode("cm");
  }




  /*
  static Future<void> requestAccessMessagePermission()async{

    if(defaultTargetPlatform == TargetPlatform.android){

      // This sms permission works only for android

      PermissionHandler permissionHandler = PermissionHandler();

      PermissionStatus permissionStatus = await permissionHandler.checkPermissionStatus(PermissionGroup.sms);

      if(permissionStatus != PermissionStatus.granted){
        Map<PermissionGroup, PermissionStatus> map = await permissionHandler.requestPermissions([PermissionGroup.sms]);

        if (map[PermissionGroup] == PermissionStatus.granted){
          print("permission is granted");
        }
      }else{
        print("Permission already exists");
      }
    }

  }
  */



  static AuthBlocProvider of<AuthBloc>(BuildContext context) => context.inheritFromWidgetOfExactType(AuthBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;





  // called when user has sent a phone number verification and an sms with verication code is received
  void onSmsCodeSent({@required BuildContext inheritContext, @required Map<String, dynamic> snapshotData,
    @required String phoneNumber, @required String isoCode, @required int durationForPageTransition}){

    String verificationId = snapshotData[FirebaseAuthProvider.Verification_Id_Key];
    bloc.addVerificationId(verificationId);

    bloc.setVerificationId = verificationId;


    pageController.nextPage(
        duration: Duration(
            seconds: durationForPageTransition
        ),
        curve: Curves.easeInOutBack
    ).then((_){

      bloc.addFullPhoneNumber({
        AuthBloc.Phone_Number_Key: phoneNumber,
        AuthBloc.Iso_Code_Key: isoCode
      });

    });

  }




  // called when user has entered sms verfication code
  void onSmsCodeEntered({@required BuildContext context, @required String smsCode}){

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    BasicUI.showProgressDialog(
        pageContext: context,
        child: SpinKitFadingCircle
          (color: CupertinoTheme.of(context).primaryColor,)
    );

    bloc.signInWithPhoneNumber(smsCode: smsCode).then((FirebaseUser user) {

      if (user != null){


        Navigator.pop(context);

        BasicUI.showProgressDialog(pageContext: context,
            child: Column(
              children: <Widget>[
                SpinKitFadingCircle(color: CupertinoTheme.of(context).primaryColor,),
                SizedBox(height: screenHeight * scaleFactor * scaleFactor,),
                Text("Signing In...", style: TextStyle(color: _themeData.primaryColor),)
              ],
            )
        );



        // Sets user id to be used by other screens in the app
        AppBlocProvider.of(context).bloc.setCurrentUserId = user.uid;

        bloc.isNewUser(userId: user.uid).then((bool isNewUser)async{

          int waitTimeBeforePushToNextPage = 5;


          if (isNewUser){

            Timer(Duration(seconds: waitTimeBeforePushToNextPage),(){

              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.account_setup_screen, (Route<dynamic> route) => false);
            });
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

              Timer(Duration(seconds: waitTimeBeforePushToNextPage), (){

                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home_screen, (Route<dynamic> route) => false);
              });
            });
          }
        });
      }
      else{
        Navigator.pop(context);
        Timer(Duration(milliseconds: 1), (){
          BasicUI.showSnackBar(context: context, message: "An error occured during sign in" +
              "\nCheck your Internet Connection or check if you entered the correct Sms Verification Code", textColor: RGBColors.red);
        });
      }

    }).catchError((error){


      Navigator.pop(context);
      Timer(Duration(microseconds: 1), (){
        BasicUI.showSnackBar(context: context, message: error.toString(), textColor: RGBColors.red);
      });


    });
  }



  void onAutoSmsCodeRetrievedCompleted({@required BuildContext context, @required AuthCredential authCredential}){

    FirebaseAuth.instance.signInWithCredential(authCredential).then((AuthResult authResult){

      FirebaseUser firebaseUser = authResult.user;

      if (firebaseUser != null){
        bloc.isNewUser(userId: firebaseUser.uid).then((bool isNewUser){

          if (isNewUser){

            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.account_setup_screen, (Route<dynamic> route) => false);
          }else{

            // sets account setup to null to indicate it is not a fresh new user and does not need an account setup since his data is still in the database
            // This will help solve the problem of overwitting the user data with same phone number when user uninstalls the app and installs it back
            // The user when reinstalling the app will have to skip the account setup process if he did not sign out
            SharedPreferences.getInstance().then((SharedPreferences prefs){
              prefs.setBool(SharedPrefsKeys.account_setup_complete, null);

              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home_screen, (Route<dynamic> route) => false);
            });
          }
        });
      }
      else{
        Navigator.pop(context);
        Timer(Duration(milliseconds: 1), (){
          BasicUI.showSnackBar(context: context, message: "An error occured during sign in" +
              "\nAuto Retrieve code Timeout ", textColor: RGBColors.red);
        });
      }


    });



  }


}




