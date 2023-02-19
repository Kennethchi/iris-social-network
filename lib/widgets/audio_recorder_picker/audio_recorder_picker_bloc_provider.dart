import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'audio_recorder_picker_bloc.dart';

class AudioRecorderPickerBlocProvider extends InheritedWidget{

  final AudioRecorderPickerBloc bloc;
  final Key key;
  final Widget child;

  AudioRecorderPickerBlocProvider({@required this.bloc, this.key, this.child}): super(key: key, child: child);


  static AudioRecorderPickerBlocProvider of(BuildContext context) => (
      context.inheritFromWidgetOfExactType(AudioRecorderPickerBlocProvider) as AudioRecorderPickerBlocProvider
  );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}