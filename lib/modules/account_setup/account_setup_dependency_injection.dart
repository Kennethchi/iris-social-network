import 'account_setup_repository.dart';
import 'mock_account_setup_repository.dart';
import 'production_account_setup_repository.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';



class AccountSetupDependencyInjector{

  AccountSetupDependencyInjector._internal();

  static final AccountSetupDependencyInjector _singleton = AccountSetupDependencyInjector._internal();


  factory AccountSetupDependencyInjector(){
    return _singleton;
  }


  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void configure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  AccountSetupRepository get getAcccountSetupRepository{

    switch(_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockAccountSetupRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionAccountSetupRepository();

    }
  }



}