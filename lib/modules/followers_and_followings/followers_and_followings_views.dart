import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'followers_and_followings_bloc_provider.dart';
import 'followers_and_followings_bloc.dart';
import 'followers_and_followings_views_widgets.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';




class FollowersAndFollowingsViews extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    FollowersAndFollowingsBloc _bloc = FollowersAndFollowingsBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.2),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.5)
          ),
          child: Column(
            children: <Widget>[


              Flexible(
                flex: 100,

                child: CustomScrollView(

                  controller: FollowersAndFollowingsBlocProvider.of(context).scrollController,

                  slivers: <Widget>[

                    FFListWidget(),

                    LoadingFFIndicatorWidget()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }



}





