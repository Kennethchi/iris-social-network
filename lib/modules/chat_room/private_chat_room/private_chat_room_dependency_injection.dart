import 'private_chat_room_repository.dart';
import 'mock_private_chat_room_repository.dart';
import 'production_private_chat_room_repository.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';



class PrivateChatRoomDependencyInjector{

  PrivateChatRoomDependencyInjector._internal();

  static final PrivateChatRoomDependencyInjector _singleton = PrivateChatRoomDependencyInjector._internal();

  factory PrivateChatRoomDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void configure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  PrivateChatRoomRepository get getPrivateChatRoomRepository{

    switch(_repositoryDependency){
      case REPOSITORY_DEPENDENCY.MOCK:
        return MockPrivateChatRoomRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionPrivateChatRoomRepository();
    }

  }






}