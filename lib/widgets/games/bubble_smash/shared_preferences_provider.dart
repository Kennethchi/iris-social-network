import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';




class SharedPrefsProvider{

  static Future<int> getHighScore({@required String savedHighScoreKey})async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(savedHighScoreKey);
  }


  static Future<bool> saveHighScore({@required String saveHighScoreKey, @required int highScore})async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(saveHighScoreKey, highScore);
  }


}