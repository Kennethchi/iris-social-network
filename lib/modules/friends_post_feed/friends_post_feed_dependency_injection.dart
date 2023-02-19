import 'package:iris_social_network/services/constants/app_constants.dart';
import 'friends_post_feed_repository.dart';
import 'mock_friends_post_feed_repository.dart';
import 'production_friends_post_feed_repository.dart';
import 'package:meta/meta.dart';



class FriendsPostFeedDependencyInjector{

  FriendsPostFeedDependencyInjector._internal();

  static final FriendsPostFeedDependencyInjector _singleton = FriendsPostFeedDependencyInjector._internal();

  factory FriendsPostFeedDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static FriendsPostFeedRepository configure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  FriendsPostFeedRepository get getFriendsPostFeedRepository{

    switch(_repositoryDependency){
      case REPOSITORY_DEPENDENCY.MOCK:
        return MockFriendsPostFeedRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionFriendsPostFeedRepository();
    }

  }


}





