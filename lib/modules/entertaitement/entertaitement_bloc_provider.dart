import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'entertaitement_bloc.dart';
import 'entertaitement_views_handlers.dart';


class EntertaitementBlocProvider extends InheritedWidget{

  final EntertaitementBloc bloc;
  final Key key;
  final Widget child;

  EntertaitementViewsHandlers handlers;

  EntertaitementBlocProvider({@required this.bloc, this.key, this.child}): super(key: key, child: child){

    handlers = EntertaitementViewsHandlers();
  }


  static EntertaitementBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(EntertaitementBlocProvider) as EntertaitementBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}