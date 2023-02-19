import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';

import 'users_suggestion_mock_repository.dart';
import 'users_suggestion_production_repository.dart';
import 'users_suggestion_repository.dart';




class UsersSuggestionDependencyInjector{

  UsersSuggestionDependencyInjector._internal();

  static final UsersSuggestionDependencyInjector _singleton = UsersSuggestionDependencyInjector._internal();

  factory UsersSuggestionDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  UsersSuggestionRepository get getRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return UsersSuggestionMockRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return UsersSuggestionProductionRepository();
    }

  }




}