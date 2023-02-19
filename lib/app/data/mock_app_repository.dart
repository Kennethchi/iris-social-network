import 'dart:io';

import 'package:iris_social_network/services/models/post_model.dart';

import 'firestore_provider.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'app_repository.dart';


class MockAppRepository extends AppRepository{



  Future<UserModel> getAllCurrentUserData({@required String currentUserId}) async{

  }

  @override
  Future<void> setCurrentUserOnlineStatus(
      {@required String currentUserId, @required int onlineStatus, bool executeOnDisconnect}) {

  }

  @override
  Future<Function> updateUserDeviceToken(
      {@required String currentUserId, @required String deviceToken}) {

  }

  @override
  Future<bool> isNewUser({@required String userId}) {

  }

  @override
  Future<bool> deleteAllFilesInModelData({@required dynamic dynamicModel}) {

  }

  @override
  Future<dynamic> decreaseUserPoints(
      {@required String userId, @required dynamic points}) {

  }

  @override
  Future<dynamic> increaseUserPoints(
      {@required String userId, @required dynamic points}) {

  }

  @override
  Future<int> getSavedAppThemeColorValue() {

  }

  @override
  Future<bool> saveAppThemeColorValue({@required int colorValue}) {

  }

  @override
  Future<File> getCachedNetworkFile({@required String urlPath}) {

  }

  @override
  Future<int> getTotalAchievedPoints({@required String userId}) {

  }

  @override
  Future<PostModel> getSinglePostData(
      {@required String postId, @required String postUserId}) {

  }


}
