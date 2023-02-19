import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart' as assets_constants;
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'package:iris_social_network/utils/string_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:animator/animator.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';






class VideoPostPreviewWidget extends StatelessWidget{

  PostModel postModel;

  VideoModel videoModel;

  int colorValue;

  VideoPostPreviewWidget({@required this.postModel, @required this.colorValue}){

    videoModel = VideoModel.fromJson(postModel.postData);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    double videoPreviewRadius = screenWidth * scaleFactor * 0.125 * 2;


    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(videoPreviewRadius),
          image: DecorationImage(
              image: CachedNetworkImageProvider(this.videoModel.videoThumb),
              fit: BoxFit.cover
          )
      ),
      child: Stack(
        children: <Widget>[

          Positioned(
              top: screenWidth * scaleFactor * scaleFactor,
              right: screenWidth * scaleFactor * scaleFactor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(FontAwesomeIcons.film, color: Color(this.colorValue),),
                  SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                  Text(
                    this.videoModel.duration == null? "": DateTimeUtils.getTimeFromSeconds(this.videoModel.duration),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              )
          ),


          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[


                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * 0.25, horizontal: screenWidth * scaleFactor * 0.25),
                  child: Text(
                    this.postModel.postCaption != null? this.postModel.postCaption: "",
                    style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.title.fontSize, fontWeight: FontWeight.bold),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),


                Container(
                  padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: RGBColors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(videoPreviewRadius),
                          bottomRight: Radius.circular(videoPreviewRadius)
                      )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        children: <Widget>[
                          
                          
                          Flexible(
                            child: Text(
                              this.postModel.userProfileName, style: TextStyle(
                                color: RGBColors.white,
                                fontWeight: FontWeight.bold,
                            ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          if (this.postModel.verifiedUser != null && this.postModel.verifiedUser)
                            SizedBox(width: 4.0,),

                          Container(
                            child: this.postModel.verifiedUser != null && this.postModel.verifiedUser
                                ? Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: 12.0,)
                                : Container(),
                          )
                        ],
                      ),

                      Text(
                        "@" + this.postModel.userName,
                        style: TextStyle(
                          color: RGBColors.white.withOpacity(0.8),
                          fontSize: Theme.of(context).textTheme.caption.fontSize
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )

                    ],
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }


}









class ImagePostPreviewWidget extends StatelessWidget{

  PostModel postModel;

  ImageModel imageModel;

  int colorValue;

  ImagePostPreviewWidget({@required this.postModel, @required this.colorValue}){

    imageModel = ImageModel.fromJson(postModel.postData);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    double postPreviewRadius = screenWidth * scaleFactor * 0.125 * 2;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(postPreviewRadius),

          image: DecorationImage(
              image: CachedNetworkImageProvider(this.imageModel.imagesThumbsUrl[0]),
              fit: BoxFit.cover
          )
      ),
      child: Stack(
        children: <Widget>[

          Positioned(
              top: screenWidth * scaleFactor * scaleFactor,
              right: screenWidth * scaleFactor * scaleFactor,
              child: Icon(imageModel.imagesUrl.length > 1? FontAwesomeIcons.solidImages: FontAwesomeIcons.solidImage, color: Color(this.colorValue),)
          ),


          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[

                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * 0.25, horizontal: screenWidth * scaleFactor * 0.25),
                  child: Text(
                    this.postModel.postCaption != null? this.postModel.postCaption: "",
                    style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.title.fontSize, fontWeight: FontWeight.bold),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: RGBColors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(postPreviewRadius),
                          bottomRight: Radius.circular(postPreviewRadius)
                      )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        children: <Widget>[

                          Flexible(
                            child: Text(
                              this.postModel.userProfileName, style: TextStyle(
                                color: RGBColors.white,
                                fontWeight: FontWeight.bold,
                            ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          if (this.postModel.verifiedUser != null && this.postModel.verifiedUser)
                            SizedBox(width: 4.0,),

                          Container(
                            child: this.postModel.verifiedUser != null && this.postModel.verifiedUser
                                ? Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: 12.0,)
                                : Container(),
                          )
                        ],
                      ),

                      Text(
                        "@" + this.postModel.userName,
                        style: TextStyle(
                          color: RGBColors.white.withOpacity(0.8),
                            fontSize: Theme.of(context).textTheme.caption.fontSize
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )

                    ],
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }


}







class AudioPostPreviewWidget extends StatelessWidget{

  PostModel postModel;

  AudioModel audioModel;

  int colorValue;

  AudioPostPreviewWidget({@required this.postModel, @required this.colorValue}){

    audioModel = AudioModel.fromJson(postModel.postData);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    double postPreviewRadius = screenWidth * scaleFactor * 0.125 * 2;


    return Container(

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(postPreviewRadius),

          image: this.audioModel.audioThumb != null? DecorationImage(
              image: CachedNetworkImageProvider(this.audioModel.audioThumb),
            fit: BoxFit.cover
          ): DecorationImage(
            image: AssetImage(AppBackgroundImages.audio_background_image_orion_nebula),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.pinkAccent.withOpacity(0.9), BlendMode.color)
          )
      ),

      child: Stack(
        children: <Widget>[
          
          Center(
            child: Icon(FontAwesomeIcons.music, color: Colors.white.withOpacity(0.3), size: screenWidth * scaleFactor * 2,),
          ),
          Positioned(
              top: screenWidth * scaleFactor * scaleFactor,
              right: screenWidth * scaleFactor * scaleFactor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(FontAwesomeIcons.headphonesAlt, color: Color(this.colorValue),),
                  SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                  Text(
                    this.audioModel.duration == null? "": DateTimeUtils.getTimeFromSeconds(this.audioModel.duration),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              )
          ),


          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * 0.25, horizontal: screenWidth * scaleFactor * 0.25),
                  child: Text(
                    this.postModel.postCaption != null? this.postModel.postCaption: "",
                    style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.title.fontSize, fontWeight: FontWeight.bold),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),



                Container(
                  padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: RGBColors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(postPreviewRadius),
                          bottomRight: Radius.circular(postPreviewRadius)
                      )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        children: <Widget>[
                          
                          
                          Flexible(
                            child: Text(
                              this.postModel.userProfileName, style: TextStyle(
                                color: RGBColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: CupertinoTheme.of(context).textTheme.navTitleTextStyle.fontSize
                            ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          if (this.postModel.verifiedUser != null && this.postModel.verifiedUser)
                            SizedBox(width: 4.0,),

                          Container(
                            child: this.postModel.verifiedUser != null && this.postModel.verifiedUser
                                ? Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: 12.0,)
                                : Container(),
                          )
                        ],
                      ),

                      Text(
                        "@" + this.postModel.userName,
                        style: TextStyle(
                            color: RGBColors.white.withOpacity(0.8),
                            fontSize: Theme.of(context).textTheme.caption.fontSize
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )

                    ],
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }


}



