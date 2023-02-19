import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'achievements_views.dart';
import 'achievements_bloc.dart';
import 'achievements_bloc_provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;



class Achievements extends StatefulWidget {
  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> with TickerProviderStateMixin, AfterLayoutMixin<Achievements> {

  AchievementsBloc _bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = AchievementsBloc();
  }


  @override
  void afterFirstLayout(BuildContext context) {


    _bloc.getFirebaseUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){

        _bloc.getTotalAchievedPoints(userId: firebaseUser.uid).then(((int achievedRewardPoints){

          if (achievedRewardPoints == null || achievedRewardPoints < achievements_services.RewardsTypePoints.signup_reward_point){

            AppBlocProvider.of(context).bloc.increaseUserPoints(
                userId: firebaseUser.uid,
                points: achievements_services.RewardsTypePoints.signup_reward_point
            ).then((totalPoints){

              AppBlocProvider.of(context).handler.showRewardAchievedDialog(
                  pageContext: context,
                  points: achievements_services.RewardsTypePoints.signup_reward_point,
                  message: "For Signing Up"
              ).then((_){

                RewardPointsModel rewardPointsModel = RewardPointsModel(points: totalPoints);
                _bloc.setUserRewardPointsModel = rewardPointsModel;
                _bloc.addAcheivedRewardPointsModelToStream(rewardPointsModel);
              });
            });
          }

        }));






      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return AchievementsBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        body: CupertinoPageScaffold(

            child: AchievementsView()
        ),
      ),
    );
  }
}
