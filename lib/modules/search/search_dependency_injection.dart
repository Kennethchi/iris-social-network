import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'search_repository.dart';
import 'mock_search_repository.dart';
import 'production_search_repository.dart';




class SearchDependencyInjector{

  SearchDependencyInjector._internal();

  static final SearchDependencyInjector _singleton = SearchDependencyInjector._internal();

  factory SearchDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  SearchRepository get getSearchRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockSearchRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionSearchRepository();

    }

  }




}