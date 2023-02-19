import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:meta/meta.dart';
import 'account_setup_repository.dart';
import 'dart:io';
import 'package:iris_social_network/services/optimised_models/optimised_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MockAccountSetupRepository extends AccountSetupRepository{

  @override
  Future<void> addUserProfileData({@required UserModel userModel, @required String userId}) {

  }

  @override
  Future<String> uploadImage(
      {@required String storagePath, @required File imageFile}) {

  }

  @override
  Future<UserModel> getCurrentFirebaseUserData() {

  }

  @override
  Future<bool> checkUsernameIsTaken({@required String userNameTrial}) {

  }

  @override
  Future<Function> addOptimisedUserData(
      {OptimisedUserModel optimisedUserModel, String userId}) {

  }

  @override
  Future<FirebaseUser> getFirebaseUser() {

  }

  @override
  Future<FileModel> uploadFile(
      {@required File sourceFile, @required String filename, @required StreamSink<
          int> progressSink, @required StreamSink<int> totalSink}) {

  }

  @override
  Future<bool> checkIfUserDataExists({@required String userId}) {

  }

  @override
  Future<Function> addChatsData(
      {@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel}) {

  }


}






