import 'package:iris_social_network/modules/create_message/production_create_message_repository.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';

import 'create_message_repository.dart';
import 'mock_create_message_repository.dart';




class CreateMessageDependencyInjector{

  CreateMessageDependencyInjector._internal();

  static final CreateMessageDependencyInjector _singleton = CreateMessageDependencyInjector._internal();

  factory CreateMessageDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  CreateMessageRepository get getCreateMessageRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockCreateMessageRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionCreateMessageRepository();

    }

  }




}