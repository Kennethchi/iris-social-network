import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'comment_space_bloc_provider.dart';
import 'comment_space_bloc.dart';
import 'comment_space_view.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:ui';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;

import 'comment_space_view_handlers.dart';
import 'package:after_layout/after_layout.dart';



class CommentSpace extends StatefulWidget{

  PostModel postModel;

  CommentSpace({@required this.postModel});

  _CommentSpaceState createState() => _CommentSpaceState();
}


class _CommentSpaceState extends State<CommentSpace> with AfterLayoutMixin<CommentSpace>{


  CommentSpaceBloc _bloc;
  TextEditingController _textEditingController;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = CommentSpaceBloc(postModel: widget.postModel);
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();

    super.dispose();
  }


  @override
  void afterFirstLayout(BuildContext context) {

    Timer(Duration(seconds: 1), (){
      SharedPreferences.getInstance().then((sharedPrefs)async{

        bool quitShowingGuideStoredValue = sharedPrefs.getBool(app_constants.SharedPrefsKeys.show_comment_screen_ui_guide);

        if (quitShowingGuideStoredValue == null){
          bool quitShowingGuide = await CommentSpaceViewHandlers.showCommentHelpDialogAndGetShouldPopAgain(context: context);
          sharedPrefs.setBool(app_constants.SharedPrefsKeys.show_comment_screen_ui_guide, quitShowingGuide);
        }
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return CommentSpaceBlocProvider(
      bloc: _bloc,
      scrollController: _scrollController,
      textEditingController: _textEditingController,

      child: Scaffold(

        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[

            Positioned.fill(
              child: Container(

                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0
                  ),
                  child: CommentSpaceView(),
                ),
            ),),

          ],
        ),
      ),

    );
  }

}




