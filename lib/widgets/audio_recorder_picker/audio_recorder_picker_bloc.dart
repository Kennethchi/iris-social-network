import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class AudioRecorderPickerBlocBlueprint{

  void dispose();
}


class AudioRecorderPickerBloc implements AudioRecorderPickerBlocBlueprint{


  BehaviorSubject<bool> _isRecordingBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsRecordingStream => _isRecordingBehaviorSubject.stream;
  StreamSink<bool> get _getIsRecordingSink => _isRecordingBehaviorSubject.sink;



  void addIsRecordingToStream(bool isRecording){
    _getIsRecordingSink.add(isRecording);
  }




  @override
  void dispose() {

    _isRecordingBehaviorSubject?.close();
  }
}


