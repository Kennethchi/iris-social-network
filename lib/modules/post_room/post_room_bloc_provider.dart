import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'post_room_bloc.dart';
import 'post_room_views_handlers.dart';



class PostRoomBlocProvider extends InheritedWidget{

  final PostRoomBloc bloc;
  final Key key;
  final Widget child;

  PostRoomsViewHandlers handlers;

  PostRoomBlocProvider({@required this.bloc, this.key, this.child}): super(key: key, child: child){

    handlers = PostRoomsViewHandlers();
  }


  static PostRoomBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PostRoomBlocProvider) as PostRoomBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}