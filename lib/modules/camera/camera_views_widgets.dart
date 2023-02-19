import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'camera_bloc.dart';
import 'camera_bloc_provider.dart';
import 'package:camera/camera.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';





class CameraWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CameraController _cameraController = CameraBlocProvider.of(context).cameraController;
    CameraBloc bloc = CameraBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      child: Transform.scale(
        scale: _cameraController.value.aspectRatio / (MediaQuery.of(context).size.width / MediaQuery.of(context).size.height),
        child: AspectRatio(
          //aspectRatio: _cameraController.value.aspectRatio,
            aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
            child: CameraPreview(_cameraController)
        ),
      ),
    );
  }


}



class CameraRecordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    CameraController _cameraController = CameraBlocProvider.of(context).cameraController;
    CameraBloc bloc = CameraBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return GestureDetector(
      onTap: (){


      },

      child: Container(
        width: screenWidth * scaleFactor * 2,
        height: screenWidth * scaleFactor * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _themeData.primaryColor.withOpacity(0.8)
        ),
      ),
    );
  }
}


class RecordTimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    CameraController _cameraController = CameraBlocProvider.of(context).cameraController;
    CameraBloc bloc = CameraBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container();
  }
}



