import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'bubble_smash_bloc.dart';
import 'bubble_smash_view_handlers.dart';




class BubbleSmashBlocProvider extends InheritedWidget {


  final Key key;
  final Widget child;
  final BubbleSmashBloc bloc;

  BubbleSmashViewHandlers handlers;

  OverlayState overlayState;
  OverlayEntry overlayEntry;


  BubbleSmashBlocProvider({@required this.bloc, this.key, this.child}) : super(key: key, child: child) {
    handlers = BubbleSmashViewHandlers();
  }


  static BubbleSmashBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(BubbleSmashBlocProvider) as BubbleSmashBlocProvider);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

}









