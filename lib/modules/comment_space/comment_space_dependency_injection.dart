import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'comment_space_repository.dart';
import 'mock_comment_space_repository.dart';
import 'production_comment_space_repository.dart';




class CommentSpaceDependencyInjector{

  CommentSpaceDependencyInjector._internal();

  static final CommentSpaceDependencyInjector _singleton = CommentSpaceDependencyInjector._internal();

  factory CommentSpaceDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void configure({@required REPOSITORY_DEPENDENCY repository_dependency}){

    _repositoryDependency = repository_dependency;
  }


  CommentSpaceRepository get getCommentSpaceRepository{
    switch(_repositoryDependency){
      case REPOSITORY_DEPENDENCY.MOCK:
        return MockCommentSpaceRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionCommentSpaceRepository();
    }
  }


}