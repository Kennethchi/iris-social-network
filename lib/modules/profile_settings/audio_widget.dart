import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';





import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';



class ProfileSettingsAudioWidget extends StatefulWidget {


  String cachedAudioPath;

  ProfileSettingsAudioWidget({@required this.cachedAudioPath});

  @override
  _ProfileSettingsAudioWidgetState createState() => _ProfileSettingsAudioWidgetState();
}



class _ProfileSettingsAudioWidgetState extends State<ProfileSettingsAudioWidget> with WidgetsBindingObserver{

  AudioPlayer _audioPlayer;

  //FlutterSound _flutterSound;

  BehaviorSubject<bool> _audioIsRetrievedBehaviorSubject = BehaviorSubject<bool>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _audioPlayer = AudioPlayer();

    _audioPlayer.play(widget.cachedAudioPath, isLocal: true);

    _audioPlayer.onPlayerCompletion.listen((_){
      _audioPlayer.resume();
    });


  }


  @override
  void dispose() {
    // TODO: implement dispose

    _audioPlayer.stop();
    _audioPlayer.release();
    _audioPlayer.dispose();

    WidgetsBinding.instance.removeObserver(this);

    _audioIsRetrievedBehaviorSubject?.close();

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.125 * 0.25),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            shape: BoxShape.circle
        ),
        child: FittedBox(
          child: Center(
              child: StreamBuilder<AudioPlayerState>(
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

                          return IconButton(
                            icon: Icon(Icons.pause, color: Colors.white,),
                            onPressed: (){

                              _audioPlayer.pause();

                            },
                          );
                        case AudioPlayerState.PAUSED:
                          return IconButton(
                            icon: Icon(Icons.play_arrow, color: Colors.white,),
                            onPressed: (){

                              _audioPlayer.resume();
                            },
                          );
                        case AudioPlayerState.COMPLETED:
                          return IconButton(
                            icon: Icon(Icons.play_arrow, color: Colors.white,),
                            onPressed: (){

                              _audioPlayer.resume();

                            },
                          );
                      }

                    }
                    else{

                      return Container();
                      return IconButton(
                        icon: Icon(Icons.play_arrow, color: Colors.white,),
                        onPressed: (){


                        },
                      );
                    }

                  }
              )
          ),
        ),
      ),
    );
  }

}


