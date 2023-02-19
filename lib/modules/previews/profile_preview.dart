import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_user_model.dart';
import 'package:iris_social_network/modules/profile/profile.dart';








class ProfilePreview extends StatelessWidget{


  OptimisedUserModel optimisedUserModel;


  ProfilePreview({@required this.optimisedUserModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(
      padding: EdgeInsets.symmetric(vertical: scaleFactor * screenHeight * 0.5, horizontal: scaleFactor * screenWidth * 0.5),
      child: Column(
        children: <Widget>[

          CircleAvatar(
            backgroundColor: RGBColors.light_grey_level_1,
            radius: scaleFactor * screenWidth,
            backgroundImage: CachedNetworkImageProvider(optimisedUserModel.thumb),
          ),
          SizedBox(height: 20.0,),


          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserId: this.optimisedUserModel.userId))
              );
            },
            child: Column(
              children: <Widget>[

                Text(optimisedUserModel.name, style: TextStyle(
                    color: _themeData.primaryColor,
                    fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                ),),

                Text("@" + optimisedUserModel.userId, overflow: TextOverflow.ellipsis,)

              ],
            ),
          ),
          Divider(height: scaleFactor * screenHeight * 0.25, color: _themeData.primaryColor),

          Row(
            children: <Widget>[

              Column(
                children: <Widget>[

                  Text("Videos"),
                  Text(optimisedUserModel.nP.toString(), style: TextStyle(
                      color: _themeData.primaryColor,
                      fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                  ))

                ],
              ),
              Spacer(),

              Column(
                children: <Widget>[

                  Text("Followers"),
                  Text(optimisedUserModel.nFr.toString(), style: TextStyle(
                      color: _themeData.primaryColor,
                      fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                  ))

                ],
              ),
              Spacer(),

              Column(
                children: <Widget>[

                  Text("Following"),
                  Text(optimisedUserModel.nFg.toString(), style: TextStyle(
                      color: _themeData.primaryColor,
                      fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                  ))

                ],
              )

            ],
          )

        ],
      ),

    );
  }


}


















