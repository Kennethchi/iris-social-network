import 'package:iris_social_network/services/constants/app_constants.dart';
import 'post_feed_repository.dart';
import 'mock_post_feed_repository.dart';
import 'production_post_feed_repository.dart';
import 'package:meta/meta.dart';



class PostFeedDependencyInjector{

  PostFeedDependencyInjector._internal();

  static final PostFeedDependencyInjector _singleton = PostFeedDependencyInjector._internal();

  factory PostFeedDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static PostFeedRepository configure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  PostFeedRepository get getPostFeedRepository{

    switch(_repositoryDependency){
      case REPOSITORY_DEPENDENCY.MOCK:
        return MockPostFeedRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionPostFeedRepository();
    }

  }


}





