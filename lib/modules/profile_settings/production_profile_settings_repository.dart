import 'profile_settings_repository.dart';
import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'firestore_provider.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'server_rest_provider.dart';
import 'realtime_database_provider.dart';
import 'shared_preferences_provider.dart';



class ProductionProfileSettingsRepository extends ProfileSettingsRepository{


  @override
  Future<UserModel> getProfileUserData({@required String profileUserId})async {

    return await FirestoreProvider.getProfileUserData(profileUserId: profileUserId);
  }



  @override
  Future<Function> updateProfileSettings({@required String currentUserId, @required Map<String, dynamic> currentUserUpdateData})async {

    await FirestoreProvider.updateProfileSettings(currentUserId: currentUserId, currentUserUpdateData: currentUserUpdateData);
  }

  @override
  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {

    return await ServerRestProvider.uploadFile(sourceFile: sourceFile, filename: filename, progressSink: progressSink, totalSink: totalSink);
  }

  @override
  Future<Function> updateOptimisedUserData({@required String userId, @required Map<String, dynamic> updataDataMap}) async {

    await RealtimeDatabaseProvider.updateOptimisedUserData(userId: userId, updataDataMap: updataDataMap);
  }

  @override
  Future<bool> saveAppThemeColorValue({@required int colorValue})async {

    return await SharedPreferencesProvider.saveAppThemeColorValue(colorValue: colorValue);
  }

  @override
  Future<int> getSavedAppThemeColorValue()async {

    return await SharedPreferencesProvider.getSavedAppThemeColorValue();
  }


}


