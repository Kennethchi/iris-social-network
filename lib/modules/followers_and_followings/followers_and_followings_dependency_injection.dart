import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'followers_and_followings_repository.dart';
import 'mock_followers_and_followings_repository.dart';
import 'production_followers_and_followings_repository.dart';





class FollowersAndFollowingsDependencyInjector{

  FollowersAndFollowingsDependencyInjector._internal();

  static final FollowersAndFollowingsDependencyInjector _singleton = FollowersAndFollowingsDependencyInjector._internal();

  factory FollowersAndFollowingsDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  FollowersAndFollowingsRepository get getFollowersAndFollowingsRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockFollowersAndFollowingsRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionFollowersAndFollowingsRepository();
    }

  }




}