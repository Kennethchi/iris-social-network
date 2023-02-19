import 'package:animator/animator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/modules/achievements/achievements.dart';
import 'package:iris_social_network/modules/entertaitement/entertaitement.dart';
import 'package:iris_social_network/modules/users_suggestion/users_suggestion.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/app_services/remote_config_services.dart';
import 'home_bloc.dart';
import 'home_bloc_provider.dart';
import 'package:iris_social_network/modules/profile/profile.dart';
import 'package:iris_social_network/modules/chat_room/private_chat_room/private_chat_room.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat.dart';
import 'package:iris_social_network/modules/chat_room/chat_room.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'dart:async';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/widgets/option_menu/option_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:iris_social_network/modules/settings/settings.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'dart:math';
//import 'package:speech_recognition/speech_recognition.dart';

import 'dart:io';

import 'package:iris_social_network/modules/camera/camera.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/modules/search/search.dart';
import 'package:iris_social_network/modules/menu/menu.dart';
import 'package:package_info/package_info.dart';


class HomeViewHandlers{


  static Future<void> showModelPopupMenu({@required BuildContext homeContext, @required HomeBloc bloc}) async{

    //HomeBloc bloc = HomeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(homeContext);
    double screenWidth = MediaQuery.of(homeContext).size.width;
    double screenHeight = MediaQuery.of(homeContext).size.height;


    showDialog(
      context: homeContext,
      builder: (BuildContext context){
        return Center(
          child: OptionMenu(
            width: screenWidth * 0.7,
            height: screenHeight * 0.45,


           topStart: Container(
             key: GlobalKey(),
             child: OptionMenuItem(
                iconData: Icons.search,
                label: "Search",
                mini: false,
                optionItemPosition: OptionItemPosition.TOP_START,
                returnItemPostionState: false,
                onTap: (){

                  Navigator.of(context).pop();
                  Navigator.of(homeContext).push(CupertinoPageRoute(builder: (BuildContext context) => Search()));
                },

              ),
           ),


            centerStart: Container(
              key: GlobalKey(),
              child: OptionMenuItem(
                iconData: FontAwesomeIcons.userPlus,
                label: "Users Suggestion",
                mini: false,
                optionItemPosition: OptionItemPosition.CENTER_START,
                returnItemPostionState: false,
                onTap: (){

                  Navigator.of(context).pop();
                  Navigator.of(homeContext).push(MaterialPageRoute(builder: (BuildContext context) => UsersSuggestion()));
                },

              ),
            ),


            centerEnd: Container(
              key: GlobalKey(),
              child: OptionMenuItem(
                iconData: FontAwesomeIcons.trophy,
                label: "Achievements",
                mini: false,
                optionItemPosition: OptionItemPosition.CENTER_END,
                returnItemPostionState: false,
                onTap: ()async{

                  Navigator.pop(context);
                  Navigator.of(homeContext).push(CupertinoPageRoute(builder: (BuildContext context) => Achievements()));
                },

              ),
            ),


            topEnd: Container(
              key: GlobalKey(),
              child: OptionMenuItem(
                iconData: Icons.menu,
                label: "Menu",
                mini: false,
                optionItemPosition: OptionItemPosition.TOP_END,
                returnItemPostionState: false,
                onTap: (){

                  Navigator.pop(context);
                  Navigator.of(homeContext).push(CupertinoPageRoute(builder: (BuildContext context) => Menu()));

                },

              ),
            ),




            /*
            centerEnd: Container(
              key: GlobalKey(),
              child: OptionMenuItem(
                iconData: FontAwesomeIcons.camera,
                label: "Camera",
                mini: false,
                optionItemPosition: OptionItemPosition.CENTER_END,
                returnItemPostionState: false,
                onTap: (){

                  Navigator.pop(context);
                  Navigator.of(homeContext).push(CupertinoPageRoute(builder: (BuildContext context) => Camera()));
                },

              ),

            ),
            */

/*
            centerStart: Container(
              key: GlobalKey(),
              child: OptionMenuItem(
                iconData: FontAwesomeIcons.hatWizard,
                label: "Entertaitement",
                mini: false,
                optionItemPosition: OptionItemPosition.CENTER_START,
                returnItemPostionState: false,
                onTap: (){

                  Navigator.pop(context);
                  Navigator.of(homeContext).push(
                      CupertinoPageRoute(
                          builder: (BuildContext context) => Entertaitement()
                      )
                  );
                },

              ),
            ),
            */


            bottomCenter: Container(
              key: GlobalKey(),
              child: OptionMenuItem(
                iconData: CupertinoIcons.person_solid,
                label: "Profile",
                mini: false,
                optionItemPosition: OptionItemPosition.BOTTOM_CENTER,
                returnItemPostionState: false,
                onTap: (){

                  Navigator.pop(context);
                  Navigator.of(homeContext).push(
                      CupertinoPageRoute(
                          builder: (BuildContext context) => Profile(profileUserId: bloc.getUserId,)
                      )
                  );
                },

              ),
            ),



            center: Container(
              key: GlobalKey(),
              child: OptionMenuItem(
                iconData: Icons.add,
                label: null,
                mini: true,
                optionItemPosition: OptionItemPosition.CENTER,
                returnItemPostionState: false,
                onTap: (){},
              ),
            ),


          ),
        );
      },

    );



  }




