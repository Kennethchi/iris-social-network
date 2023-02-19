import 'package:iris_social_network/services/constants/app_constants.dart';
import 'app_repository.dart';
import 'mock_app_repository.dart';
import 'production_app_repository.dart';
import 'package:meta/meta.dart';


class AppDependencyInjector{

  AppDependencyInjector._internal();

  static final AppDependencyInjector _singleton = AppDependencyInjector._internal();

  factory AppDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void configure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  AppRepository get getAppRepository{
    switch(_repositoryDependency){
      case REPOSITORY_DEPENDENCY.MOCK:
        return MockAppRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionAppRepository();
    }
  }




}



