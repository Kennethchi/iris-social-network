import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'audio_viewer_bloc.dart';
import 'audio_viewer_bloc_provider.dart';
import 'audio_viewer_view_widgets.dart';
import 'audio_viewer_views.dart';




class AudioViewer extends StatefulWidget {

  String audioUrl;
  bool audioDownloadable;
  String audioImageUrl;

  AudioViewer({@required this.audioUrl, @required this.audioDownloadable, @required this.audioImageUrl}){

    if (audioDownloadable == null){
      audioDownloadable = false;
    }
  }

  @override
  _AudioViewerState createState() => _AudioViewerState();
}

class _AudioViewerState extends State<AudioViewer> {

  AudioViewerBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = AudioViewerBloc();



  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return AudioViewerBlocProvider(
      bloc: _bloc,
      audioUrl: widget.audioUrl,
      audioImageUrl: widget.audioImageUrl,
      audioDownloadable: widget.audioDownloadable,
      child: Scaffold(

        body: CupertinoPageScaffold(
            backgroundColor: Colors.transparent,
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Colors.transparent,
              border: Border.all(style: BorderStyle.none),
              trailing: DownloadButtonWidget(),
            ),

            child: AudioViewerViews()
        ),
      ),
    );
  }
}
