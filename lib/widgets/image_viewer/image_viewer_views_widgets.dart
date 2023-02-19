import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'image_viewer_bloc.dart';
import 'image_viewer_bloc_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'dart:ui';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;





class ImageCountWidget extends StatelessWidget{

  int totalImages;

  ImageCountWidget({@required this.totalImages});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ImageViewerBloc _bloc = ImageViewerBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;



    return StreamBuilder<int>(
      stream: _bloc.getImagesCurrentIndexStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){

        if (snapshot.hasData){

          return Container(
              padding: EdgeInsets.all(screenWidth * scaleFactor * 0.125),
              decoration: BoxDecoration(
                  color: RGBColors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(screenWidth)
              ),
              child: Text("${snapshot.data + 1}" + " / " + "${totalImages}",
                style: TextStyle(color: RGBColors.white.withOpacity(0.7), fontSize: Theme.of(context).textTheme.subhead.fontSize),)
          );


        }
        else{
          return Container(
              padding: EdgeInsets.all(screenWidth * scaleFactor * 0.125),
              decoration: BoxDecoration(
                  color: RGBColors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(screenWidth)
              ),
              child: Text("0 / 0",
                style: TextStyle(color: RGBColors.white.withOpacity(0.7), fontSize: Theme.of(context).textTheme.subhead.fontSize),)
          );
        }


      },
    );



  }
}

