import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'splash_bloc.dart';
import 'splash_screen_handlers.dart';


class SplashBlocProvider extends InheritedWidget{

  final SplashBloc bloc;
  final Key key;
  final Widget child;

  SplashScreenHandlers handlers;


  AnimationController splashAnimationController;
  Animation titleTranslate;
  Animation authenticationButtonsTranlate;

  AnimationController loopAnimationController;
  Animation titleLoopAnimation;

  SplashBlocProvider({@required this.bloc, @required this.splashAnimationController, @required this.loopAnimationController, this.key, this.child})
      : super(key: key, child: child){


    handlers = SplashScreenHandlers();




    titleTranslate = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: splashAnimationController, curve: Interval(0.6, 1.0, curve: Curves.easeInOutBack)));
    authenticationButtonsTranlate = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: splashAnimationController, curve: Interval(0.8, 1.0, curve: Curves.easeInOutBack)));


    titleLoopAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: loopAnimationController, curve: Curves.fastOutSlowIn));



    splashAnimationController.forward();
    splashAnimationController.addStatusListener((AnimationStatus status){
      switch(status){

        case AnimationStatus.forward: case AnimationStatus.reverse:case AnimationStatus.dismissed:
          break;

        case AnimationStatus.completed:

          print("CCCCCCCCCCCCCCcccccc");

          loopAnimationController.addStatusListener((AnimationStatus status){
            switch(status){
              case AnimationStatus.forward:
                break;
              case AnimationStatus.reverse:
                break;
              case AnimationStatus.dismissed:
                loopAnimationController.forward();
                break;
              case AnimationStatus.completed:
                loopAnimationController.reverse();
                break;
            }
          });

          loopAnimationController.forward();

          break;
      }
    });


  }


  static SplashBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(SplashBlocProvider) as SplashBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}