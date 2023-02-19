import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'splash_screen_view.dart';
import 'package:iris_social_network/services/firebase_services/firebase_auth_service.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/modules/registration/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'splash_bloc_provider.dart';
import 'splash_bloc.dart';




class SplashScreen extends StatefulWidget{

  // Splash screen route name for navigation
  static const String routeName = AppRoutes.splash_screen;

  _SplashScreenState createState() => new _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  SplashBloc _bloc;

  final splashDuration = Duration(seconds: 5);

  AnimationController _splashAnimationController;
  Animation titleTranslate;
  Animation authenticationButtonsTranlate;

  AnimationController _loopAnimationController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = SplashBloc();

    _splashAnimationController = AnimationController(vsync: this, duration: splashDuration);


    _loopAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));


    Timer(splashDuration * 2, (){
      //Navigator.of(context).pushReplacementNamed(AppRoutes.signup_screen);
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _splashAnimationController.dispose();
    _loopAnimationController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return SplashBlocProvider(
      bloc: _bloc,
      splashAnimationController: this._splashAnimationController,
      loopAnimationController: _loopAnimationController,
      child: Scaffold(

        body: CupertinoPageScaffold(

          child: SplashScreenview(splashDuration: splashDuration,)
        ),

      ),
    );
  }



}