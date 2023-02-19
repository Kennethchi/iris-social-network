import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:chewie/chewie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'post_room_bloc.dart';
import 'post_room_bloc_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/utils/string_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:iris_social_network/widgets/marquee/marquee.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:iris_social_network/widgets/app_material/app_material.dart';
import 'package:iris_social_network/modules/profile/profile.dart';



class VideoWidget extends StatefulWidget {


  VideoModel videoModel;
  PostRoomBloc postRoomBloc;

  VideoWidget({@required this.videoModel, @required this.postRoomBloc});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> with WidgetsBindingObserver {

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _videoPlayerController = VideoPlayerController.network(widget.videoModel.videoUrl);

    widget.postRoomBloc.addIsVideoBufferingToStream(true);


    _videoPlayerController.initialize().then((_){

      widget.postRoomBloc.addIsVideoInitialisedToStream(true);

      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          autoPlay: true,
          looping: true,
          showControls: false,
          allowFullScreen: false
      );

      _chewieController.videoPlayerController.addListener((){


        int videoPositionInSeconds = _videoPlayerController.value.position.inSeconds;
        int totalVideoDurationInSeconds = _videoPlayerController.value.duration.inSeconds;

        // adds current video duration  position in seconds
        widget.postRoomBloc.addVideoDurationInSecondsToStream(videoPositionInSeconds);

        if (_chewieController.videoPlayerController.value.isPlaying){

          if (widget.postRoomBloc.getIsVideoViewed == false || widget.postRoomBloc.getIsVideoViewed == null){

            // verifies if video
            if (_isVideoViewed(totalDurationInSeconds: totalVideoDurationInSeconds, durationPositionInSeconds: videoPositionInSeconds)){

              widget.postRoomBloc.setIsVideoViewed = true;
              widget.postRoomBloc.addPostVideoView(postId: widget.postRoomBloc.getPostId, postUserId: widget.postRoomBloc.getPostUserId);
            }
          }
        }
        else{


        }


        if (_chewieController.videoPlayerController.value.isBuffering){
          widget.postRoomBloc.addIsVideoBufferingToStream(true);
        }
        else{
          widget.postRoomBloc.addIsVideoBufferingToStream(false);
        }

        // here we considered initialisation as buffering also
        if (_chewieController.videoPlayerController.value.initialized){
          widget.postRoomBloc.addIsVideoBufferingToStream(false);
        }
        else{
          widget.postRoomBloc.addIsVideoBufferingToStream(true);
        }


      });
    });


  }



  bool _isVideoViewed({@required int durationPositionInSeconds, @required int totalDurationInSeconds}) {

    double viewFactor = 0.2;

    if (totalDurationInSeconds <= 60 && durationPositionInSeconds > viewFactor * totalDurationInSeconds){
      return true;
    }
    else if ((totalDurationInSeconds>60 && totalDurationInSeconds <= 60 * 60)
        && durationPositionInSeconds > viewFactor * viewFactor * totalDurationInSeconds)
    {
      return true;
    }
    else if ((totalDurationInSeconds > 60 * 60 && totalDurationInSeconds <= 60 * 60 * 60)
        && durationPositionInSeconds > viewFactor * viewFactor * viewFactor * totalDurationInSeconds)
    {
      return true;
    }
    else if (totalDurationInSeconds > 60 * 60 * 60
        && durationPositionInSeconds > viewFactor * viewFactor * viewFactor * totalDurationInSeconds){
      return true;
    }

    return false;
  }




  @override
  void dispose() {
    // TODO: implement dispose

    _videoPlayerController?.dispose();
    _chewieController?.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);


    switch(state){
      case AppLifecycleState.inactive:
        this._chewieController.pause();
        break;
      case AppLifecycleState.paused:
        this._chewieController.pause();
        break;
      case AppLifecycleState.resumed:
        this._chewieController.play();
        break;
      case AppLifecycleState.detached:
        this._chewieController.pause();
        break;

    }
  }


  @override
  void didUpdateWidget(VideoWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (_chewieController != null){
      _chewieController.pause();
      widget.postRoomBloc.addIsVideoPlayingToStream(false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<bool>(
        stream: widget.postRoomBloc.getIsVideoInitialisedStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

          if (snapshot.hasData){
            return GestureDetector(


              onTap: (){


                bool videoIsPlaying = _chewieController.videoPlayerController.value.isPlaying;
                if (videoIsPlaying){
                  _chewieController.pause();
                  widget.postRoomBloc.addIsVideoPlayingToStream(false);
                }
                else{
                  _chewieController.play();
                  widget.postRoomBloc.addIsVideoPlayingToStream(true);
                }


              },


              child: Chewie(
                controller: _chewieController,
              ),
            );
          }
          else{
            return Center(child: CupertinoActivityIndicator());
          }
        }
    );
  }
}








class NumberOfVideoViewsWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);


    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width),
        color: RGBColors.black.withOpacity(0.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Icon(FontAwesomeIcons.eye, color: RGBColors.light_grey_level_1,),
          SizedBox(height: 10.0,),


          Container(
            child: StreamBuilder<int>(
              stream: _bloc.getNumberOfVideoViewsStream,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot){

                switch(snapshot.connectionState){
                  case ConnectionState.none:
                    return Container();
                  case ConnectionState.waiting:
                    return SpinKitPulse(color: RGBColors.white, size: 15,);

                  case ConnectionState.active: case ConnectionState.done:
                    if (snapshot.hasData){
                      return Text(StringUtils.formatNumber(snapshot.data), style: TextStyle(color: RGBColors.white),);
                    }
                    else{
                      return Container(
                        child: Text("0", style: TextStyle(color: RGBColors.white)),
                      );
                    }

                }

              },
            ),
          )

        ],
      ),
    );
  }
}



class PlayIconWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;



    return StreamBuilder<bool>(
      stream: _bloc.getIsVideoPlayingStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

        if (snapshot.hasData && snapshot.data == false){
          return GestureDetector(

            onTap: (){

              // this function is the same code when user clicks on the video overlay widget


            },

            child: Container(
              padding: EdgeInsets.all(screenWidth * scaleFactor * 0.125),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //color: RGBColors.white.withOpacity(1.0),
              ),
              child: SpinKitPumpingHeart(
                itemBuilder: (BuildContext context, int index){
                  return Icon(FontAwesomeIcons.play, color: _themeData.primaryColor.withOpacity(0.8), size: screenWidth * scaleFactor,);
                },
              ),
            ),
          );
        }
        else{
          return Container();
        }


      },
    );



  }
}





class VideoDurationWidget extends StatelessWidget{

  VideoModel videoModel;

  VideoDurationWidget({@required this.videoModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;



    return StreamBuilder<int>(
      stream: _bloc.getVideoDurationInSecondsStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){

        if (snapshot.hasData){

          return Container(
              padding: EdgeInsets.all(screenWidth * scaleFactor * 0.125),
              decoration: BoxDecoration(
                  color: RGBColors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(screenWidth)
              ),
              child: Text(DateTimeUtils.getTimeFromSeconds(snapshot.data) + " / " + DateTimeUtils.getTimeFromSeconds(videoModel.duration),
                style: TextStyle(color: RGBColors.white.withOpacity(0.7)),)
          );


        }
        else{
          return Container(
              padding: EdgeInsets.all(screenWidth * scaleFactor * 0.125),
              decoration: BoxDecoration(
                  color: RGBColors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(screenWidth)
              ),
              child: Text("00:00 / 00:00",
                style: TextStyle(color: RGBColors.white.withOpacity(0.7)),)
          );
        }


      },
    );



  }
}







class VideoBufferingWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;

    return StreamBuilder<bool>(
      stream: _bloc.getIsVideoBufferingStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

        if (snapshot.hasData && snapshot.data){
          return GradientProgressIndicator(

            gradient: LinearGradient(
              colors: [_themeData.primaryColor, RGBColors.fuchsia],
              //stops: [0.2, 0.8]
            ),
          );
        }

        else{
          return Container();
        }

      },
    );


  }

}


