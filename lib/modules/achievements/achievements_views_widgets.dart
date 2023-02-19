import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'package:iris_social_network/widgets/clippers/clippers.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'achievements_bloc.dart';
import 'achievements_bloc_provider.dart';

import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievement_services;


class AchievementsSliverAppBarView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AchievementsBlocProvider _provider = AchievementsBlocProvider.of(context);
    AchievementsBloc _bloc = AchievementsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return SliverAppBar(
      expandedHeight: screenHeight * 0.5,
      elevation: 1.0,
      centerTitle: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipPath(

        clipper: OvalBottomClipper(),

        child: FlexibleSpaceBar(

          background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, RGBColors.fuchsia],
                stops: [0.0, 0.5],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                child: AchievementLevelProgressWidget()
              ),
            ),
          ),

        ),
      ),

      actions: <Widget>[
        
        IconButton(

            icon: Icon(Icons.more_vert),
          onPressed: (){

              _provider.handlers.showAchievementTypesModal(achievementsContext: context);

          },
        )

      ],
    );

  }

}




class AchievementLevelProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    AchievementsBlocProvider _provider = AchievementsBlocProvider.of(context);
    AchievementsBloc _bloc = AchievementsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<RewardPointsModel>(
      stream: _bloc.getAchievedRewardPointsModelStream,
      builder: (context, snapshot) {


        return Container(
          width: screenWidth,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: <Widget>[


              Row(
                children: <Widget>[

                  Flexible(
                    flex: 25,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Text("Total Points\n Earned",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context).textTheme.caption.fontSize
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                        Text(snapshot.hasData? "${snapshot.data.points}": "${0}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context).textTheme.title.fontSize,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                      ],
                    ),
                  ),

                  Flexible(
                    flex: 50,
                    fit: FlexFit.tight,
                    child: FittedBox(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                        child: CircularPercentIndicator(
                          radius: screenWidth * 0.33,
                          lineWidth: 7.0,
                          animation: true,
                          percent: snapshot.hasData? snapshot.data.getPercentRatioToUnlockNextLevel: 0.0,
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Text(snapshot.hasData?   "${(snapshot.data.getPercentRatioToUnlockNextLevel * 100).round()}%"   : "${0.round()}%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Theme.of(context).textTheme.headline.fontSize,
                                      color: Colors.white)
                              ),
                              SizedBox(height: screenWidth * scaleFactor * scaleFactor,),

                              Text("to Level Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Theme.of(context).textTheme.overline.fontSize
                                ),
                              )

                            ],
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: _themeData.primaryColor,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          animationDuration: 1000,
                        ),
                      ),
                    ),
                  ),


                  Flexible(
                    flex: 25,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Text("Points Needed \nto Level Up",
                          style: TextStyle(
                              color: Colors.white.withOpacity(1.0),
                              fontSize: Theme.of(context).textTheme.caption.fontSize
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                        Text(snapshot.hasData? "${snapshot.data.getPointsNeededToUnlockNextLevel}": "${0}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context).textTheme.title.fontSize,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[



                  Flexible(
                    flex: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.yellow,),
                        Icon(Icons.star, color: Colors.yellow,),
                        Icon(Icons.star, color: Colors.yellow,),
                        Icon(Icons.star, color: Colors.yellow,),
                      ],
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Text("My Level",
                        style: TextStyle(
                            color: Colors.white.withOpacity(1.0),
                            fontSize: Theme.of(context).textTheme.caption.fontSize
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                      Text(snapshot.hasData? "${snapshot.data.getPointsCurrentLevel}": "${0}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context).textTheme.display1.fontSize,
                            fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                  Flexible(
                    flex: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.yellow,),
                        Icon(Icons.star, color: Colors.yellow,),
                        Icon(Icons.star, color: Colors.yellow,),
                        Icon(Icons.star, color: Colors.yellow,),
                      ],
                    ),
                  ),


                ],
              ),

            ],

          ),
        );

      }
    );
  }
}








class AchievementsLevelsStepperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    AchievementsBlocProvider _provider = AchievementsBlocProvider.of(context);
    AchievementsBloc _bloc = AchievementsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return SliverList(delegate: SliverChildListDelegate(

      <Widget>[

        Padding(
          padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
          child: Container(
            child: Column(
                children: getAchievementLevelsWidgets()
            ),
          ),
        ),

        MoreComingSoonWidget()
      ]

    ));


  }
}



class AchievementLevelPlaceholder extends StatelessWidget implements Comparable<AchievementLevelPlaceholder> {

  String title;
  String subtitle;
  Icon icon;
  int level;
  int levelPoint;
  String procedure;

  AchievementLevelPlaceholder({
    @required this.icon,
    @required this.title,
    @required this.subtitle,
    @required this.procedure,
    @required this.levelPoint
});

