import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'audio_recorder_picker_bloc.dart';
import 'audio_recorder_picker_bloc_provider.dart';



/*
class AudioRecorderPicker extends StatefulWidget {
  @override
  _AudioRecorderPickerState createState() => _AudioRecorderPickerState();
}

class _AudioRecorderPickerState extends State<AudioRecorderPicker> {

  AudioRecorderPickerBloc _bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = AudioRecorderPickerBloc();

    AudioRecorder.isRecording.then((bool isRecording){

      _bloc.addIsRecordingToStream(isRecording);

    });

  }


  Future<bool> requestMicrophonePermission()async{

    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.microphone]);

    if (permissions[PermissionGroup.microphone]  == PermissionStatus.granted){
      return true;
    }

    return false;
  }



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    requestMicrophonePermission().then((bool isPermissionGranted){

      print(isPermissionGranted);

      if (isPermissionGranted == false){
        Navigator.pop(context);
      }

    });
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return AudioRecorderPickerBlocProvider(
      bloc: _bloc,
      child: Scaffold(

        body: StreamBuilder<String>(

            stream: AppBlocProvider.of(context).bloc.getBackgroundImageStream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            snapshot.hasData? snapshot.data: ""
                        ),
                        fit: BoxFit.cover
                    )
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: app_constants.WidgetsOptions.blurSigmaX,
                      sigmaY: app_constants.WidgetsOptions.blurSigmaY
                  ),
                  child: CupertinoPageScaffold(

                      backgroundColor: Colors.black.withOpacity(0.2),
                      navigationBar: CupertinoNavigationBar(
                        middle: Text("Record Audio", style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                        backgroundColor: Colors.white.withOpacity(0.2),
                      ),

                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            StreamBuilder<bool>(
                              stream: _bloc.getIsRecordingStream,
                              builder: (context, snapshot) {


                                if (snapshot.hasData && !snapshot.data){
                                  return FloatingActionButton(
                                      backgroundColor: CupertinoTheme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      child: Icon(FontAwesomeIcons.microphone),
                                      onPressed: (){

                                        AudioRecorder.start(audioOutputFormat: AudioOutputFormat.AAC);


                                        AudioRecorder.isRecording.then((bool isRecording){

                                          _bloc.addIsRecordingToStream(isRecording);
                                        });
                                      });

                                }

                                if (snapshot.hasData && snapshot.data){
                                  return FloatingActionButton(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      child: Icon(FontAwesomeIcons.stop),
                                      onPressed: ()async{

                                        Recording recording = await AudioRecorder.stop();

                                        Navigator.of(context).pop(File(recording.path));


                                        AudioRecorder.isRecording.then((bool isRecording){

                                          _bloc.addIsRecordingToStream(isRecording);
                                        });

                                      });
                                }

                                return FloatingActionButton(
                                  backgroundColor: CupertinoTheme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  child: Icon(FontAwesomeIcons.microphone),
                                    onPressed: (){

                                      AudioRecorder.start(audioOutputFormat: AudioOutputFormat.AAC);

                                      AudioRecorder.isRecording.then((bool isRecording){

                                        _bloc.addIsRecordingToStream(isRecording);

                                      });
                                    });



                              }
                            )

                          ],
                        ),
                      )

                  ),
                ),
              );

            }
        ),
      ),
    );
  }
}
*/