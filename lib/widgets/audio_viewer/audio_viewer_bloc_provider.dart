import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'audio_viewer_bloc.dart';

class AudioViewerBlocProvider extends InheritedWidget{

  final AudioViewerBloc bloc;
  final Key key;
  final Widget child;

  String audioUrl;
  String audioImageUrl;
  bool audioDownloadable;

  AudioViewerBlocProvider({
    @required this.bloc,
    @required this.audioUrl,
    @required this.audioImageUrl,
    @required this.audioDownloadable,
    this.key, this.child
  }): super(key: key, child: child);


  static AudioViewerBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(AudioViewerBlocProvider) as AudioViewerBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}