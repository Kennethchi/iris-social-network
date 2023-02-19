import 'package:meta/meta.dart';
import 'dart:math' as math;

int POINT_STEPS =  500;
int NUMBER_0F_LEVELS = 1000;

List<int> getUnlockLevelsPoints(){

  List<int> levelsPointsList = List<int>();

  levelsPointsList.addAll([
    AchievementsLevelsUnlockPoints.profile_audio,
    AchievementsLevelsUnlockPoints.app_theme_color
  ]);
  levelsPointsList.sort();


  for (int index = 1; index <= NUMBER_0F_LEVELS; ++index){

    int levelPoint = (index  * POINT_STEPS) + levelsPointsList.last;
    levelsPointsList.add(levelPoint);
  }

  return levelsPointsList;
}




class RewardPointsModel{

  int points;

  RewardPointsModel({
    @required this.points
  }){

    if (this.points == null){
      this.points = 0;
    }
  }


  int get getPointsCurrentLevel {

    List<int> levelsList = getUnlockLevelsPoints();

    for (int index = 0; index < levelsList.length; ++index){

      if (index == 0 && this.points < levelsList[0]){
        return 0;
      }
      else if (index == levelsList.length - 1 && this.points >= levelsList[levelsList.length - 1]){
        return levelsList.length;
      }
      else if (index < levelsList.length - 1){

        int currentLevelPoint = levelsList[index];
        int nextLevelPoint = levelsList[index + 1];
        if (this.points >= currentLevelPoint && this.points < nextLevelPoint){
          return index + 1;
        }
      }
    }

    return -1;
  }


  int get getPointsNeededToUnlockNextLevel {

    int currentLevel = getPointsCurrentLevel;
    int nextLevelIndex = currentLevel;

    int nextLevelPoints = getUnlockLevelsPoints()[nextLevelIndex];

    return nextLevelPoints - points;
  }


  int get getCurrentPointsBeforeUnlockingNextLevel {

    int currentLevel = getPointsCurrentLevel;
    int currentLevelIndex = currentLevel - 1;

    if (currentLevel <= 0){
      return points;
    }
    else{
      int currentLevelPoints = getUnlockLevelsPoints()[currentLevelIndex];

      return points - currentLevelPoints;
    }
  }


  int get getDiffereneeBtwNextUnlockPointsAndCurrentUnlockPoints{
    int currentLevel = getPointsCurrentLevel;

    int nextLevelIndex = currentLevel;
    int nextLevelPoints = getUnlockLevelsPoints()[nextLevelIndex];

    if (currentLevel == 0){

      return nextLevelPoints;
    }else{
      int currentLevelIndex = currentLevel - 1;
      int currentLevelPoints = getUnlockLevelsPoints()[currentLevelIndex];

      return (nextLevelPoints - currentLevelPoints).abs();
    }

  }

  double get getPercentRatioToUnlockNextLevel{

    return (getCurrentPointsBeforeUnlockingNextLevel / getDiffereneeBtwNextUnlockPointsAndCurrentUnlockPoints).clamp(0.0, 1.0);
  }
}




class RewardsTypePoints{

  static int signup_reward_point = 50;
  static int opening_app_each_day_reward_point = 5;
  static int publishing_single_post_reward_point = 2;
  static int viewing_post_media_reward_point = 1;
  static int followers_growth_reward_point = 1;
  static int following_growth_reward_point = 1;

  static int finding_a_friend_reward_point = 5;
  static int machine_learning_classification_reward_point = 15;

  static int invite_new_user_reward_point = 10;
}


class AchievementsLevelsUnlockPoints{

  static int profile_audio = 500;
  static int app_theme_color = 1000;

}