  static Future<void> showAvatar({@required HomeBloc bloc, @required OverlayState overlayAvatarState})async{

    OverlayState overlayState = overlayAvatarState;
    OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context){

      double avatarWidth = 100.0;
      double avatarHeight = 100.0 + (100.0 * 0.1);

      return StreamBuilder<Point<double>>(

        stream: bloc.getAvatarPositionStream,
        builder: (BuildContext context, AsyncSnapshot<Point<double>> snapshot){

          return Positioned(

              left: snapshot.data == null? 0.0 : snapshot.data.x,
              top: snapshot.data == null? 0.0 : snapshot.data.y,

              child: Center(

                child: Draggable(

                  feedback: Container(
                    width: avatarWidth,
                    height: avatarHeight,
                    //color: RGBColors.blue,
                    child: FlareActor(
                      "assets/flare/teddy.flr",
                      animation: "idle",
                      //animation: "success",
                      //color: Colors.redAccent,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.contain,

                    ),
                  ),


                  child: GestureDetector(

                    onLongPress: (){


                      /*
                      if (Theme.of(context).platform == TargetPlatform.android){

                        SpeechRecognition speechRecognition = SpeechRecognition();
                        speechRecognition.setRecognitionResultHandler((String result){

                          print(result);

                        });

                      }
                      */

                    },

                    child: Container(
                      width: avatarWidth,
                      height: avatarHeight,
                      //color: RGBColors.active_green,
                      child: FlareActor(
                        "assets/flare/teddy.flr",
                        animation: "idle",
                        //animation: "success",
                        //color: Colors.redAccent,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.contain,

                      ),
                    ),
                  ),


                  childWhenDragging: Container(),


                  onDragEnd: (DraggableDetails draggableDetails){

                    double posX = draggableDetails.offset.dx;
                    double posY = draggableDetails.offset.dy;

                    double bound = avatarWidth;

                    if (MediaQuery.of(context).size.width - posX < bound){
                      posX = MediaQuery.of(context).size.width - bound;
                    }
                    else if (posX < 0.0){
                      posX = 0.0;
                    }

                    if (MediaQuery.of(context).size.height - posY < bound){
                      posY = MediaQuery.of(context).size.height - bound;
                    }
                    else if (posY < 0.0){
                      posY = 0.0;
                    }

                    bloc.addAvatarPositionToStream(new Point(posX, posY));
                  },
                ),
              )
          );
        },

      );

    });

    overlayState.insert(overlayEntry);

    //await Future.delayed(Duration(milliseconds: 500));

    //overlayEntry.remove();
  }




  static Future<bool> showHelpDialogAndGetShouldPopAgain({@required BuildContext context})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(seconds: 1),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoAlertDialog(

                      title: Center(
                        //child: Icon(Icons.info_outline)
                        child: Text("Home UI Guide", style: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
                      ),


                      content: Container(

                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[

                            SizedBox(height: screenHeight * scaleFactor * 0.25,),

                            Text("Press and Hold the screen on the Home Page to Pop out Menu",
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: screenHeight * scaleFactor * 0.25,),


                            /*
                                Flexible(
                                  child: Center(
                                    child: Animator(
                                        tween: Tween<double>(begin: 1, end: 0),
                                        cycles: 1000000000,
                                        //repeats: 10000000,
                                        curve: Curves.linear,
                                        duration: Duration(milliseconds: 700),
                                        builder: (anim){
                                          return Transform.translate(
                                              offset: Offset(0.0, screenHeight * scaleFactor * scaleFactor * anim.value),
                                              child: Icon(FontAwesomeIcons.handPointDown, size: screenWidth * scaleFactor,)
                                          );
                                        }
                                    ),
                                  ),
                                )
                                */


                          ],
                        ),
                      ),
                    actions: <Widget>[

                      CupertinoDialogAction(
                        child: Text("OK",
                        style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: (){

                          Navigator.of(context).pop(true);
                        },
                      ),


                    ],

                  ),
                );
              },
            ),
          );
        }
    );

  }






  static Future<bool> showUpdateAppDialog({@required BuildContext context})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(seconds: 1),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoAlertDialog(

                    title: Center(
                      //child: Icon(Icons.info_outline)
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.new_releases, color: RGBColors.fuchsia,),
                          Text(
                            "New Update Available",
                            style: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                          ),

                        ],
                      ),
                    ),


                    content: Container(

                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[

                          SizedBox(height: screenHeight * scaleFactor * 0.25,),

                          Text("There is a new version of the app available. Please update it now",
                            textAlign: TextAlign.center,
                          ),

                        ],
                      ),
                    ),
                    actions: <Widget>[

                      CupertinoDialogAction(
                        child: Text("Update",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: (){

                          Navigator.of(context).pop(true);
                        },
                      ),


                      CupertinoDialogAction(
                        child: Text("Later",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: (){

                          Navigator.of(context).pop(false);

                          showDialog(
                              context: context,
                              builder: (BuildContext context){

                                return Center(
                                  child: Animator(

                                    tween: Tween<double>(begin: 0.0, end: 1.0),
                                    //repeats: 1,
                                    curve: Curves.easeInOutBack,
                                    duration: Duration(seconds: 1),
                                    builder: (anim){
                                      return Transform.scale(
                                        scale: anim.value,
                                        child: CupertinoAlertDialog(

                                          content: Container(
                                            padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                                            color: Colors.transparent,
                                            child: Text("To Update the App Later, go to the Menu Settings",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),

                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                          );
                        },
                      ),
                    ],

                  ),
                );
              },
            ),
          );
        }
    );

  }







}