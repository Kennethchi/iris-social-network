import 'dart:io';

import 'package:iris_social_network/services/models/post_model.dart';

import 'firestore_provider.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'app_repository.dart';
import 'realtime_database_provider.dart';
import 'server_rest_api_provider.dart';
import 'shared_preferences_provider.dart';
import 'cache_manager_provider.dart';


class ProductionAppRepository extends AppRepository{

  Future<UserModel> getAllCurrentUserData({@required String currentUserId}) async{
    return await FirestoreProvider.getAllCurrentUserData(currentUserId: currentUserId);
  }

  @override
  Future<void> setCurrentUserOnlineStatus({@required String currentUserId, @required int onlineStatus, bool executeOnDisconnect = false})async {
    await RealtimeDatabaseProvider.setCurrentUserOnlineStatus(
        currentUserId: currentUserId,
        onlineStatus: onlineStatus,
        executeOnDisconnect: executeOnDisconnect
    );
  }

  @override
  Future<Function> updateUserDeviceToken({@required String currentUserId, @required String deviceToken}) async{
    await FirestoreProvider.updateUserDeviceToken(currentUserId: currentUserId, deviceToken: deviceToken);
  }

  @override
  Future<bool> isNewUser({@required String userId}) async{

    return await FirestoreProvider.isNewUser(userId: userId);
  }

  @override
  Future<bool> deleteAllFilesInModelData({@required dynamic dynamicModel}) async{
    return await ServerRestApiProvider.deleteAllFilesInModelData(dynamicModel: dynamicModel);
  }


  @override
  Future<dynamic> increaseUserPoints({@required String userId, @required dynamic points})async{
    return await RealtimeDatabaseProvider.increaseUserPoints(userId: userId, points: points);
  }

  @override
  Future<dynamic> decreaseUserPoints({@required String userId, @required dynamic points})async {
    return await RealtimeDatabaseProvider.decreaseUserPoints(userId: userId, points: points);
  }

  @override
  Future<bool> saveAppThemeColorValue({@required int colorValue})async {
    return await SharedPreferencesProvider.saveAppThemeColorValue(colorValue: colorValue);
  }

  @override
  Future<int> getSavedAppThemeColorValue()async {
    return await SharedPreferencesProvider.getSavedAppThemeColorValue();
  }

  @override
  Future<File> getCachedNetworkFile({@required String urlPath}) async{
    return await CacheManagerProvider.getCachedNetworkFile(urlPath: urlPath);
  }

  @override
  Future<int> getTotalAchievedPoints({@required String userId})async {
    return await RealtimeDatabaseProvider.getTotalAchievedPoints(userId: userId);
  }

  @override
  Future<PostModel> getSinglePostData({@required String postId, @required String postUserId})async {
    return await FirestoreProvider.getSinglePostData(postId: postId, postUserId: postUserId);
  }


}
