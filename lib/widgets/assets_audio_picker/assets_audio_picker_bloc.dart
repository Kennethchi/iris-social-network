import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class AssetsAudioPickerBlocBlueprint{

  void dispose();
}


class AssetsAudioPickerBloc implements AssetsAudioPickerBlocBlueprint{


  BehaviorSubject<int> _selectedAudioIndexBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getSelectedAudioIndexStream => _selectedAudioIndexBehaviorSubject.stream;
  StreamSink<int> get _getSelectedAudioIndexStream => _selectedAudioIndexBehaviorSubject.sink;




  void addSelectedAudioIndexToStream(int selectedAudioIndex){
    _getSelectedAudioIndexStream.add(selectedAudioIndex);
  }



  @override
  void dispose() {

    _selectedAudioIndexBehaviorSubject?.close();
  }
}


