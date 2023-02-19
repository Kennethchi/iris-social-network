import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'camera_bloc.dart';
import 'package:camera/camera.dart';
import 'dart:async';



class CameraBlocProvider extends InheritedWidget{

  final CameraBloc bloc;
  final Key key;
  final Widget child;

  final CameraController cameraController;

  CameraBlocProvider({@required this.bloc, @required this.cameraController, this.key, this.child}): super(key: key, child: child){



    cameraController.addListener((){

      if (cameraController.value.isRecordingVideo){


      }
    });

  }


  static CameraBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(CameraBlocProvider) as CameraBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}