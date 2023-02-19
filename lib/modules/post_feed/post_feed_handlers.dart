import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/modules/post_feed/post_feed_bloc_provider.dart';
import 'dart:async';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/modules/previews/posts_previews.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'post_feed_bloc.dart';



class PostFeedHandlers{


  Widget getPostPreviewWidget({@required BuildContext postFeedContext, @required PostModel postModel}){


    PostFeedBloc _bloc = PostFeedBlocProvider.of(postFeedContext).bloc;

    return StreamBuilder<int>(

      stream: AppBlocProvider.of(postFeedContext).bloc.getBackgroundColorValueStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){


        if (postModel.postType == constants.PostType.video){

          return VideoPostPreviewWidget(
            postModel: postModel,
            colorValue: snapshot.hasData? snapshot.data: Colors.white.value,
          );
        }
        else if (postModel.postType == constants.PostType.image){


          return ImagePostPreviewWidget(
            postModel: postModel,
            colorValue: snapshot.hasData? snapshot.data: Colors.white.value,
          );
        }
        else if (postModel.postType == constants.PostType.audio){

          return AudioPostPreviewWidget(
            postModel: postModel,
            colorValue: snapshot.hasData? snapshot.data: Colors.white.value,
          );
        }
        else{
          return Container();
        }

      },
    );

  }






  static Future<bool> showPostFeedInfo({@required BuildContext context})async{

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
                      child: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Icon(Icons.info_outline),
                            SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                            Text("Public Feed Info", style: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),


                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            "Posts published as PUBLIC will be published here",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * scaleFactor * 0.25,),

                        Text(
                            "To Hide this Feature, go to your Profile Settings",
                          textAlign: TextAlign.center,
                        ),
                      ],
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



}





