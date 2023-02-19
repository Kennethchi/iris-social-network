import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';



class SettingsHandlers{

  void signOutPopUpModalMenu ({@required BuildContext settingsCcontext}){

    showCupertinoModalPopup(
        context: settingsCcontext,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text("Do you want to Logout from this App?"),
            actions: <Widget>[

              CupertinoActionSheetAction(

                child: Center(
                    child: Text("Yes", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),)
                ),
                onPressed: (){


                  // Sign out mediums
                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().signOut();
                  FacebookLogin().logOut();



                  Navigator.pop(context);

                  Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.splash_screen, (Route<dynamic> route) => false);
                },
              ),

              CupertinoActionSheetAction(
                child: Center(
                    child: Text("No", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),)
                ),
                onPressed: () => Navigator.pop(context),
              ),

            ],


          );
        }
    );

  }


}