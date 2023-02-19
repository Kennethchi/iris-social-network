import 'dart:async';

import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';

import 'account_setup_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_provider.dart';
import 'firebase_storage_provider.dart';
import 'firebase_auth_provider.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'realtime_database_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'server_rest_provider.dart';



class ProductionAccountSetupRepository extends AccountSetupRepository{


  @override
  Future<void> addUserProfileData({@required UserModel userModel, @required String userId}) async {

    await FirestoreProvider.addUserProfileData(userModel, userId);

  }


  @override
  Future<String> uploadImage({@required String storagePath, @required File imageFile}) async {

    return await FirebaseStorageProvider.uploadImage(storagePath: storagePath, imageFile: imageFile);

  }

  @override
  Future<UserModel> getCurrentFirebaseUserData() async{
    return await FirebaseAuthProvider.getCurrentFirebaseUserData();
  }

  @override
  Future<bool> checkUsernameIsTaken({@required String userNameTrial})async {
    return await RealtimeDatabaseProvider.checkUsernameIsTaken(userNameTrial: userNameTrial);
  }

  @override
  Future<Function> addOptimisedUserData({@required OptimisedUserModel optimisedUserModel, @required String userId})async {
    await RealtimeDatabaseProvider.addOptimisedUserData(optimisedUserModel: optimisedUserModel, userId: userId);
  }

  @override
  Future<FirebaseUser> getFirebaseUser()async {
    return await FirebaseAuthProvider.getFirebaseUser();
  }

  @override
  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {

    return await ServerRestProvider.uploadFile(sourceFile: sourceFile, filename: filename, progressSink: progressSink, totalSink: totalSink);
  }

  @override
  Future<bool> checkIfUserDataExists({@required String userId})async {

    return await FirestoreProvider.checkIfUserDataExists(userId: userId);
  }

  @override
  Future<Function> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel})async {

    await RealtimeDatabaseProvider.addChatsData(chatUserChatterModel: chatUserChatterModel, currentUserChatterModel: currentUserChatterModel);
  }


}