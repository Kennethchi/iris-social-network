import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'settings_bloc.dart';
import 'settings_handlers.dart';


class SettingsBlocProvider extends InheritedWidget{

  final SettingsBloc bloc;
  final Key key;
  final Widget child;

  SettingsHandlers handlers;

  SettingsBlocProvider({@required this.bloc, this.key, this.child}): super(key: key, child: child){

    handlers = SettingsHandlers();
  }


  static SettingsBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(SettingsBlocProvider) as SettingsBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}