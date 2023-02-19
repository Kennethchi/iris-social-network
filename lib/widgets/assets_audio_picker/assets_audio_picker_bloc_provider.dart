import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'assets_audio_picker_bloc.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'assets_audio_picker_handlers.dart';



class AssetsAudioPickerBlocProvider extends InheritedWidget{

  final AssetsAudioPickerBloc bloc;
  final Key key;
  final Widget child;

  List<AssetsAudioModel> assetsAudioModalList;

  AssetsAudioPickerHandlers handlers;

  AssetsAudioPickerBlocProvider({@required this.bloc, @required this.assetsAudioModalList, this.key, this.child}): super(key: key, child: child){

    handlers = AssetsAudioPickerHandlers();
  }


  static AssetsAudioPickerBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(AssetsAudioPickerBlocProvider) as AssetsAudioPickerBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}