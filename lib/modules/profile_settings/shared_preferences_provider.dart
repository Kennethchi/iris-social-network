import 'package:meta/meta.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesProvider{

  static Future<bool> saveAppThemeColorValue({@required int colorValue})async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool success = await sharedPreferences.setInt(SharedPrefsKeys.app_theme_color_value, colorValue);

    return success;
  }


  static Future<int> getSavedAppThemeColorValue()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getInt(SharedPrefsKeys.app_theme_color_value);
  }


}