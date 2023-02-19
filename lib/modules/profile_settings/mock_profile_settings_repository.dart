import 'profile_settings_repository.dart';
import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';


class MockProfileSettingsRepository extends ProfileSettingsRepository{


  @override
  Future<UserModel> getProfileUserData({@required String profileUserId}) {

  }

  @override
  Future<Function> updateProfileSettings(
      {@required String currentUserId, @required Map<String,
          dynamic> currentUserUpdateData}) {

  }

  @override
  Future<FileModel> uploadFile(
      {@required File sourceFile, @required String filename, @required StreamSink<
          int> progressSink, @required StreamSink<int> totalSink}) {

  }

  @override
  Future<Function> updateOptimisedUserData(
      {@required String userId, @required Map<String,
          dynamic> updataDataMap}) {

  }

  @override
  Future<bool> saveAppThemeColorValue({@required int colorValue}) {

  }

  @override
  Future<int> getSavedAppThemeColorValue() {

  }


}