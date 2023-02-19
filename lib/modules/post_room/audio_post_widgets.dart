import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
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
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_widgets/flutter_widgets.dart';




class AudioWidget extends StatefulWidget {

  AudioModel audioModel;

  PostRoomBloc postRoomBloc;


  AudioWidget({@required this.audioModel, @required this.postRoomBloc});

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> with WidgetsBindingObserver{

  AudioPlayer _audioPlayer;

  //FlutterSound _flutterSound;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);


    _audioPlayer = AudioPlayer();

    //_flutterSound = FlutterSound();


    //_flutterSound.startPlayer(widget.audioModel.audioUrl);


    _audioPlayer.play(widget.audioModel.audioUrl, isLocal: false, );

    _audioPlayer.onPlayerCompletion.listen((_){

      _audioPlayer.resume();
    });


    _audioPlayer.onAudioPositionChanged.listen((Duration positionDuration){

      if (widget.postRoomBloc.getIsAudioListened == false || widget.postRoomBloc.getIsAudioListened == null){

        if (_isAudioListened(durationPositionInSeconds: positionDuration.inSeconds, totalDurationInSeconds: widget.audioModel.duration)){

          widget.postRoomBloc.setIsAudioListened = true;
          widget.postRoomBloc.addPostAudioListen(postId: widget.postRoomBloc.getPostId, postUserId: widget.postRoomBloc.getPostUserId);
        }
      }

    });


  }


  bool _isAudioListened({@required int durationPositionInSeconds, @required int totalDurationInSeconds}) {

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

    _audioPlayer.stop();
    _audioPlayer.release();
    _audioPlayer.dispose();

    WidgetsBinding.instance.removeObserver(this);


    //_flutterSound.stopPlayer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);


    switch(state){
      case AppLifecycleState.inactive:
        this._audioPlayer.stop();
        break;
      case AppLifecycleState.paused:
        this._audioPlayer.pause();
        break;
      case AppLifecycleState.resumed:
        this._audioPlayer.resume();
        break;
      case AppLifecycleState.detached:
        this._audioPlayer.stop();
        break;
    }
  }




  @override
  void didUpdateWidget(AudioWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    //_audioPlayer.pause();

  }


  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (VisibilityInfo info){

        if (info.visibleFraction == 0.0){
          _audioPlayer.stop();
          _audioPlayer.release();
        }

      },
      child: Container(

          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                decoration: BoxDecoration(
                    image: widget.audioModel.audioThumb != null? DecorationImage(
                        image: CachedNetworkImageProvider(widget.audioModel.audioThumb),
                        fit: BoxFit.cover
                    ): DecorationImage(
                      image: AssetImage(AppBackgroundImages.audio_background_image_orion_nebula),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.pinkAccent.withOpacity(0.9), BlendMode.color)
                    )
                ),
                child: SafeArea(
                  child: Icon(
                    FontAwesomeIcons.music,
                    color: Colors.white.withOpacity(0.15),
                    size: MediaQuery.of(context).size.width * 0.75,
                  ),
                ),
              ),


              
              SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.125 * 0.25),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.125 * 0.33)
                  ),
                  child: Center(
                    child: StreamBuilder<Duration>(
                        stream: _audioPlayer.onDurationChanged,
                        builder: (BuildContext context, AsyncSnapshot<Duration> totalDurationSnapshot) {

                          return StreamBuilder<Duration>(
                              stream: _audioPlayer.onAudioPositionChanged,
                              builder: (BuildContext context, AsyncSnapshot<Duration> positionDurationsnapshot) {


                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      LinearPercentIndicator(
                                        animation: false,
                                        lineHeight: 5.0,
                                        animationDuration: 2500,
                                        percent: totalDurationSnapshot.hasData && positionDurationsnapshot.hasData
                                            ? (positionDurationsnapshot.data.inMilliseconds / totalDurationSnapshot.data.inMilliseconds).clamp(0.0, 1.0): 0.0,
                                        linearStrokeCap: LinearStrokeCap.roundAll,
                                        progressColor: CupertinoTheme.of(context).primaryColor,
                                        backgroundColor: CupertinoTheme.of(context).primaryColor.withAlpha(80),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width * 0.125 * 0.5
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[

                                            Text(positionDurationsnapshot.hasData? DateTimeUtils.getTimeFromSeconds(positionDurationsnapshot.data.inSeconds): "00:00",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: CupertinoTheme.of(context).textTheme.navTitleTextStyle.fontSize
                                              ),),

                                            StreamBuilder<AudioPlayerState>(
                                                stream: _audioPlayer.onPlayerStateChanged,
                                                builder: (BuildContext context, AsyncSnapshot<AudioPlayerState> snapshot) {

                                                  if (snapshot.hasData){

                                                    switch(snapshot.data){
                                                      case AudioPlayerState.STOPPED:
                                                        return Container(
                                                          padding: EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(
                                                              color: CupertinoTheme.of(context).primaryColor,
                                                              shape: BoxShape.circle
                                                          ),
                                                          child: IconButton(
                                                            icon: Icon(Icons.play_arrow, color: Colors.white,),
                                                            onPressed: (){

                                                              _audioPlayer.resume();

                                                            },
                                                          ),
                                                        );
                                                      case AudioPlayerState.PLAYING:

                                                        return Container(
                                                          padding: EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(
                                                              color: CupertinoTheme.of(context).primaryColor,
                                                              shape: BoxShape.circle
                                                          ),
                                                          child: IconButton(
                                                            icon: Icon(Icons.pause, color: Colors.white,),
                                                            onPressed: (){

                                                              _audioPlayer.pause();

                                                            },
                                                          ),
                                                        );
                                                      case AudioPlayerState.PAUSED:
                                                        return Container(
                                                          padding: EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(
                                                              color: CupertinoTheme.of(context).primaryColor,
                                                              shape: BoxShape.circle
                                                          ),
                                                          child: IconButton(
                                                            icon: Icon(Icons.play_arrow, color: Colors.white,),
                                                            onPressed: (){

                                                              _audioPlayer.resume();
                                                            },
                                                          ),
                                                        );
                                                      case AudioPlayerState.COMPLETED:
                                                        return Container(
                                                          padding: EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(
                                                              color: CupertinoTheme.of(context).primaryColor,
                                                              shape: BoxShape.circle
                                                          ),
                                                          child: IconButton(
                                                            icon: Icon(Icons.play_arrow, color: Colors.white,),
                                                            onPressed: (){

                                                              _audioPlayer.resume();

                                                            },
                                                          ),
                                                        );
                                                    }

                                                  }
                                                  else{
                                                    return Container();
                                                  }

                                                }
                                            ),

                                            Text(totalDurationSnapshot.hasData? DateTimeUtils.getTimeFromSeconds(totalDurationSnapshot.data.inSeconds): "00:00",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: CupertinoTheme.of(context).textTheme.navTitleTextStyle.fontSize

                                              ),)

                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                );
                              }
                          );
                        }
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

}







class NumberOfAudioListensWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width),
        color: RGBColors.black.withOpacity(0.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Icon(FontAwesomeIcons.headphonesAlt, color: RGBColors.light_grey_level_1,),
          SizedBox(width: screenWidth * scaleFactor * scaleFactor,),


          Container(
            child: StreamBuilder<int>(
              stream: _bloc.getNumberOfAudioListensStream,
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

