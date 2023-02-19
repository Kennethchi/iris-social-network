import 'package:animator/animator.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/modules/comment_space/comment_space.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/widgets/clippers/clippers.dart';
import 'post_room_bloc.dart';
import 'post_room_bloc_provider.dart';




class PostRoomsViewHandlers{




  void showPostComments({@required BuildContext postRoomContext, @required PostModel postModel}){


    showCupertinoModalPopup(
        context: postRoomContext,
        builder: (BuildContext context){

          return ClipPath(
            clipper: OvalTopClipper(),
            child: Container(
              color: RGBColors.black.withOpacity(0.4),
              height: MediaQuery.of(context).size.height * 0.8,
              child: CommentSpace(postModel: postModel,),
            ),
          );

        }
    );


  }



  Future<void> animatePostLike({@required BuildContext context})async{

    OverlayState overlay = Overlay.of(context);

    OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context){

      return Positioned(
          child: FlareActor(
            "assets/flare/like.flr",
            animation: "Favorite",
            color: RGBColors.fuchsia,
            alignment: Alignment.center,
            fit: BoxFit.contain,
          )
      );
    });

    overlay.insert(overlayEntry);

    await Future.delayed(Duration(milliseconds: 700));

    overlayEntry.remove();
  }


  Future<void> animatePostUnLike({@required BuildContext context})async{

    OverlayState overlay = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context){

      return Positioned(
          child: Container(
            child: FlareActor(
              "assets/flare/like.flr",
              animation: "Unfavorite",
              color: Colors.white.withOpacity(0.8),
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ),
          )
      );
    });

    overlay.insert(overlayEntry);

    await Future.delayed(Duration(milliseconds: 700));

    overlayEntry.remove();
  }




  Future<void> showPostCaptionModalDialog({@required BuildContext menuContext, @required String postCaption})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(menuContext);
    double screenWidth = MediaQuery.of(menuContext).size.width;
    double screenHeight = MediaQuery.of(menuContext).size.height;
    double scaleFactor = 0.125;

    await showCupertinoModalPopup(
        context: menuContext,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor, horizontal: screenWidth * scaleFactor * 0.25),
                    child: CupertinoActionSheet(

                        title: Center(
                          //child: Icon(Icons.info_outline)
                          child: Text("Post Caption", style: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
                        ),

                        message: postCaption == null
                            ? Container()
                            : Text(
                          postCaption,
                          style: TextStyle(
                              //fontSize: Theme.of(context).textTheme.subhead.fontSize
                          ),
                        )

                    ),
                  ),
                );
              },
            ),
          );
        }
    );

  }







}