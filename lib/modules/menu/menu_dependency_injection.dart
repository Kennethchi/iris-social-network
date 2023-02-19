import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'menu_repository.dart';
import 'mock_menu_repository.dart';
import 'production_menu_repository.dart';




class MenuDependencyInjector{

  MenuDependencyInjector._internal();

  static final MenuDependencyInjector _singleton = MenuDependencyInjector._internal();

  factory MenuDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  MenuRepository get getMenuRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockMenuRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionMenuRepository();

    }

  }




}