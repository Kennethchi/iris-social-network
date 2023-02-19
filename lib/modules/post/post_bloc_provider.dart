import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'post_bloc.dart';
import 'dart:io';
import 'post_view_handlers.dart';
import 'package:flutter_swiper/flutter_swiper.dart';



class PostBlocProvider extends InheritedWidget{

  final PostBloc bloc;
  final Key key;
  final Widget child;

  PostViewHandlers handlers;

  File postFile;
  String postType;

  TextEditingController postCaptionTextEditingController;
  PageController pageController;
  SwiperController imagesSwiperController;

  dynamic dynamicBloc;

  PostBlocProvider({
    @required this.bloc,
    @required this.dynamicBloc,
    @required this.postFile,
    @required this.postType,
    @required this.postCaptionTextEditingController, @required this.pageController, this.imagesSwiperController,
    this.key, this.child}
    ): super(key: key, child: child)
  {
    handlers = PostViewHandlers();
  }


  static PostBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PostBlocProvider) as PostBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}