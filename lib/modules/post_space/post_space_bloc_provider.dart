import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'post_space_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'post_space_view_handlers.dart';

import 'package:iris_social_network/modules/post_feed/post_feed_bloc.dart';


class PostSpaceBlocProvider extends InheritedWidget{

  final Key key;
  final Widget child;

  final PostSpaceBloc postsSpaceBloc;


  SwiperController swiperController;

  PostSpaceViewHandlers handlers;

  dynamic dynamicBloc;


  PostSpaceBlocProvider({@required this.postsSpaceBloc, this.dynamicBloc, this.swiperController, this.key, this.child}): super(key: key, child: child){


    handlers = PostSpaceViewHandlers();

    /*
    swiperController.addListener((){
      if (dynamicBloc is PostFeedBloc){

        PostFeedBloc _postFeedbloc = (dynamicBloc as PostFeedBloc);

      }

      swiperController.notifyListeners();
    });
    */

  }


  static PostSpaceBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PostSpaceBlocProvider) as PostSpaceBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}