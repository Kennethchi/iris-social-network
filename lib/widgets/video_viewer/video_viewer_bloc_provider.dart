import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'video_viewer_bloc.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';


class VideoViewerBlocProvider extends InheritedWidget{

  final VideoViewerBloc bloc;
  final Key key;
  final Widget child;

  String videoUrl;
  String videoImageUrl;
  bool videoDownloadable;




  VideoViewerBlocProvider({
    @required this.bloc,
    @required this.videoUrl,
    @required this.videoImageUrl,
    @required this.videoDownloadable, this.key, this.child
  }): super(key: key, child: child);


  static VideoViewerBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(VideoViewerBlocProvider) as VideoViewerBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}




