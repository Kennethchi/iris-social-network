import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:meta/meta.dart';

import 'create_message_bloc.dart';

import 'create_message_views_handlers.dart';


class CreateMessageBlocProvider extends InheritedWidget{

  final CreateMessageBloc bloc;
  final Key key;
  final Widget child;


  CreateMessageViewsHandlers handlers;


  File messageFile;
  String messageType;

  TextEditingController messageCaptionTextEditingController;
  SwiperController imagesSwiperController;
  PageController pageController;

  CreateMessageBlocProvider({
    @required this.bloc,
    this.messageFile,
    this.messageType,
    this.messageCaptionTextEditingController,
    this.imagesSwiperController,
    this.pageController,
    this.key,
    this.child
  }): super(key: key, child: child){

    handlers = CreateMessageViewsHandlers();
  }


  static CreateMessageBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(CreateMessageBlocProvider) as CreateMessageBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}