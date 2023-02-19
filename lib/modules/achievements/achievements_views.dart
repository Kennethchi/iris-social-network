import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'achievements_bloc.dart';
import 'achievements_bloc_provider.dart';
import 'achievements_views_widgets.dart';



class AchievementsView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    AchievementsBlocProvider _provider = AchievementsBlocProvider.of(context);
    AchievementsBloc _bloc = AchievementsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(
      child: CustomScrollView(
        slivers: <Widget>[

          AchievementsSliverAppBarView(),

          AchievementsLevelsStepperWidget(),

        ],
      ),
    );
  }

}





