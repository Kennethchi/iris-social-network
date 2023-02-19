import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'achievements_bloc.dart';
import 'achievements_view_handlers.dart';


class AchievementsBlocProvider extends InheritedWidget{

  final AchievementsBloc bloc;
  final Key key;
  final Widget child;

  AchievementsViewHandler handlers;


  AchievementsBlocProvider({@required this.bloc, this.key, this.child}): super(key: key, child: child){

    handlers = AchievementsViewHandler();
  }


  static AchievementsBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(AchievementsBlocProvider) as AchievementsBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}