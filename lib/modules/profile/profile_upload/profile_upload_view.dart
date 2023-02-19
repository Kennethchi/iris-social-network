import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/widgets/talent_type_chip/talent_type_chips.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import '../profile_bloc_provider.dart';
import '../profile_bloc.dart';
import 'profile_upload_bloc_provider.dart';
import 'profile_upload_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_upload_view_widgets.dart';
import 'package:page_indicator/page_indicator.dart';







class ProfileUploadView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return  PageIndicatorContainer(
      align: IndicatorAlign.bottom,

      length: 5,
      indicatorSpace: 20.0,
      padding: const EdgeInsets.all(10),
      indicatorColor: RGBColors.black.withOpacity(0.1),
      indicatorSelectorColor: _themeData.primaryColor,
      shape: IndicatorShape.circle(size: screenWidth * scaleFactor * 0.33),

      pageView: PageView(



        children: <Widget>[


          CustomScrollView(

            physics: NeverScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(<Widget>[
                VideoViewWidget(),
              ]))
            ],
          ),

          CustomScrollView(
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(<Widget>[
                VideoCaptionTextFieldWidget(),
              ]))
            ],
          ),

          CustomScrollView(
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(<Widget>[
                VideoThumbnailWidget(),
              ]))
            ],
          ),

          CustomScrollView(
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(<Widget>[
                TalentTypeSelectionWidget(),
              ]))
            ],
          ),


          CustomScrollView(
            slivers: <Widget>[
              SliverList(delegate: SliverChildListDelegate(<Widget>[
                VideoUploadButtonWidget()
              ]))
            ],
          ),



        ],
      ),
    );


    /*
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,

        children: <Widget>[

          VideoViewWidget(videoFile: videoFile),

          VideoCaptionTextFieldWidget(),

          VideoThumbnailWidget(),

          TalentTypeSelectionWidget(),

          VideoUploadButtonWidget()

        ],
      ),
    );
    */

  }

}







