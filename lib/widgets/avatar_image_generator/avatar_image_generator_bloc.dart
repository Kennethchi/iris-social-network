import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:avataaar_image/avataaar_image.dart';

abstract class AvatarImageGeneratorBlocBlueprint{

  void dispose();
}


class AvatarImageGeneratorBloc implements AvatarImageGeneratorBlocBlueprint{

  Avataaar _selectedGeneratedAvatar;
  Avataaar get getSelectedGeneratedAvatar => _selectedGeneratedAvatar;
  set setSelectedGeneratedAvatar(Avataaar selectedGeneratedAvatar) {
    _selectedGeneratedAvatar = selectedGeneratedAvatar;
  }


  BehaviorSubject<Avataaar> _selectedGeneratedAvatarBehaviorSubject = BehaviorSubject<Avataaar>();
  Stream<Avataaar> get getSelectedGeneratedAvatarStream => _selectedGeneratedAvatarBehaviorSubject.stream;
  StreamSink<Avataaar> get _getSelectedGeneratedAvatarSink => _selectedGeneratedAvatarBehaviorSubject.sink;

  BehaviorSubject<List<Avataaar>> _generatedAvatarListBehaviorSubject = BehaviorSubject<List<Avataaar>>();
  Stream<List<Avataaar>> get getGeneratedAvatarListStream => _generatedAvatarListBehaviorSubject.stream;
  StreamSink<List<Avataaar>> get _getGeneratedAvatarListSink => _generatedAvatarListBehaviorSubject.sink;





  AvatarImageGeneratorBloc(){

  }



  void addGeneratedAvatarListToStream(List<Avataaar> generatedAvatarList){
    _getGeneratedAvatarListSink.add(generatedAvatarList);
  }

  void addGeneratedAvatarToStream(Avataaar selectedGeneratedAvatar){
    this.setSelectedGeneratedAvatar = selectedGeneratedAvatar;
    _getSelectedGeneratedAvatarSink.add(selectedGeneratedAvatar);
  }


  @override
  void dispose() {

    _generatedAvatarListBehaviorSubject?.close();
  }
}


