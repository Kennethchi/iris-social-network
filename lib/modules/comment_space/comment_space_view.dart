import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'comment_space_view_widgets.dart';
import 'comment_space_bloc_provider.dart';
import 'comment_space_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:ui';




class CommentSpaceView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CommentSpaceBloc _bloc = CommentSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.25),
      //width: screenWidth,
      //height: screenHeight * 0.75,
      child: Column(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(left: 5.0, top: 40.0, right: 5.0, bottom: 10.0),
            child: CommentsTitleWidget(),
          ),

          Flexible(
            flex: 100,
            child: CustomScrollView(

              controller: CommentSpaceBlocProvider.of(context).scrollController,

              slivers: <Widget>[


                CommentListWidget(),

                LoadingCommentsIndicatorWidget(),


              ],
            ),
          ),

          CommentsTextFieldWidget()
        ],
      ),
    );
  }

}