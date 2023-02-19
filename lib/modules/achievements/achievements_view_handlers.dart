import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';

import 'achievements_bloc.dart';
import 'achievements_bloc_provider.dart';


class AchievementsViewHandler{

  Future<void> showAchievementTypesModal({@required BuildContext achievementsContext}){


    AchievementsBlocProvider _provider = AchievementsBlocProvider.of(achievementsContext);
    AchievementsBloc _bloc = AchievementsBlocProvider.of(achievementsContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(achievementsContext);
    double screenWidth = MediaQuery.of(achievementsContext).size.width;
    double screenHeight = MediaQuery.of(achievementsContext).size.height;
    double scaleFactor = 0.125;



    showDialog(
        context: achievementsContext,
        builder: (BuildContext context){

          return SafeArea(

            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeOutBack,
              duration: Duration(milliseconds: 500),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: Center(

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.25),
                      child: Container(

                        width: screenWidth,
                        height: screenHeight * 0.8,

                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.4)
                          ),
                          child: SingleChildScrollView(
                            child: Column(

                              children: <Widget>[


                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.4),
                                  child: Text("How to Earn Points", style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.title.fontSize,
                                      color: _themeData.primaryColor,
                                      fontWeight: FontWeight.bold

                                  ),),
                                ),


                                _getRewardTypeWidget(
                                    achievementsContext: achievementsContext,
                                    icon: Icon(FontAwesomeIcons.doorOpen),
                                    title: "Open App each day",
                                    subtitle: "Get Reward Points each day you open the app",
                                    points: RewardsTypePoints.opening_app_each_day_reward_point
                                ),

                                _getRewardTypeWidget(
                                    achievementsContext: achievementsContext,
                                    icon: Icon(FontAwesomeIcons.upload),
                                    title: "Publish a Post",
                                    subtitle: "Get Reward Points each time you publish a post",
                                    points: RewardsTypePoints.publishing_single_post_reward_point
                                ),

                                /*
                                _getRewardTypeWidget(
                                    achievementsContext: achievementsContext,
                                    icon: Icon(Icons.movie),
                                    title: "Watch Video Posts and Listen to Audio Posts",
                                    subtitle: "Get Reward Points each time you watch a video post or listen to an audio post",
                                    points: RewardsTypePoints.viewing_post_media_reward_point
                                ),
                                */

                                _getRewardTypeWidget(
                                    achievementsContext: achievementsContext,
                                    icon: Icon(FontAwesomeIcons.solidHandshake),
                                    title: "Get a Friend",
                                    subtitle: "Get Reward Points each time you become Friends with a user on the platform",
                                    points: RewardsTypePoints.finding_a_friend_reward_point
                                ),


                                _getRewardTypeWidget(
                                    achievementsContext: achievementsContext,
                                    icon: Icon(CupertinoIcons.group_solid),
                                    title: "Gain a Follower",
                                    subtitle: "Get Reward Points each time you gain a Follower",
                                    points: RewardsTypePoints.followers_growth_reward_point
                                ),


                                _getRewardTypeWidget(
                                    achievementsContext: achievementsContext,
                                    icon: Icon(FontAwesomeIcons.userPlus),
                                    title: "Invite a Friend",
                                    subtitle: "Get Reward Points each time you successfully invite a new user to sign up to the app through the invite link",
                                    points: RewardsTypePoints.invite_new_user_reward_point
                                ),


                                /*
                                _getRewardTypeWidget(
                                    achievementsContext: achievementsContext,
                                    icon: Icon(FontAwesomeIcons.searchPlus),
                                    title: "Item Finder Challenge\n(Image Classification)",
                                    subtitle: "Get Reward Points each time you Find an item",
                                    points: RewardsTypePoints.machine_learning_classification_reward_point
                                ),
                                */


                                /*
                                  _getRewardTypeWidget(
                                      achievementsContext: achievementsContext,
                                      icon: Icon(CupertinoIcons.group_solid),
                                      title: "Follow a User",
                                      subtitle: "Get Reward Points each time you follow a User",
                                      points: RewardsTypePoints.following_growth_reward_point
                                  ),
                                */


                              ],
                            ),
                          ),
                        ),

                      ),
                    ),
                  ),

                );
              },
            ),

          );

        }
    );

  }









  Widget _getRewardTypeWidget({@required BuildContext achievementsContext,
    @required Icon icon,
    @required String title,
    @required String subtitle,
    @required int points
  }){


    AchievementsBlocProvider _provider = AchievementsBlocProvider.of(achievementsContext);
    AchievementsBloc _bloc = AchievementsBlocProvider.of(achievementsContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(achievementsContext);
    double screenWidth = MediaQuery.of(achievementsContext).size.width;
    double screenHeight = MediaQuery.of(achievementsContext).size.height;
    double scaleFactor = 0.125;



    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.25),
      child: ListTile(

        leading: icon != null? icon: Container(),
        title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5)
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text(subtitle,
            style: TextStyle(
                fontSize: Theme.of(achievementsContext).textTheme.caption.fontSize,
                color: Colors.black.withOpacity(0.3)
            ),
          ),
        ),
        trailing: Text("+${points} pts", style: TextStyle(
            color: RGBColors.gold,
            fontWeight: FontWeight.bold,
          fontSize: Theme.of(achievementsContext).textTheme.title.fontSize
        ),),
        dense: true,
      ),
    );

  }

}