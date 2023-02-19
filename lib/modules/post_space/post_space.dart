import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:extended_image/extended_image.dart';

import 'post_space_bloc.dart';
import 'post_space_bloc_provider.dart';
import 'post_space_views.dart';


import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';




class PostSpace extends StatefulWidget{

  List<PostModel> postsList;
  int currentPostViewIndex;
  dynamic dynamicBloc;


  PostSpace({@required this.dynamicBloc, @required this.postsList, @required this.currentPostViewIndex});

  _PostSpaceState createState() => new _PostSpaceState();
}



class _PostSpaceState extends State<PostSpace>{


  SwiperController _swiperController;


  PostSpaceBloc _postsSpaceBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _postsSpaceBloc = PostSpaceBloc(postsList: widget.postsList, currentPostViewIndex: widget.currentPostViewIndex);

    _swiperController = SwiperController();
    _swiperController.index = widget.currentPostViewIndex;

  }



  @override
  void dispose() {
    // TODO: implement dispose


    _swiperController.dispose();
    _postsSpaceBloc.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build




    return PostSpaceBlocProvider(
      postsSpaceBloc: _postsSpaceBloc,
      dynamicBloc: widget.dynamicBloc,
      swiperController: _swiperController,
      child: Scaffold(
        body: CupertinoPageScaffold(

          child: Container(
            color: Colors.black,

            child: PostSpaceSwiperView(postsList: widget.postsList),

          ),

        ),
      ),

    );
  }



}













