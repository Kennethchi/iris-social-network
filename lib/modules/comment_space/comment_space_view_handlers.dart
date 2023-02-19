import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'comment_space_bloc.dart';
import 'comment_space_bloc_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_comment_model.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class CommentSpaceViewHandlers{


  // When the text in text field change. we set the current user istyping value based on whether the field is empty or not
  void onTextChange({@required BuildContext commentSpaceContext, @required String text}){

    CommentSpaceBloc _bloc = CommentSpaceBlocProvider.of(commentSpaceContext).bloc;

    _bloc.addTextToStream(text: text);
  }




  Future<void> sendComment({@required BuildContext context, @required String cleanedComment}) async{

    CommentSpaceBloc _bloc = CommentSpaceBlocProvider.of(context).bloc;
    TextEditingController textEditingController = CommentSpaceBlocProvider.of(context).textEditingController;


    // clears textfield
    textEditingController.clear();


    // adds null text to stream after text being sent
    _bloc.addTextToStream(text: null);

    UserModel currentUserModel = await AppBlocProvider.of(context).bloc.getAllCurrentUserData(
        currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId
    );

    OptimisedCommentModel optimisedCommentModel = OptimisedCommentModel(
        user_id: currentUserModel.userId,
        comment: cleanedComment,
        t: Timestamp.now().millisecondsSinceEpoch
    );




    // dummy optimised comment model
    OptimisedCommentModel dummyOptimisedCommentsMoel = OptimisedCommentModel.fromJson(optimisedCommentModel.toJson());
    _bloc.getCommentsList.insert(0, dummyOptimisedCommentsMoel);
    dummyOptimisedCommentsMoel.username = currentUserModel.username;
    dummyOptimisedCommentsMoel.name = currentUserModel.profileName;
    dummyOptimisedCommentsMoel.v_user = currentUserModel.verifiedUser;
    dummyOptimisedCommentsMoel.thumb = currentUserModel.profileThumb;
    _bloc.addCommentListToStream(_bloc.getCommentsList);




    _bloc.addCommentData(
        optimisedCommentModel: optimisedCommentModel,
        postId: _bloc.getPostModel.postId,
      postUserId: _bloc.getPostModel.userId
    ).then((String commentId){

      int index = _bloc.getCommentsList.indexOf(dummyOptimisedCommentsMoel);
      _bloc.getCommentsList[index].id = commentId;
    });






    // reloads comments
    //_bloc.getCommentsData(postId: _bloc.getCommentsPostId, queryLimit: _bloc.getCommentsQueryLimit, endAtValue: null);


    // scrolls to top (since we are in reverse mode)
    CommentSpaceBlocProvider.of(context).scrollController.jumpTo(CommentSpaceBlocProvider.of(context).scrollController.position.minScrollExtent);
  }








  Future<void> showDeleteCommentActionDialog({@required BuildContext commentSpaceContext, @required OptimisedCommentModel optimisedCommentModel})async{

    CommentSpaceBloc bloc = CommentSpaceBlocProvider.of(commentSpaceContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(commentSpaceContext);
    double screenwidth = MediaQuery.of(commentSpaceContext).size.width;
    double screenHeight = MediaQuery.of(commentSpaceContext).size.height;
    double scaleFactor = 0.125;


    showCupertinoModalPopup(
        context: commentSpaceContext,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text("Do you want to delete this Comment?"),
            actions: <Widget>[

              CupertinoActionSheetAction(

                child: Center(
                    child: Text("Yes", style: TextStyle(color: _themeData.primaryColor),)
                ),
                onPressed: ()async{


                  AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection){

                    if (hasInternetConnection != null && hasInternetConnection){

                      BasicUI.showProgressDialog(
                        pageContext: context,
                        child: Column(

                          children: <Widget>[

                            SpinKitFadingCircle(color: _themeData.primaryColor,),
                            SizedBox(height: screenHeight * scaleFactor * 0.25,),

                            Text("Deleting...", style: TextStyle(
                                color: _themeData.primaryColor,
                                fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                            ),)

                          ],
                        ),
                      );


                      bloc.deletePostComment(postUserId: bloc.getPostModel.userId, postId: bloc.getPostModel.postId, commentId: optimisedCommentModel.id).then((_){
                        bloc.getCommentsList.remove(optimisedCommentModel);
                        bloc.addCommentListToStream(bloc.getCommentsList);

                        Navigator.pop(context);
                        Navigator.pop(context);

                        BasicUI.showSnackBar(
                            context: commentSpaceContext,
                            message: "Comment has been deleted", textColor: _themeData.primaryColor,
                            duration: Duration(seconds: 2)
                        );
                      });


                    }
                    else{

                      Navigator.of(context).pop();
                      BasicUI.showSnackBar(
                          context: commentSpaceContext,
                          message: "No Internet Connection",
                          textColor:  CupertinoColors.destructiveRed,
                          duration: Duration(seconds: 1)
                      );
                    }

                  });

                },
              ),

              CupertinoActionSheetAction(
                child: Center(
                    child: Text("No", style: TextStyle(color: _themeData.primaryColor),)
                ),
                onPressed: (){

                  Navigator.pop(context);
                },
              ),

            ],


          );
        }
    );

  }







  static Future<bool> showCommentHelpDialogAndGetShouldPopAgain({@required BuildContext context})async{

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
                      child: Text("Comment UI Guide", style: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
                    ),


                    content: Container(
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.33,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[

                          SizedBox(height: screenHeight * scaleFactor * 0.5,),

                          Text("Slide your comment to PopUp delete Option",
                            textAlign: TextAlign.center,
                          ),

                          Flexible(
                            child: Center(
                              child: Stack(
                                children: <Widget>[


                                  Container(
                                    width: screenWidth * 0.75,
                                    height: screenHeight * scaleFactor * 0.4,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: _themeData.primaryColor, width: 2.0)
                                    ),
                                  ),

                                  Animator(
                                      tween: Tween<double>(begin: 1, end: -1),
                                      cycles: 1000000000,
                                      //repeats: 10000000,
                                      curve: Curves.linear,
                                      duration: Duration(milliseconds: 700),
                                      builder: (anim){
                                        return Transform.translate(
                                            offset: Offset(screenHeight * scaleFactor * 0.5 * anim.value, 0.0),
                                            child: Container(
                                              width: screenWidth * 0.75,
                                              height: screenHeight *  scaleFactor * 0.4,
                                              color: _themeData.primaryColor,
                                            )
                                        );
                                      }
                                  ),
                                ],
                              ),
                            ),
                          )


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






}