  @override
  int compareTo(AchievementLevelPlaceholder other) {
    if (this.levelPoint > other.levelPoint){
      return 1;
    }
    else if (this.levelPoint < other.levelPoint){
      return -1;
    }
    else{
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {


    AchievementsBlocProvider _provider = AchievementsBlocProvider.of(context);
    AchievementsBloc _bloc = AchievementsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<RewardPointsModel>(

        stream: _bloc.getAchievedRewardPointsModelStream,
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(
                color: snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level? RGBColors.gold: Colors.black.withOpacity(0.15),
                width: 5.0
            )),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * scaleFactor),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(screenWidth * scaleFactor * 0.5),
                bottomRight: Radius.circular(screenWidth * scaleFactor * 0.5)
              ),
              color: snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level
                  ? Colors.yellow.withOpacity(0.2)
                  : Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: screenHeight * scaleFactor * 0.5,
                  top: screenHeight * scaleFactor * scaleFactor
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * scaleFactor * 0.25),
                    child: Container(
                      padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * scaleFactor),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          Container(
                            child: this.level != null? Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level
                                      ? RGBColors.gold
                                      : Colors.black.withOpacity(0.15)
                              ),
                              width: 17.0,
                              height: 17.0,
                            ): Container(),
                          ),


                          SizedBox(width: 5.0,),
                          Container(
                            child: this.level != null? Text("Level ${level}", style: TextStyle(
                                color: snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level? RGBColors.gold: Colors.black.withOpacity(0.2),
                                fontWeight: FontWeight.w900
                            ),):
                            Container(),
                          ),

                        ],
                      ),
                    ),
                  ),


                  Flexible(
                    flex: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * scaleFactor * 0.75),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[


                              Container(
                                  child: this.icon != null? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(this.icon.icon,
                                        color: snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level
                                            ? this.icon.color
                                            : Colors.black.withOpacity(0.2),
                                      ),
                                      SizedBox(width: screenWidth * scaleFactor * 0.25,),
                                    ],
                                  ): Container()
                              ),
                              Flexible(
                                child: this.title != null? Text(
                                  this.title,
                                  style: TextStyle(
                                      color: snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level
                                          ? Colors.black.withOpacity(0.4)
                                          : Colors.black.withOpacity(0.2),
                                    fontWeight: FontWeight.bold
                                  ),
                                ): Container(),
                              ),

                            ],
                          ),
                        ),

                        Container(
                          child: this.subtitle != null? Text(this.subtitle,
                            style: TextStyle(
                                color:snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level? Colors.black.withOpacity(0.5): Colors.black.withOpacity(0.3),
                              fontSize: Theme.of(context).textTheme.caption.fontSize
                            ),
                          ): Container(),
                        ),
                        SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                        Column(
                          children: <Widget>[
                            Center(
                              child: level != null? Text(
                                snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level
                                    ? "(${levelPoint} Total Points) earned"
                                    : "(${levelPoint} Total Points) required", style: TextStyle(
                                  color: snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level
                                      ? RGBColors.gold
                                      : Colors.black.withOpacity(0.2),
                                  //fontSize: Theme.of(context).textTheme.title.fontSize,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                              ): Container(),
                            ),
                            SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                            Center(
                              child: snapshot.hasData && snapshot.data.getPointsCurrentLevel >= level
                                  ? Text(this.procedure != null? this.procedure: "",
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.caption.fontSize,
                                  color: RGBColors.gold

                                ),
                              )
                                  : Container(),
                            )

                          ],
                        ),

                      ],
                    ),
                  )


                ],

              ),
            ),
          ),
        );
      }
    );
  }
}




List<Widget> getAchievementLevelsWidgets(){

  List<AchievementLevelPlaceholder> widgets = <AchievementLevelPlaceholder>[

    AchievementLevelPlaceholder(
        icon: Icon(FontAwesomeIcons.headphonesAlt, color: Colors.pinkAccent,),
        title: "Profile Audio",
        subtitle: "Users will be able to listen to a short looping sound audio while viewing your profile",
      procedure: "Go to your Profile Settings to set this Up",
      levelPoint: achievement_services.AchievementsLevelsUnlockPoints.profile_audio,
    ),

    AchievementLevelPlaceholder(
        icon: Icon(Icons.palette, color: Colors.greenAccent,),
        title: "Theme Color",
        subtitle: "Change the theme color of the App",
      procedure: "Go to your Profile Settings to set this Up",
      levelPoint: achievement_services.AchievementsLevelsUnlockPoints.app_theme_color,
    ),


  ];


  if (widgets.length <= achievement_services.getUnlockLevelsPoints().length){


    for (int index = 0; index < widgets.length; ++index){

      RewardPointsModel rewardPointsModel = RewardPointsModel(points: widgets[index].levelPoint);
      widgets[index].level = rewardPointsModel.getPointsCurrentLevel;
    }

  }


  widgets.sort();

  return widgets;
}


class MoreComingSoonWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    AchievementsBlocProvider _provider = AchievementsBlocProvider.of(context);
    AchievementsBloc _bloc = AchievementsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.5),
        child: Text("More Coming Soon...",
          style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

