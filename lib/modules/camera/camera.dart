import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'camera_bloc_provider.dart';
import 'camera_bloc.dart';
import 'camera_views.dart';




class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {


  CameraBloc _bloc;
  CameraController _cameraController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = CameraBloc();

    availableCameras().then((List<CameraDescription> cameraDescrtion){


      _cameraController = CameraController(cameraDescrtion[1], ResolutionPreset.medium);

      _cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });


      getExternalStorageDirectory().then((Directory directory){

        _cameraController.startVideoRecording(directory.path + "/bbb/aaaaaa.mp4");
        Timer(Duration(seconds: 10), (){
          _cameraController.stopVideoRecording();
        });
      });

    });
  }


  @override
  Widget build(BuildContext context) {


    return CameraBlocProvider(
      bloc: _bloc,
      cameraController: _cameraController,
      child: Scaffold(

        body: _cameraController.value.isInitialized? CameraView(): Container(
          child: Center(
            child: Text("No Camera Available", style: TextStyle(
              fontSize: CupertinoTheme.of(context).textTheme.navTitleTextStyle.fontSize,
            ),),
          ),
        )


      ),
    );
  }



}
