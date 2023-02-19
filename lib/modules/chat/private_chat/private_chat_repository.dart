import 'dart:async';

import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:meta/meta.dart';
import 'firestore_provider.dart';
import 'package:iris_social_network/services/models/message_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'dart:io';


abstract class PrivateChatRepository{

  Future<String>  addMessageData({@required MessageModel messageModel, @required String currentUserId, @required String chatUserId});


  Stream<QuerySnapshot> getMessagesDataEvent({
    @required String currentUserId, @required String chatUserId,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap});

  Stream<Event> getChatUserOnlineStatus({@required String chatUserId });

  Stream<Event> getChatUserTypingStatus({@required String currentUserId, @required  String chatUserId});

  Future<void> addCurrentUserTypingStatus({@required String currentUserId, @required String chatUserId, @required bool isTyping});

  Future<void> onCurrentUserDisconnect({@required String currentUserId, @required String chatUserId});

  Future<void> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel});


  Future<FirebaseUser> getCurrentUser();

  /*
  Future<void> addMessageImageData({
    @required MessageModel userMessageModel,
    @required String currentUserImageUrl,
    @required String chatUserImageUrl,
    @required String currentUserThumb,
    @required String chatUserThumb});
    */


  Future<void> addNotificationData({@required OptimisedNotificationModel optimisedNotificationModel, @required String chatUserId});


  Future<void> updateChattersMessagesSeenField({@required String currentUserId, @required String chatUserId});

  Future<void> updateChattersSingleMessageSeenField({@required String currentUserId, @required String chatUserId, @required messageId});

  Future<void> setChatSeen({@required String currentUserId, @required String chatUserId});

  Future<void> setCurrentUserSentMessageState({@required String messageState, @required String messageId, @required String currentUserId, @required String chatUserId});

  Stream<Event> getCurrentUserSentMessageStateEvent({@required String messageId, @required String currentUserId, @required String chatUserId});

  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink});


  Future<File> getVideoThumbNailFile({@required File videoFile});

  Future<MediaInfo> getMediaInfo({@required String mediaPath});

  Future<File> compressVideo({@required String videoPath});


  Future<void>  removeMessageData({@required String messageId, @required String currentUserId, @required String chatUserId});

  Future<void> removeCurrentUserSentMessageState({@required String messageId, @required String currentUserId, @required String chatUserId});

  Future<String> getMessageState({@required String messageId, @required String currentUserId, @required String chatUserId});

  Future<void> setMessagesSeen({@required String currentUserId, @required String chatUserId});

  Future<void> setSingleMessageSeen({@required String currentUserId, @required String chatUserId});
}






