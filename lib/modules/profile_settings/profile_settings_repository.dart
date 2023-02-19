import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';



abstract class ProfileSettingsRepository{


  Future<UserModel> getProfileUserData({@required String profileUserId});

  Future<void> updateProfileSettings({@required String currentUserId, @required Map<String, dynamic> currentUserUpdateData});

  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink});

  Future<void> updateOptimisedUserData({@required String userId, @required Map<String, dynamic> updataDataMap});

  Future<bool> saveAppThemeColorValue({@required int colorValue});

  Future<int> getSavedAppThemeColorValue();
}