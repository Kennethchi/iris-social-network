import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'menu_bloc.dart';
import 'menu_handlers.dart';


class MenuBlocProvider extends InheritedWidget{

  final MenuBloc bloc;
  final Key key;
  final Widget child;

  MenuHandlers handlers;

  TextEditingController feedBackTextEditingController;
  TextEditingController reportBugTextEditingController;

  MenuBlocProvider({
    @required this.bloc,
    @required this.feedBackTextEditingController,
    @required this.reportBugTextEditingController,
    this.key,
    this.child
  }): super(key: key, child: child){

    handlers = MenuHandlers();

    handlers.getAppVersion(menuBloc: bloc);
  }

  static MenuBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(MenuBlocProvider) as MenuBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}