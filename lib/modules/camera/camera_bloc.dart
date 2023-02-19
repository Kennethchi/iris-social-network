import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';



abstract class CameraBlocBlueprint{

  void dispose();
}


class CameraBloc implements CameraBlocBlueprint{


  BehaviorSubject<int> _videoElapsedTimeBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getVideoElapsedTimeStream => _videoElapsedTimeBehaviorSubject.stream;
  StreamSink<int> get _getVideoElapsedTimeSink => _videoElapsedTimeBehaviorSubject.sink;


  CameraBloc(){

  }


  void addVideoElapsedTimeToStream(int videoElapsedTime){
    _getVideoElapsedTimeSink.add(videoElapsedTime);
  }


  @override
  void dispose() {

    _videoElapsedTimeBehaviorSubject?.close();
  }


}




