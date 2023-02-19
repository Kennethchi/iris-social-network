import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';

import 'mock_notifications_repository.dart';
import 'notifications_repository.dart';
import 'production_notifications_repository.dart';




class NotificationsDependencyInjector{

  NotificationsDependencyInjector._internal();

  static final NotificationsDependencyInjector _singleton = NotificationsDependencyInjector._internal();

  factory NotificationsDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  NotificationsRepository get getNotificationsRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return MockNotificationsRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ProductionNotificationsRepository();

    }

  }




}