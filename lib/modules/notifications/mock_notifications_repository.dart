import 'dart:async';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:meta/meta.dart';
import 'notifications_repository.dart';


class MockNotificationsRepository extends NotificationsRepository{


  @override
  Future<List<OptimisedNotificationModel>> getUserNotifications(
      {@required String currentUserId, @required String notificationType, @required int queryLimit, @required String endAtKey}) {

  }

  @override
  Future<bool> getIsUserVerified({@required String userId}) {

  }

  @override
  Future<String> getUserUsername({@required String userId}) {

  }

  @override
  Future<String> getUserProfileThumb({@required String userId}) {

  }

  @override
  Future<String> getUserProfileName({@required String userId}) {

  }

  @override
  Future<Function> deleteNotification(
      {@required String userId, @required String notificationId}) {

  }


}

