import 'mock_auth_repository.dart';
import 'auth_repository.dart';
import 'production_auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';


class AuthDependencyInjector{

  AuthDependencyInjector._internal();

  static final AuthDependencyInjector _singleton = new AuthDependencyInjector._internal();

  factory AuthDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void configure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }

  AuthRepository get getAuthRepository{

    switch(_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockAuthRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionAuthRepository();

    }
  }



}