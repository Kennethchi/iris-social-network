import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';

import 'home_repository.dart';
import 'package:meta/meta.dart';


class MockHomeRepository extends HomeRepository{


  @override
  Future<bool> isNewUser({@required String userId}) {

  }

  @override
  Future<String> getFCMToken() {

  }

  @override
  Future<Function> updateUserFCMToken(
      {@required String currentUserId, @required String fcmToken}) {

  }

  @override
  Future<PostModel> getSinglePostData({@required String postId, @required String postUserId}) {

  }


}