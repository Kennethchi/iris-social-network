import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';

import 'achievements_mock_repository.dart';
import 'achievements_production_repository.dart';
import 'achievements_repository.dart';




class AchievementsDependencyInjector{

  AchievementsDependencyInjector._internal();

  static final AchievementsDependencyInjector _singleton = AchievementsDependencyInjector._internal();

  factory AchievementsDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  AchievementsRepository get getAchievementsRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return AchievementsMockRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return AchievementsProductionRepository();

    }

  }




}