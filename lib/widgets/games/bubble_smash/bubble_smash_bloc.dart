import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'shared_preferences_provider.dart';
import 'dart:async';





enum GameState{

  ON_ENTER,
  ON_EXIT,
  ON_UPDATE,
  ON_STARTED,
  ON_STOPPED

}




abstract class BubbleSmashBlocBlueprint{

  Future<int> getHighScore({@required String savedHighScoreKey});

  Future<bool> saveHighScore({@required String saveHighScoreKey, @required int highScore});

  void dispose();
}



class BubbleSmashBloc implements BubbleSmashBlocBlueprint{

  StreamController<GameState> _gameStateStreamController = StreamController<GameState>.broadcast();
  Stream<GameState> get getGameStateStream => _gameStateStreamController.stream;
  StreamSink<GameState> get _getGameStateSink => _gameStateStreamController.sink;


  StreamController<Color> _selectedBubbleColorStreamController = StreamController<Color>.broadcast();
  Stream<Color> get getSelectedBubbleColorStream => _selectedBubbleColorStreamController.stream;
  StreamSink<Color> get _getSelectedBubbleColorSink => _selectedBubbleColorStreamController.sink;


  StreamController<int> _highScoreStreamController = StreamController<int>.broadcast();
  Stream<int> get getHighScoreStream => _highScoreStreamController.stream;
  StreamSink<int> get _getHighScoreSink => _highScoreStreamController.sink;

  StreamController<int> _currentScoreStreamController = StreamController<int>.broadcast();
  Stream<int> get getCurrentScoreStream => _currentScoreStreamController.stream;
  StreamSink<int> get _getCurrentScoreSink => _currentScoreStreamController.sink;


  BubbleSmashBloc(){

    getHighScore(savedHighScoreKey: SharedPrefsKeys.bubble_smash_score).then((int highScore){
      addHighScoreToStream(highScore: highScore);
    });

  }




  void addGameStateToStream({@required GameState gameState}){
    _getGameStateSink.add(gameState);
  }

  void addSelectedBubbleColorToStream({@required Color selectedColor}){
    _getSelectedBubbleColorSink.add(selectedColor);
  }

  void addHighScoreToStream({@required int highScore}){

    _getHighScoreSink.add(highScore);
  }

  void addCurrentScore({@required int currentScore, @required int scoreValue}){

    _getCurrentScoreSink.add(currentScore + scoreValue);
  }






  @override
  Future<int> getHighScore({@required String savedHighScoreKey}) async{
    return await SharedPrefsProvider.getHighScore(savedHighScoreKey: savedHighScoreKey);
  }


  @override
  Future<bool> saveHighScore({@required String saveHighScoreKey, @required int highScore})async {
    return await SharedPrefsProvider.saveHighScore(saveHighScoreKey: saveHighScoreKey, highScore: highScore);
  }

  @override
  void dispose() {

    _highScoreStreamController?.close();
    _currentScoreStreamController?.close();
    _selectedBubbleColorStreamController?.close();

  }
}


