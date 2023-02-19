import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'camera_bloc.dart';
import 'camera_bloc_provider.dart';
import 'package:camera/camera.dart';
import 'camera_views_widgets.dart';



class CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CameraController _cameraController = CameraBlocProvider.of(context).cameraController;
    CameraBloc bloc = CameraBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return Container(
      child: Stack(
        children: <Widget>[
          
          Positioned.fill(
            child: CameraWidget(),
          ),

          Positioned(
            bottom: 10.0,
            left: 0.0,
            right: 0.0,
            child: CameraRecordButton(),
          )
          
        ],
      ),
    );
  }
}

