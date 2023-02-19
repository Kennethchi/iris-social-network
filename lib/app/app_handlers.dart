import 'dart:io';
import 'dart:math' as math;

import 'package:animator/animator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/app_services/remote_config_services.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/utils/basic_utils.dart';
import 'package:iris_social_network/widgets/app_material/app_material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_bloc.dart';


class AppHandler {


  Future<bool> getHasInternetDataConnection()async{

    /*
    DataConnectionChecker dataConnectionChecker = DataConnectionChecker();
    return await dataConnectionChecker.hasConnection;
    */

    return await BasicUtils.getIsInternetConnectionAvailable();
  }



  static Future<void> setHomeMainPage({@required String mainPage})async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPrefsKeys.home_main_page, mainPage);
  }


  static Future<String> getHomeMainPage()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getString(SharedPrefsKeys.home_main_page);
  }


  Future<void> showQuitAppOption({@required BuildContext pageContext, @required String message}) async{

    await showCupertinoModalPopup(
        context: pageContext,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text(message),
            actions: <Widget>[

              CupertinoActionSheetAction(

                child: Center(
                    child: Text("Yes", style: TextStyle(
                      color: CupertinoTheme.of(context).primaryColor
                    ),)
                ),
                onPressed: ()async{

                  await Navigator.pop(context);
                  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
                },
              ),

              CupertinoActionSheetAction(
                child: Center(
                    child: Text("No", style: TextStyle(
                      color: CupertinoTheme.of(context).primaryColor,
                    ),)
                ),
                onPressed: ()async{
                  Navigator.pop(context);
                },
              ),

            ],

          );
        }
    );
  }






  Future<void> showCancelOperationOption({@required BuildContext pageContext, @required String message}) async{

    await showCupertinoModalPopup(
        context: pageContext,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text(message),
            actions: <Widget>[

              CupertinoActionSheetAction(

                child: Center(
                    child: Text("Yes", style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor
                    ),)
                ),
                onPressed: ()async{

                  // Here you have to cancel the upload




                  Navigator.pop(context);
                  Navigator.pop(context);

                },
              ),

              CupertinoActionSheetAction(
                child: Center(
                    child: Text("No", style: TextStyle(
                      color: CupertinoTheme.of(context).primaryColor,
                    ),)
                ),
                onPressed: ()async{
                  Navigator.pop(context);
                },
              ),

            ],

          );
        }
    );
  }



  Future<void> showProgressPercentDialog({@required BuildContext context, @required Stream<double> progressPercentRatioStream}){

    BasicUI.showProgressDialog(pageContext: context, child: ProgressPercentIndicator(progressPercentRatioStream: progressPercentRatioStream,));
  }




  static Future<bool> getIfAppHasNewUpdateVersion()async{

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    RemoteConfig remoteConfig = RemoteConfig();

    await remoteConfig.fetch(expiration: Duration.zero);
    await remoteConfig.activateFetched();

    String app_new_version = remoteConfig.getString(RemoteConfigKeys.app_new_version);


    List<String> tokensList = app_new_version.split("+");
    String new_app_version_string = tokensList[0].replaceAll(".", "").trim();
    int new_app_version = int.parse(new_app_version_string);
    int new_app_version_build = int.parse(tokensList[1]);

    String current_app_new_version_string = packageInfo.version.replaceAll(".", "").trim();
    int current_app_version = int.parse(current_app_new_version_string);
    int current_app_version_build = int.parse(packageInfo.buildNumber);


    if (new_app_version_string.length == current_app_new_version_string.length){

      if ((new_app_version == current_app_version && new_app_version_build > current_app_version_build)
          || new_app_version > current_app_version){

        return true;
      }
    }
    else if (new_app_version_string.length < current_app_new_version_string.length){

      int padLength = (current_app_new_version_string.length - new_app_version_string.length).abs();

      for (int index = 0; index < padLength; ++index){
        new_app_version_string = new_app_version_string + "0";
      }

      new_app_version = int.parse(new_app_version_string);

      if ((new_app_version == current_app_version && new_app_version_build > current_app_version_build)
          || new_app_version > current_app_version){

        return true;
      }

    }
    else if (new_app_version_string.length > current_app_new_version_string.length){
      int padLength = (new_app_version_string.length - current_app_new_version_string.length).abs();

      for (int index = 0; index < padLength; ++index){
        current_app_new_version_string = current_app_new_version_string + "0";
      }

      current_app_version = int.parse(current_app_new_version_string);

      if ((new_app_version == current_app_version && new_app_version_build > current_app_version_build)
          || new_app_version > current_app_version){

        return true;
      }
    }

    return false;
  }



  Future<bool> getIsChristmasPeriod()async{

    RemoteConfig remoteConfig = RemoteConfig();

    await remoteConfig.fetch(expiration: Duration.zero);
    await remoteConfig.activateFetched();

    String is_christmas_period = remoteConfig.getString(RemoteConfigKeys.is_christmas_period);

    if (is_christmas_period.toLowerCase() == true.toString()){
      return true;
    }
    else{
      return false;
    }

  }




  Future<void> showRewardAchievedDialog({@required BuildContext pageContext, @required int points, String message})async{


    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;

    await Future.delayed(Duration(seconds: 0), ()async{

      await showDialog(
          context: pageContext,
          builder: (BuildContext context){

            return Center(

              child: Animator(

                tween: Tween<double>(begin: 0.0, end: 1.0),
                //repeats: double.maxFinite.toInt(),
                curve: Curves.easeOutBack,
                duration: Duration(milliseconds: 700),
                builder: (anim){
                  return Transform.scale(
                    scale: anim.value,
                    alignment: FractionalOffset.center,
                    child: CupertinoAlertDialog(

                      title: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.5),
                        child: Text("Congratulations",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.5),
                              fontSize: Theme.of(context).textTheme.title.fontSize
                          ),
                        ),
                      ),

                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[


                          Animator(

                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            //repeats: double.maxFinite.toInt(),
                            curve: Curves.easeOutBack,
                            duration: Duration(milliseconds: 1500),
                            cycles: double.maxFinite.toInt(),
                            builder: (anim){
                              return Transform(
                                //angle: math.pi * 2 * anim.value ,
                                transform: Matrix4.identity()..setEntry(3, 2, 0.01)..rotateY(math.pi * 2 * anim.value ),
                                alignment: FractionalOffset.center,
                                child: Text("+${points}",
                                  style: TextStyle(
                                      color: RGBColors.gold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Theme.of(context).textTheme.display3.fontSize
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height:  screenHeight * scaleFactor * scaleFactor,),

                          Text("Reward Points",
                            style: TextStyle(
                                color: RGBColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: Theme.of(context).textTheme.title.fontSize
                            ),
                          ),

                          Container(
                            child: message != null? Container(
                              child: Column(
                                children: <Widget>[

                                  SizedBox(height: screenHeight * scaleFactor * 0.25,),

                                  Text(message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.2),
                                      //fontSize: Theme.of(context).textTheme.title.fontSize
                                    ),
                                  ),
                                ],
                              ),
                            ): Container(),
                          )

                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
      );

    });

  }
}





