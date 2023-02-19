import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:video_player/video_player.dart';
import 'video_viewer_bloc.dart';
import 'video_viewer_bloc_provider.dart';
import 'video_viewer_views.dart';
import 'video_viewer_views_widgets.dart';




class VideoViewer extends StatefulWidget {

  String videoUrl;
  bool videoDownloadable;
  String videoImageUrl;

  VideoViewer({@required this.videoUrl, @required this.videoDownloadable, @required this.videoImageUrl}){
    
    if (videoDownloadable == null){
      videoDownloadable = false;
    }
  }

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {

  VideoViewerBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = VideoViewerBloc();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return VideoViewerBlocProvider(
      bloc: _bloc,
      videoUrl: widget.videoUrl,
      videoImageUrl: widget.videoImageUrl,
      videoDownloadable: widget.videoDownloadable,
      child: Scaffold(
        
        body: CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.transparent,
            border: Border.all(style: BorderStyle.none),
            trailing: DownloadButtonWidget()
          ),

          child: VideoViewerViews()
        ),
      ),
    );
  }
}
