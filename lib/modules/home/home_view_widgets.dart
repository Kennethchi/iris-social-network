import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/modules/post_feed/post_feed.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'home_bloc.dart';
import 'home_bloc_provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class GetPostFeedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    HomeBloc _bloc = HomeBlocProvider.of(context).bloc;

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
        child: StreamBuilder<bool>(
            stream: _bloc.getShowPublicPostFeedsStream,
            builder: (context, snapshot) {

              switch(snapshot.connectionState){
                case ConnectionState.none:case ConnectionState.waiting:
                return SpinKitChasingDots(color: CupertinoTheme.of(context).primaryColor,);
                case ConnectionState.active:case ConnectionState.done:

                if ((snapshot.hasData && snapshot.data) || snapshot.data == null){
                  return PostFeed();
                }
                else{
                  return SafeArea(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          Container(
                            child: Text("Public Posts", style: TextStyle(fontSize: Theme.of(context).textTheme.headline.fontSize, fontWeight: FontWeight.bold),),
                          ),

                          Padding(
                            padding: EdgeInsets.all(screenWidth * scaleFactor ),

                            child: Text("Go to your Profile Settings to enable this Feature And Restart the App",
                             style: TextStyle(
                               fontSize: Theme.of(context).textTheme.subhead.fontSize
                             ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }

            }
        )
    );
  }
}



class AnimatedInfoWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    AnimationController _animationController = HomeBlocProvider.of(context).animationController;
    Animation<double> _translateAnimation = HomeBlocProvider.of(context).translateAnimation;

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    double scaleFactor = 0.125;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Tap and Hold screen to popup Menu" ),
        ),


        AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget child){
              return Transform(
                transform: Matrix4.translationValues(0.0, scaleFactor * screenHeight * 0.25 * _translateAnimation.value , 0.0),
                child: Icon(FontAwesomeIcons.handPointDown, size: screenWidth * scaleFactor, color: _themeData.primaryColor.withOpacity(0.8),)
              );
            },
        ),
      ],
    );


  }

}










