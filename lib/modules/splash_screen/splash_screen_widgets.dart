import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'splash_bloc.dart';
import 'splash_bloc_provider.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/utils/basic_utils.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';





class SplashScreenTitleWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    Animation titleTranslate = SplashBlocProvider.of(context).titleTranslate;
    Animation titleLoopAnimation = SplashBlocProvider.of(context).titleLoopAnimation;

    return AnimatedBuilder(
        animation: SplashBlocProvider.of(context).splashAnimationController,
        builder: (BuildContext context, Widget child){

          return Transform.translate(
            offset: Offset(0.0, scaleFactor * screenHeight * 0.25 * titleLoopAnimation.value ),
            child: Transform.translate(
              offset: Offset(0.0, screenHeight * titleTranslate.value),
              child: Column(
                children: <Widget>[

                  Text("Welcome to Iris",
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.display2.fontSize,
                        fontWeight: FontWeight.bold,
                        color: _themeData.primaryColor
                    ),
                    textAlign: TextAlign.center,
                  ),


                  Text("Let your Rainbow Glow",
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.subhead.fontSize,
                        fontWeight: FontWeight.bold,
                      color: RGBColors.white
                    ),
                    textAlign: TextAlign.center,
                  ),


                ],
              ),
            ),
          );
        }
    );
  }
}




class AuthenticationButtonsWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    SplashBloc _bloc = SplashBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    Animation authenticationButtonsTranslate =  SplashBlocProvider.of(context).authenticationButtonsTranlate;

    return AnimatedBuilder(
      animation: SplashBlocProvider.of(context).splashAnimationController,
      builder: (BuildContext context, Widget child){

        return ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.5),
          //crossAxisAlignment: CrossAxisAlignment.center,
          shrinkWrap: true,
          children: <Widget>[

            Transform.translate(
              offset: Offset(authenticationButtonsTranslate.value * screenWidth * -1, 0.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: GoogleSignInButton(
                  borderRadius: 5.0,
                  text: "Sign in with Google",
                  onPressed: () {


                    SplashBlocProvider.of(context).handlers.signInWithGoogle(context: context);

                  },
                ),
              ),
            ),



            Transform.translate(
              offset: Offset(authenticationButtonsTranslate.value * screenWidth, 0.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: FacebookSignInButton(
                    text: "Sign in with Facebook",
                    onPressed: () {


                      SplashBlocProvider.of(context).handlers.signInWithFacebook(context: context);

                    }
                ),
              ),
            ),


            Transform.translate(
              offset: Offset(authenticationButtonsTranslate.value * screenWidth * -1, 0.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: PhoneNumberSignInButton(),
              )
            ),



            //TwitterSignInButton(onPressed: () {}),
            //MicrosoftSignInButton(onPressed: () {}),
            //MicrosoftSignInButton(onPressed: () {}, darkMode: true),

          ],
        );

      },
    );
  }

}





class PhoneNumberSignInButton extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    SplashBloc _bloc = SplashBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    Animation authenticationButtonsTranslate =  SplashBlocProvider.of(context).authenticationButtonsTranlate;

    return RaisedButton(
      padding: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: _themeData.primaryColor,
      onPressed: (){

        Navigator.of(context).pushReplacementNamed(AppRoutes.signup_screen);
      },
      child: Row(
        children: <Widget>[

          Icon(Icons.phone, color: RGBColors.white,),
          SizedBox(width: 10.0,),

          Text("Sign in with Phone", style: TextStyle(
            color: RGBColors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),)
        ],
      ),
    );
  }

}