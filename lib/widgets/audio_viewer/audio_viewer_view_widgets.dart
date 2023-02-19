import 'dart:io';

import 'package:animator/animator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:iris_social_network/widgets/app_material/app_material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'audio_viewer_bloc.dart';
import 'audio_viewer_bloc_provider.dart';



class AudioWidget extends StatefulWidget {

  String audioUrl;
  AudioViewerBloc audioViewerBloc;


  AudioWidget({@required this.audioUrl, @required this.audioViewerBloc});

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

    _audioPlayer.play(widget.audioUrl, isLocal: false, );

    /*
    _audioPlayer.onPlayerCompletion.listen((_){

      _audioPlayer.resume();
    });
    */

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
    return StreamBuilder<Duration>(
        stream: _audioPlayer.onDurationChanged,
        builder: (BuildContext context, AsyncSnapshot<Duration> totalDurationSnapshot) {


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
    );
  }

}










class DownloadButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    AudioViewerBlocProvider _provider = AudioViewerBlocProvider.of(context);
    AudioViewerBloc _bloc = AudioViewerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    if(_provider.audioDownloadable != null && _provider.audioDownloadable){
      return Container(

        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(

              borderRadius: BorderRadius.circular(15.0),
              onTap: (){

                AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection)async{


                  if (hasInternetConnection != null && hasInternetConnection){

                    _bloc.addIsMediaDownloadingToStream(true);


                    String savePath = "";
                    Directory directory;

                    if (Platform.isAndroid){
                      directory = Directory((await getExternalStorageDirectory()).path + AppStoragePaths.getAudioDirectoryPath);
                    }
                    else{
                      directory = Directory((await getApplicationDocumentsDirectory()).path + AppStoragePaths.getAudioDirectoryPath);
                    }

                    if (directory.existsSync()){
                      print(directory.path);
                      savePath = directory.path +  DateTime.now().toString() + FileExtensions.mp3;
                    }
                    else{
                      directory.createSync(recursive: true);
                      savePath = directory.path + DateTime.now().toString() + FileExtensions.mp3;
                    }



                    _bloc.downLoadFile(urlPath: _provider.audioUrl,
                        savePath: savePath,
                        progressSink: _bloc.getProgressTransferDataSink,
                        totalSink: _bloc.getTotalTransferDataSink
                    ).then((File downloadedAudioFile){

                      _bloc.addIsMediaDownloadingToStream(false);

                      if (downloadedAudioFile != null && downloadedAudioFile.existsSync()){

                        BasicUI.showSnackBar(
                            context: context,
                            message: "Download Successful \nAudio saved to \"${downloadedAudioFile.path}\"",
                            textColor:  _themeData.primaryColor,
                            duration: Duration(seconds: 10)
                        );

                      }
                      else{
                        BasicUI.showSnackBar(
                          context: context,
                          message: "An error occured while downloading Audio",
                          textColor:  CupertinoColors.destructiveRed,
                        );
                      }

                    });

                  }
                  else{
                    BasicUI.showSnackBar(
                        context: context,
                        message: "No Internet Connection",
                        textColor:  CupertinoColors.destructiveRed,
                        duration: Duration(seconds: 1)
                    );
                  }

                });


              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Download", style: TextStyle(color: Colors.white.withOpacity(0.8)),),
              )
          ),
        ),
      );
    }


    return Container();
  }
}








class DownloadWidgetIndicator extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AudioViewerBloc _bloc = AudioViewerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return StreamBuilder<bool>(
        stream: _bloc.getIsMediaDownloadingStream,
        builder: (context, snapshot) {


          if (snapshot.hasData && snapshot.data){
            return Animator(
              tween: Tween<double>(begin: 1.0, end: 0.0),
              repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(seconds: 1),
              builder: (anim){
                return Transform.translate(
                    offset: Offset(screenWidth * anim.value , 0.0),
                    child: Opacity(
                      opacity: 0.7,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                        child: Card(
                          elevation: 30.0,
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              //color: _themeData.primaryColor,
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.zero,
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.zero,
                              ),
                            ),
                            child: Center(
                              child: FittedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      ProgressPercentIndicator(
                                        progressPercentRatioStream: _bloc.getPercentRatioProgressStream,
                                        //color: RGBColors.fuchsia,
                                        color: _themeData.primaryColor,
                                      ),
                                      SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                                      Text("Downloading...", style: TextStyle(
                                        //color: RGBColors.fuchsia,
                                          color: _themeData.primaryColor,
                                          fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )
                              ),

                              //child: SpinKitCircle(color: Colors.white,),
                            ),
                          ),
                        ),
                      ),
                    )
                );
              },
            );

          }
          else{
            return Container();
          }

        }
    );

  }

}


