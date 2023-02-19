import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'create_message_bloc.dart';
import 'create_message_bloc_provider.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class VideoWidget extends StatefulWidget {

  File videoFile;
  CreateMessageBloc postBloc;

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


          if (snapshot.hasData){
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
  CreateMessageBloc postBloc;


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
      default:
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

                      color: Colors.black.withOpacity(0.2),

                      child: Column(
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

    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
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
                            createMessageContext: context,
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

    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
        stream: _bloc.getIsMessageImagesLimitReachedStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

          if (snapshot.hasData && snapshot.data == true){

            return Container();
          }
          else{

            return GestureDetector(

              onTap: (){

                _provider.handlers.showUploadImageOptionDialog(createMessageContext: context);
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

    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
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

                _provider.handlers.showChangeSelectedUploadAudioImageOptionDialog(createMessageContext: context);

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

                _provider.handlers.showUploadAudioImageOptionDialog(createMessageContext: context);
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

    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
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

                  _provider.handlers.showVideoThumbNailView(createMessageContext: context, videoThumbNailPath: snapshot.data);

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




class CreateMessageMediaIsDownloadableSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Padding(
      padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
      child: StreamBuilder<bool>(
          stream: _bloc.getIsMessageMediaDownloadableStream,
          initialData: true,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

            return Column(
              children: <Widget>[
                ListTile(
                  title: Text("Message Media Downloadable", style: TextStyle(color: _themeData.barBackgroundColor),),
                  trailing: CupertinoSwitch(
                    value: snapshot.data,
                    onChanged: (bool onChangedValue){

                      _bloc.addIsMessageMediaDownloadable(onChangedValue);
                    },
                    activeColor: _themeData.primaryColor,
                  ),
                ),
                SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor),
                  child: Text(snapshot.hasData && snapshot.data? "Your Friend will view and download this media":
                      "Your Friend will only be able to view but NOT download the media"
                    , style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center,),
                )
              ],
            );

          }
      ),
    );
  }
}







class CreateMessageSetupCompleteButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
        stream: CreateMessageBlocProvider.of(context).handlers.getMessageSetupCompleteObservable(createMessageContext: context),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

          return MaterialButton(
            child: Text("DONE",
                style: TextStyle(
                    color: snapshot.data? _themeData.primaryColor: Colors.black.withOpacity(0.2)
                )
            ),
            onPressed: snapshot.data? (){

              //_provider.pageController.animateToPage(2, duration: Duration(seconds: 1), curve: Curves.easeInOutBack);


              AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection){

                if (hasInternetConnection != null && hasInternetConnection){

                  BasicUI.showProgressDialog(pageContext: context, child: SpinKitFadingCircle(color: Colors.white,));

                  _provider.handlers.getMessageModelPlaceholderData(createMessageContext: context).then((MessageModel messageModelPlaceHolderData){

                    Navigator.pop(context);
                    Navigator.of(context).pop(messageModelPlaceHolderData);

                  });

                }
                else{
                  BasicUI.showSnackBar(context: context, message: "No Internet Conection", textColor: CupertinoColors.destructiveRed);
                }

              });



            }: null,
          );

        }
    );
  }
}



