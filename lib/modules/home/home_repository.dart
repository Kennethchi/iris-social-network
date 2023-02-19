import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class HomeRepository{

  Future<bool> isNewUser({@required String userId});

  Future<String> getFCMToken();

  Future<void> updateUserFCMToken({@required String currentUserId, @required String fcmToken});

  Future<PostModel> getSinglePostData({@required String postId, @required String postUserId});
}


