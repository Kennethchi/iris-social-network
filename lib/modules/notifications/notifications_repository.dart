import 'dart:async';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:meta/meta.dart';


abstract class NotificationsRepository{

  Future<List<OptimisedNotificationModel>> getUserNotifications({
    @required String currentUserId, @required String notificationType, @required int queryLimit, @required String endAtKey
  });

  Future<String> getUserProfileName({@required String userId});

  Future<String> getUserProfileThumb({@required String userId});

  Future<String> getUserUsername({@required String userId});

  Future<bool> getIsUserVerified({@required String userId});

  Future<void> deleteNotification({@required String userId, @required String notificationId});

}



