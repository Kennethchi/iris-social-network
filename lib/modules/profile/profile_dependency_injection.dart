import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'profile_repository.dart';
import 'mock_profile_repository.dart';
import 'production_profile_repository.dart';


class ProfileDependencyInjector{

  ProfileDependencyInjector._internal();

  static final ProfileDependencyInjector _singleton = ProfileDependencyInjector._internal();

  factory ProfileDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  ProfileRepository get getProfileRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockProfileRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionProfileRepository();

    }

  }




}