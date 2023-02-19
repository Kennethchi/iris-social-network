import 'package:iris_social_network/services/constants/app_constants.dart';
import 'post_room_repository.dart';
import 'mock_post_room_repository.dart';
import 'production_post_room_repository.dart';
import 'package:meta/meta.dart';




class PostRoomDependencyInjector{


  PostRoomDependencyInjector._internal();

  static final PostRoomDependencyInjector _singleton = PostRoomDependencyInjector._internal();

  factory PostRoomDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void configure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }

  PostRoomRepository get getPostRoomRepository{
    switch(_repositoryDependency){
      case REPOSITORY_DEPENDENCY.MOCK:
        return MockPostRoomRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionPostRoomRepository();
    }

  }



}