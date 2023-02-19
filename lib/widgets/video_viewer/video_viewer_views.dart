import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/widgets/video_viewer/video_viewer_views_widgets.dart';
import 'video_viewer_bloc_provider.dart';
import 'video_viewer_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';


class VideoViewerViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    VideoViewerBlocProvider _provider = VideoViewerBlocProvider.of(context);
    VideoViewerBloc _bloc = _provider.bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);



    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[

          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: _provider.videoImageUrl != null? _provider.videoImageUrl: "" ,
              fit: BoxFit.cover,
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0
            ),
              child: VideoWidget(videoUrl: _provider.videoUrl, videoViewerBloc: _bloc,)
          ),

          Positioned(
              top: 0.0,
              right: 0.0,
              child: SafeArea(child: DownloadWidgetIndicator())
          ),
        ],
      )
    );
  }
}
