import 'package:flutter/material.dart';
import 'home_bloc.dart';
import 'package:flutter/animation.dart';
import 'home_view_handlers.dart';




class HomeBlocProvider<t extends HomeBlocBlueprint> extends InheritedWidget{

  final Key key;
  final HomeBloc bloc;
  final Widget child;


  AnimationController animationController;
  Animation<double> translateAnimation;


  HomeBlocProvider({@required this.bloc, @required this.animationController, this.key, this.child}): super(key: key, child: child){


    translateAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn));

    animationController.addStatusListener((AnimationStatus status){
      switch(status){
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
        case AnimationStatus.dismissed:
          animationController.forward();
          break;
        case AnimationStatus.completed:
          animationController.reverse();
          break;
      }
    });

    animationController.forward();

  }


  static HomeBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(HomeBlocProvider) as HomeBlocProvider);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

}






