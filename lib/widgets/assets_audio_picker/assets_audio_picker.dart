import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'assets_audio_picker_view.dart';
import 'assets_audio_picker_bloc.dart';
import 'assets_audio_picker_bloc_provider.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'package:iris_social_network/services/constants/medias_constants.dart' as media_constants;


class AssetsAudioPicker extends StatefulWidget {


  @override
  _AssetsAudioPickerState createState() => _AssetsAudioPickerState();
}

class _AssetsAudioPickerState extends State<AssetsAudioPicker> {


  AssetsAudioPickerBloc _bloc;


  List<AssetsAudioModel> assetsAudioModalList;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = AssetsAudioPickerBloc();

    assetsAudioModalList = media_constants.AudioContants.getProfileSoundsAssetModels;
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AssetsAudioPickerBlocProvider(
      bloc: _bloc,
      assetsAudioModalList: this.assetsAudioModalList,
      child: Scaffold(

        backgroundColor: Colors.transparent,
        body: CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
            child: AssetsAudioPickerView()
        ),
      ),
    );
  }
}
