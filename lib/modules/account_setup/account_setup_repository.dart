import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:iris_social_network/services/optimised_models/optimised_user_model.dart';


abstract class AccountSetupRepository{

  Future<void> addUserProfileData({@required UserModel userModel, @required String userId});

  Future<String> uploadImage({@required String storagePath, @required File imageFile});

  Future<UserModel> getCurrentFirebaseUserData();

  Future<bool> checkUsernameIsTaken({@required String userNameTrial});

  Future<void> addOptimisedUserData({@required OptimisedUserModel optimisedUserModel, @required String userId});

  Future<FirebaseUser> getFirebaseUser();

  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink});

  Future<bool> checkIfUserDataExists({@required String userId});

  Future<void> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel});
}