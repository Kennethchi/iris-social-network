import 'package:flutter/material.dart';
import 'dart:async';


abstract class OverlayBlocBlueprint{

  void dispose();
}



class OverlayBloc implements OverlayBlocBlueprint{


  StreamController<bool> _overlayEntryActiveStreamController = StreamController<bool>.broadcast();
  Stream<bool> get getOverlayEntryActiveStream => _overlayEntryActiveStreamController.stream;
  StreamSink<bool> get _getOverlayEntryActiveSink => _overlayEntryActiveStreamController.sink;


  void addOverlayEntryActive(bool active){
    _getOverlayEntryActiveSink.add(active);
  }


  @override
  void dispose() {
    _overlayEntryActiveStreamController?.close();
  }
}