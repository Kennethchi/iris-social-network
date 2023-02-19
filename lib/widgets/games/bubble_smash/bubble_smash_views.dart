import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'bubble_smash_views_widgets.dart';


class BubbleSmashArenaView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(
      padding: EdgeInsets.all(10.0),
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: <Widget>[

          HigHScoreWidget(),
          SizedBox(height: 10.0,),

          CurrentScoreWidget(),

          Center(
            child: GameBoardWidget(),
          )

        ],
      ),
    );
  }


}