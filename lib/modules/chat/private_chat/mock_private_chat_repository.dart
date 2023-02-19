import 'dart:async';

import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';

import 'private_chat_repository.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/message_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'dart:io';




class MockPrivateChatRepository extends PrivateChatRepository{





  @override
  Future<String> addMessageData({@required MessageModel messageModel, @required String currentUserId, @required String chatUserId}) {

  }

  @override
  Stream<QuerySnapshot> getMessagesDataEvent({
    @required String currentUserId, @required String chatUserId,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap}){


  }


  @override
  Stream<Event> getChatUserOnlineStatus({@required String chatUserId}) {

  }

  @override
  Future<FirebaseUser> getCurrentUser()async {
    return await FirebaseAuthProvider.getCurrentUser();
  }




  @override
  Stream<Event> getChatUserTypingStatus(
      {@required String currentUserId, String chatUserId}) {

  }

  @override
  Future<Function> addCurrentUserTypingStatus(
      {@required String currentUserId, @required String chatUserId, @required bool isTyping}) {

  }


  @override
  Future<Function> onCurrentUserDisconnect(
      {@required String currentUserId, @required String chatUserId}) {

  }


  @override
  Future<Function> addChatsData(
      {@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel}) {

  }


  @override
  Future<FileModel> uploadFile(
      {@required File sourceFile, @required String filename, @required StreamSink<
          int> progressSink, @required StreamSink<int> totalSink}) {

  }

  @override
  Future<Function> addNotificationData({@required OptimisedNotificationModel optimisedNotificationModel, @required String chatUserId}) {

  }


  @override
  Future<Function> updateChattersMessagesSeenField(
      {@required String currentUserId, @required String chatUserId}) {

  }


  @override
  Future<Function> updateChattersSingleMessageSeenField(
      {@required String currentUserId, @required String chatUserId, @required messageId}) {

  }


  @override
  Future<Function> setChatSeen(
      {@required String currentUserId, @required String chatUserId}) {

  }


  @override
  Stream<Event> getChatsData({@required String currentUserId}) {

  }

  @override
  Stream<Event> getCurrentUserSentMessageStateEvent({@required String messageId, @required String currentUserId, @required String chatUserId}) {

  }

  @override
  Future<Function> setCurrentUserSentMessageState({@required String messageState, @required String messageId, @required String currentUserId, @required String chatUserId}) {

  }

  @override
  Future<File> compressVideo({@required String videoPath}) {

  }

  @override
  Future<MediaInfo> getMediaInfo({@required String mediaPath}) {

  }

  @override
  Future<File> getVideoThumbNailFile({@required File videoFile}) {

  }

  @override
  Future<Function> removeCurrentUserSentMessageState(
      {@required String messageId, @required String currentUserId, @required String chatUserId}) {

  }

  @override
  Future<Function> removeMessageData(
      {@required String messageId, @required String currentUserId, @required String chatUserId}) {

  }


  @override
  Future<Function> setMessagesSeen(
      {@required String currentUserId, @required String chatUserId}) {

  }

  @override
  Future<String> getMessageState(
      {@required String messageId, @required String currentUserId, @required String chatUserId}) {

  }

  @override
  Future<Function> setSingleMessageSeen(
      {@required String currentUserId, @required String chatUserId}) {

  }


}


