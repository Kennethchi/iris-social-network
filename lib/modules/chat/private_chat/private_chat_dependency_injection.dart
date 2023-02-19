import 'package:meta/meta.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'private_chat_repository.dart';
import 'mock_private_chat_repository.dart';
import 'production_private_chat_repository.dart';


class PrivateChatDependencyInjector{

  PrivateChatDependencyInjector._internal();

  static final PrivateChatDependencyInjector _singleton = PrivateChatDependencyInjector._internal();

  factory PrivateChatDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void configure({@required REPOSITORY_DEPENDENCY repository_dependency}){

    _repositoryDependency = repository_dependency;
  }


  PrivateChatRepository get getPrivateChatRepository{

    switch(_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockPrivateChatRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionPrivateChatRepository();

    }
  }












}