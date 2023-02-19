import 'dart:async';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:meta/meta.dart';

import 'notifications_repository.dart';
import 'realtime_database_provider.dart';


class ProductionNotificationsRepository extends NotificationsRepository{


  @override
  Future<List<OptimisedNotificationModel>> getUserNotifications({
    @required String currentUserId, @required String notificationType, @required int queryLimit, @required String endAtKey
  })async {

    return await RealtimeDatabaseProvider.getUserNotifications(currentUserId: currentUserId, notificationType: notificationType, queryLimit: queryLimit, endAtKey: endAtKey);
  }

  @override
  Future<bool> getIsUserVerified({@required String userId})async {
    return await RealtimeDatabaseProvider.getIsUserVerified(userId: userId);
  }

  @override
  Future<String> getUserUsername({@required String userId})async {
    return await RealtimeDatabaseProvider.getUserUsername(userId: userId);
  }

  @override
  Future<String> getUserProfileThumb({@required String userId})async {
    return await RealtimeDatabaseProvider.getUserProfileThumb(userId: userId);
  }

  @override
  Future<String> getUserProfileName({@required String userId})async {
    return await RealtimeDatabaseProvider.getUserProfileName(userId: userId);
  }

  @override
  Future<Function> deleteNotification({@required String userId, @required String notificationId})async {
    await RealtimeDatabaseProvider.deleteNotification(userId: userId, notificationId: notificationId);
  }


}