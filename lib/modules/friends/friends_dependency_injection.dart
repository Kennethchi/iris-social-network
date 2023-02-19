import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';

import 'friends_repository.dart';
import 'mock_friends_repository.dart';
import 'production_friends_repository.dart';




class FriendsDependencyInjector{

  FriendsDependencyInjector._internal();

  static final FriendsDependencyInjector _singleton = FriendsDependencyInjector._internal();

  factory FriendsDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  FriendsRepository get getFriendsRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockFriendsRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionFriendsRepository();

    }

  }




}