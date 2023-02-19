import 'dart:async';

import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:iris_social_network/modules/chat/private_chat/server_rest_provider.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';

import 'private_chat_repository.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/message_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'firestore_provider.dart';
import 'firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'realtime_database_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'firebase_storage_provider.dart';
import 'dart:io';
import 'media_provider.dart';


class ProductionPrivateChatRepository extends PrivateChatRepository{


  @override
  Future<String> addMessageData({@required MessageModel messageModel, @required String currentUserId, @required String chatUserId}) async{
    return await FirestoreProvider.addMessageData(messageModel: messageModel, currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Stream<QuerySnapshot> getMessagesDataEvent({
    @required String currentUserId, @required String chatUserId, @required int queryLimit, @required Map<String, dynamic> startAfterMap
  }){
    return FirestoreProvider.getMessagesDataEvent(currentUserId: currentUserId, chatUserId: chatUserId, queryLimit: queryLimit, startAfterMap: startAfterMap);
  }

  @override
  Stream<Event> getChatUserOnlineStatus({@required String chatUserId}) {
    return RealtimeDatabaseProvider.getChatUserOnlineStatus(chatUserId: chatUserId);
  }


  @override
  Stream<Event> getChatUserTypingStatus({@required String currentUserId, @required String chatUserId}) {
    return RealtimeDatabaseProvider.getChatUserTypingStatus(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<Function> addCurrentUserTypingStatus({@required String currentUserId, @required String chatUserId, @required bool isTyping}) async {
    await RealtimeDatabaseProvider.addCurrentUserTypingStatus(currentUserId: currentUserId, chatUserId: chatUserId, isTyping: isTyping);
  }


  @override
  Future<Function> onCurrentUserDisconnect({@required String currentUserId, @required String chatUserId}) async {
    await RealtimeDatabaseProvider.onCurrentUserDisconnect(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<Function> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel}) async{
    await RealtimeDatabaseProvider.addChatsData(chatUserChatterModel: chatUserChatterModel, currentUserChatterModel: currentUserChatterModel);
  }



  @override
  Future<FirebaseUser> getCurrentUser() async{

    return await FirebaseAuthProvider.getCurrentUser();
  }


  @override
  Future<Function> addNotificationData({@required OptimisedNotificationModel optimisedNotificationModel, @required String chatUserId}) async {
    await RealtimeDatabaseProvider.addNotificationData(optimisedNotificationModel: optimisedNotificationModel, chatUserId: chatUserId);
  }

  @override
  Future<Function> updateChattersMessagesSeenField({@required String currentUserId, @required String chatUserId})async {
    await FirestoreProvider.updateChattersMessagesSeenField(currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<Function> updateChattersSingleMessageSeenField(
      {@required String currentUserId, @required String chatUserId, @required messageId}) async {
    await FirestoreProvider.updateChattersSingleMessageSeenField(currentUserId: currentUserId, chatUserId: chatUserId, messageId: messageId);
  }

  @override
  Future<Function> setChatSeen({@required String currentUserId, @required String chatUserId}) async {
    await RealtimeDatabaseProvider.setChatSeen(currentUserId: currentUserId, chatUserId: chatUserId);
  }



  @override
  Stream<Event> getCurrentUserSentMessageStateEvent({@required String messageId, @required String currentUserId, @required String chatUserId}) {

    return RealtimeDatabaseProvider.getCurrentUserSentMessageStateEvent(messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<Function> setCurrentUserSentMessageState(
      {@required String messageState, @required String messageId, @required String currentUserId, @required String chatUserId}) async{

    await RealtimeDatabaseProvider.setCurrentUserSentMessageState(messageState: messageState, messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<FileModel> uploadFile(
      {@required File sourceFile, @required String filename, @required StreamSink<
          int> progressSink, @required StreamSink<int> totalSink})async {

    return await ServerRestProvider.uploadFile(sourceFile: sourceFile, filename: filename, progressSink: progressSink, totalSink: totalSink);
  }

  @override
  Future<File> compressVideo({@required String videoPath})async {
    return await  MediaProvider.compressVideo(videoPath: videoPath);
  }

  @override
  Future<MediaInfo> getMediaInfo({@required String mediaPath})async {
    return await MediaProvider.getMediaInfo(mediaPath: mediaPath);
  }

  @override
  Future<File> getVideoThumbNailFile({@required File videoFile})async {
    return await MediaProvider.getVideoThumbNailFile(videoFile: videoFile);
  }

  @override
  Future<Function> removeCurrentUserSentMessageState({@required String messageId, @required String currentUserId, @required String chatUserId})async {
    await RealtimeDatabaseProvider.removeCurrentUserSentMessageState(messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<Function> removeMessageData({@required String messageId, @required String currentUserId, @required String chatUserId})async {
    await FirestoreProvider.removeMessageData(messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<Function> setMessagesSeen({@required String currentUserId, @required String chatUserId})async {
    await RealtimeDatabaseProvider.setMessagesSeen(currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<String> getMessageState({@required String messageId, @required String currentUserId, @required String chatUserId})async{
    return await RealtimeDatabaseProvider.getMessageState(messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<Function> setSingleMessageSeen({@required String currentUserId, @required String chatUserId})async{
     await RealtimeDatabaseProvider.setSingleMessageSeen(currentUserId: currentUserId, chatUserId: chatUserId);
  }


}




