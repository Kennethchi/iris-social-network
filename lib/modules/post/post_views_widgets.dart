import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'post_bloc.dart';
import 'post_bloc_provider.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'post_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;



class VideoWidget extends StatefulWidget {

  File videoFile;
  PostBloc postBloc;

  VideoWidget({@required this.videoFile, @required this.postBloc});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    _videoPlayerController.initialize().then((_){

      widget.postBloc.addIsVideoInitialisedToStream(true);

      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          showControls: true,
          autoPlay: true,
          looping: true
      );

    });


  }



  @override
  void dispose() {
    // TODO: implement dispose

    _videoPlayerController.dispose();
    _chewieController.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.postBloc.getIsVideoInitialisedStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {


        if (snapshot.hasData && snapshot.data){
          return Chewie(
            controller: _chewieController,
          );
        }
        else{
          return Center(child: CupertinoActivityIndicator());
        }
      }
    );
  }
}





class AudioWidget extends StatefulWidget {

  File audioFile;
  PostBloc postBloc;


  AudioWidget({@required this.audioFile, @required this.postBloc});

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> with WidgetsBindingObserver{

  AudioPlayer _audioPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _audioPlayer = AudioPlayer();

    _audioPlayer.play(widget.audioFile.path, isLocal: true, );

    _audioPlayer.onPlayerCompletion.listen((_){

      _audioPlayer.resume();
    });

  }


  @override
  void dispose() {
    // TODO: implement dispose

    _audioPlayer.release();
    _audioPlayer.dispose();


    WidgetsBinding.instance.removeObserver(this);

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
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<Duration>(
          stream: _audioPlayer.onDurationChanged,
          builder: (BuildContext context, AsyncSnapshot<Duration> totalDurationSnapshot) {


            if (totalDurationSnapshot.hasData){
              widget.postBloc.setAudioDuration = totalDurationSnapshot.data.inSeconds;
            }



            return StreamBuilder<Duration>(
                stream: _audioPlayer.onAudioPositionChanged,
                builder: (BuildContext context, AsyncSnapshot<Duration> positionDurationsnapshot) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
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
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[

                              Text(positionDurationsnapshot.hasData? DateTimeUtils.getTimeFromSeconds(positionDurationsnapshot.data.inSeconds): "00:00", style: TextStyle(
                                  color: CupertinoTheme.of(context).barBackgroundColor
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

                              Text(totalDurationSnapshot.hasData? DateTimeUtils.getTimeFromSeconds(totalDurationSnapshot.data.inSeconds): "00:00", style: TextStyle(
                                  color: CupertinoTheme.of(context).barBackgroundColor
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
      )
    );
  }
  
}








class ImagesListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<List<String>>(
      stream: _bloc.getImagesPathStream,
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        return Container(
          child: Wrap(

            direction: Axis.horizontal,
            alignment: WrapAlignment.center,

            children: <Widget>[

              if (snapshot.hasData)

                for (int index = 0; index < snapshot.data.length; ++index)
                  Padding(
                    padding: EdgeInsets.all(5.0),

                    child: GestureDetector(

                      onTap: (){

                        _provider.handlers.showChangeSelectedUploadImageOptionDialog(
                            postContext: context,
                          imageToChangeIndexInList: index,
                        );

                      },

                      child: Container(
                        width: screenWidth * scaleFactor,
                        height: screenWidth * scaleFactor,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.2),
                          color: Colors.white.withOpacity(0.1),
                          image: DecorationImage(image: FileImage(File(snapshot.data[index])), fit: BoxFit.cover)
                        ),
                        child: Container(
                            width: screenWidth * scaleFactor,
                            height: screenWidth * scaleFactor,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.2),
                              color: Colors.black.withOpacity(0.1),
                            ),
                            child: Icon(Icons.add, color: Colors.white,)
                        ),
                      ),
                    ),
                  ),

              AddImageWidget()

            ],
          ),
        );
      }
    );
  }
}



class AddImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
        stream: _bloc.getIsPostImagesLimitReachedStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

          if (snapshot.hasData && snapshot.data == true){

            return Container();
          }
          else{

            return GestureDetector(

              onTap: (){

                _provider.handlers.showUploadImageOptionDialog(postContext: context);
              },

              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  width: screenWidth * scaleFactor,
                  height: screenWidth * scaleFactor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Icon(Icons.add, color: Colors.white,),
                ),
              ),
            );
          }


        }
    );
  }
}




class AddAudioImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<String>(
        stream: _bloc.getAudioImagePathStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

          if (snapshot.hasData){

            return GestureDetector(

              onTap: (){

                _provider.handlers.showChangeSelectedUploadAudioImageOptionDialog(postContext: context);

              },

              child: Container(
                width: screenWidth * scaleFactor,
                height: screenWidth * scaleFactor,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.2),
                    color: Colors.white.withOpacity(0.1),
                    image: DecorationImage(image: FileImage(File(snapshot.data)), fit: BoxFit.cover)
                ),
                child: Container(
                    width: screenWidth * scaleFactor,
                    height: screenWidth * scaleFactor,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.2),
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: Icon(Icons.add, color: Colors.white,)
                ),
              ),
            );
          }
          else{

            return GestureDetector(

              onTap: (){

                _provider.handlers.showUploadAudioImageOptionDialog(postContext: context);
              },

              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  width: screenWidth * scaleFactor,
                  height: screenWidth * scaleFactor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Icon(Icons.add, color: Colors.white,),
                ),
              ),
            );
          }


        }
    );
  }
}






class VideoThumbNailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Padding(
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<String>(
          stream: _bloc.getVideoThumbNailPathStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

            if (snapshot.hasData){

              return GestureDetector(

                onTap: (){

                  _provider.handlers.showVideoThumbNailView(postContext: context, videoThumbNailPath: snapshot.data);

                },

                child: Container(
                  width: screenWidth * scaleFactor,
                  height: screenWidth * scaleFactor,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.2),
                      color: Colors.white.withOpacity(0.1),
                      image: DecorationImage(image: FileImage(File(snapshot.data)), fit: BoxFit.cover)
                  ),
                  child: Container(
                      width: screenWidth * scaleFactor,
                      height: screenWidth * scaleFactor,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.2),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: Icon(Icons.remove_red_eye, color: Colors.white,)
                  ),
                ),
              );
            }
            else{

              return Container(
                child: Center(
                  child: Text(
                    "Could not get Thumbnail",
                    style: TextStyle(color: _themeData.barBackgroundColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                  ),
                )
              );
            }


          }
      ),
    );
  }
}










class PostAudienceSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Padding(
      padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListTile(
            title: Text("Post \nAudience", style: TextStyle(color: _themeData.barBackgroundColor),),
            trailing: RatingBar(

              itemBuilder: (BuildContext context, int index){

                /*
                if (index == 0){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.lock,
                        color: _themeData.primaryColor,
                      ),
                      SizedBox(height: 10.0,),
                      Text("Only me", style: TextStyle(color: _themeData.primaryColor))
                    ],
                  );
                }

                if (index == 1){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        CupertinoIcons.heart_solid,
                        color: _themeData.primaryColor,
                      ),
                      SizedBox(height: 10.0,),
                      Text("Private", style: TextStyle(color: _themeData.primaryColor),)
                    ],
                  );
                }
                if (index == 2){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.users,
                        color: _themeData.primaryColor,
                      ),
                      SizedBox(height: 10.0,),
                      Text("Public", style: TextStyle(color: _themeData.primaryColor))
                    ],
                  );
                }
                */


                if (index == 0){
                  return Container(
                    padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(screenWidth * scaleFactor * scaleFactor)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.heart_solid,
                          color: _themeData.primaryColor,
                        ),
                        SizedBox(height: 10.0,),
                        Text("Private", style: TextStyle(color: _themeData.primaryColor),)
                      ],
                    ),
                  );
                }
                if (index == 1){
                  return Container(
                    padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(screenWidth * scaleFactor * scaleFactor)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.users,
                          color: _themeData.primaryColor,
                        ),
                        SizedBox(height: 10.0,),
                        Text("Public", style: TextStyle(color: _themeData.primaryColor))
                      ],
                    ),
                  );
                }






              },

              onRatingUpdate: (double ratingValue){

                /*
                if (ratingValue == 0.0){
                  _bloc.addPostAudience(null);
                }
                else if (ratingValue == 1.0){
                  _bloc.addPostAudience(app_constants.PostAudience.only_me);
                }
                else if (ratingValue == 2.0){
                  _bloc.addPostAudience(app_constants.PostAudience.private);
                }
                else if (ratingValue == 3.0){
                  _bloc.addPostAudience(app_constants.PostAudience.public);
                }
                */

                if (ratingValue == 0.0){
                  _bloc.addPostAudience(null);
                }
                else if (ratingValue == 1.0){
                  _bloc.addPostAudience(app_constants.PostAudience.private);
                }
                else if (ratingValue == 2.0){
                  _bloc.addPostAudience(app_constants.PostAudience.public);
                }

              },
              initialRating: 1,
              direction: Axis.horizontal,
              //itemCount: 3,
              itemCount: 2,
              itemPadding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * scaleFactor),
              itemSize: screenWidth * scaleFactor * 1.2,
              glowColor: _themeData.primaryColor,
              alpha: 50,

            ),
          ),
          SizedBox(height: screenWidth * scaleFactor * scaleFactor,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor),
            child: StreamBuilder<String>(
              stream: _bloc.getPostAudienceStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                if (snapshot.hasData){

                  /*
                  if (snapshot.data == app_constants.PostAudience.only_me){
                    return Text("Only you will see this post",
                    style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center,);
                  }
                  */

                  if (snapshot.data == app_constants.PostAudience.private){

                    //return Text("Your followers will see this post", style: TextStyle(color: Colors.white.withOpacity(0.5)),);
                    return Text("This Post will Only be seen by your Friends",
                        style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center );

                  } else if (snapshot.data == app_constants.PostAudience.public){

                    //return Text("Everyone will see this post", style: TextStyle(color: Colors.white.withOpacity(0.5)),);
                    return Text("Every User on this platform will be able to see this Post in the Public Feeds",
                        style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center);

                  }else{

                    return Container(
                      child: Text("Please select an Option", style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center)
                    );
                  }

                }
                else{
                  return Container(
                      child: Text("Please select an Option", style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center)
                  );
                }


              }
            ),
          )
        ],
      )
    );
  }
}




class PostMediaIsDownloadableSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Padding(
      padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
      child: StreamBuilder<bool>(
          stream: _bloc.getIsPostMediaDownloadableStream,
          initialData: true,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

            return Column(
              children: <Widget>[
                ListTile(
                  title: Text("Post Media Downloadable", style: TextStyle(color: _themeData.barBackgroundColor),),
                  trailing: CupertinoSwitch(
                    value: snapshot.data,
                    onChanged: (bool onChangedValue){

                      _bloc.addIsPostMediaDownloadable(onChangedValue);
                    },
                    activeColor: _themeData.primaryColor,
                  ),
                ),
                SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor),
                  child: Text("Post medias will be downloadable by users", style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center,),
                )
              ],
            );

          }
      ),
    );
  }
}



class PostIsSharableSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Padding(
      padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
      child: StreamBuilder<bool>(
          stream: _bloc.getIsPostSharableStream,
          initialData: true,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {


            return Column(
              children: <Widget>[

                ListTile(
                  title: Text("Post Sharable", style: TextStyle(color: _themeData.barBackgroundColor),),
                  trailing: CupertinoSwitch(
                    value: snapshot.data,
                    onChanged: (bool onChangedValue){

                      _bloc.addIsPostSharable(onChangedValue);
                    },
                    activeColor: _themeData.primaryColor,
                  ),
                ),
                SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor),
                  child: Text("Post will be sharable by users", style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center,),
                )
              ],
            );

          }
      ),
    );
  }
}





class PostSetupCompleteButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
      stream: PostBlocProvider.of(context).handlers.getPostSetupCompleteObservable(postContext: context),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

          return MaterialButton(
              child: Text("Next",
                style: TextStyle(
                    color: snapshot.data? _themeData.primaryColor: Colors.black.withOpacity(0.2)
                )
                ),
              onPressed: snapshot.data? (){

                _provider.pageController.animateToPage(2, duration: Duration(seconds: 1), curve: Curves.easeInOutBack);

              }: null,
          );

        }
    );
  }
}



class PublishPostButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
        stream: PostBlocProvider.of(context).handlers.getPostSetupCompleteObservable(postContext: context),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

          return CupertinoButton.filled(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text("PUBLISH",
            ),
            onPressed: snapshot.hasData && snapshot.data? (){


              AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection){

                if (hasInternetConnection != null && hasInternetConnection){

                  if (_provider.postType == constants.PostType.image){
                    _provider.handlers.publishPostImageData(postContext: context).then((_){

                      AppBlocProvider.of(context).bloc.getFirebaseUser().then((FirebaseUser firebaseUser){
                        if (firebaseUser != null){
                          AppBlocProvider.of(context).bloc.increaseUserPoints(
                              userId: firebaseUser.uid,
                              points: achievements_services.RewardsTypePoints.publishing_single_post_reward_point
                          );
                        }
                      });

                    });

                  }
                  else if (_provider.postType == constants.PostType.video){
                    _provider.handlers.publishPostVideoData(postContext: context).then((_){

                      AppBlocProvider.of(context).bloc.getFirebaseUser().then((FirebaseUser firebaseUser){
                        if (firebaseUser != null){
                          AppBlocProvider.of(context).bloc.increaseUserPoints(
                              userId: firebaseUser.uid,
                              points: achievements_services.RewardsTypePoints.publishing_single_post_reward_point
                          );
                        }
                      });

                    });
                  }
                  else if (_provider.postType == constants.PostType.audio){
                    _provider.handlers.publishPostAudioData(postContext: context).then((_){

                      AppBlocProvider.of(context).bloc.getFirebaseUser().then((FirebaseUser firebaseUser){
                        if (firebaseUser != null){
                          AppBlocProvider.of(context).bloc.increaseUserPoints(
                              userId: firebaseUser.uid,
                              points: achievements_services.RewardsTypePoints.publishing_single_post_reward_point
                          );
                        }
                      });

                    });
                  }

                }
                else{
                  BasicUI.showSnackBar(
                    context: context,
                    message: "No Internet Connection",
                    textColor:  CupertinoColors.destructiveRed,
                  );
                }
              });

            }: null,
          );

        }
    );
  }
}



