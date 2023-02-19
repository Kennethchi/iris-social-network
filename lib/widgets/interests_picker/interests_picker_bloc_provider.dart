import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'interests_picker_bloc.dart';
import 'interests_picker_views_handlers.dart';



class InterestsPickerBlocProvider extends InheritedWidget{

  final InterestsPickerBloc bloc;
  final Key key;
  final Widget child;

  InterestsPickerViewHandlers handlers;

  InterestsPickerBlocProvider({@required this.bloc, this.key, this.child}): super(key: key, child: child){

    handlers = InterestsPickerViewHandlers();
  }


  static InterestsPickerBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(InterestsPickerBlocProvider) as InterestsPickerBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}