import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'profile_settings_repository.dart';
import 'mock_profile_settings_repository.dart';
import 'production_profile_settings_repository.dart';



class ProfileSettingsDependencyInjector{

  ProfileSettingsDependencyInjector._internal();

  static final ProfileSettingsDependencyInjector _singleton = ProfileSettingsDependencyInjector._internal();

  factory ProfileSettingsDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void configure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }

  ProfileSettingsRepository get getProfileSettingsRepository{
    switch(_repositoryDependency){
      case REPOSITORY_DEPENDENCY.MOCK:
        return MockProfileSettingsRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionProfileSettingsRepository();
    }
  }


}