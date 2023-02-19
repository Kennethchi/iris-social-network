import 'dart:io';

import 'package:iris_social_network/services/models/post_model.dart';

import 'firestore_provider.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'dart:async';
import 'package:meta/meta.dart';


abstract class AppRepository{

  Future<bool> isNewUser({@required String userId});

  Future<UserModel> getAllCurrentUserData({@required String currentUserId});

  Future<void> setCurrentUserOnlineStatus({@required String currentUserId, @required int onlineStatus, bool executeOnDisconnect});

  Future<void> updateUserDeviceToken({@required String currentUserId, @required String deviceToken});

  Future<bool> deleteAllFilesInModelData({@required dynamic dynamicModel});


  Future<dynamic>  increaseUserPoints({@required String userId, @required dynamic points});

  Future<dynamic>  decreaseUserPoints({@required String userId, @required dynamic points});

  Future<bool> saveAppThemeColorValue({@required int colorValue});

  Future<int> getSavedAppThemeColorValue();

  Future<File> getCachedNetworkFile({@required String urlPath});

  Future<int> getTotalAchievedPoints({@required String userId});

  Future<PostModel> getSinglePostData({@required String postId, @required String postUserId});
}




