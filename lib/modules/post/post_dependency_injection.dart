import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'post_repository.dart';
import 'mock_post_repository.dart';
import 'production_post_repository.dart';




class PostDependencyInjector{

  PostDependencyInjector._internal();

  static final PostDependencyInjector _singleton = PostDependencyInjector._internal();

  factory PostDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  PostRepository get getPostRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockPostRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionPostRepository();

    }

  }




}