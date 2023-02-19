import 'home_repository.dart';
import 'mock_home_repository.dart';
import 'production_home_repository.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';


class HomeDependencyInjector{

  HomeDependencyInjector._internal();

  static final HomeDependencyInjector _singleton = HomeDependencyInjector._internal();

  factory HomeDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void configure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }

  HomeRepository get getHomeRepository{

    switch(_repositoryDependency){
      case REPOSITORY_DEPENDENCY.MOCK:
        return MockHomeRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionHomeRepository();

    }
  }


}