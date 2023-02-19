import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';

import 'profile_repository.dart';
import 'package:meta/meta.dart';
import 'firestore_provider.dart';
import 'realtime_database_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_provider.dart';
import 'dart:io';
import 'firebase_storage_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:iris_social_network/services/models/video_model.dart';


import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/post_model.dart';

import 'server_rest_provider.dart';
import 'cache_manager_provider.dart';


class ProductionProfileRepository extends ProfileRepository{


  @override
  Future<UserModel> getProfileUserData({@required String profileUserId}) async {

    return await FirestoreProvider.getProfileUserData(profileUserId: profileUserId);
  }

  @override
  Stream<Event> checkCurrentUserIsAFollowerStreamEvent({@required String currentUserId, @required profileUserId}){
    return RealtimeDatabaseProvider.checkCurrentUserIsAFollowerStreamEvent(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Future<void> addProfileUserFollower({@required OptimisedFFModel optimisedFFModel, @required String profileUserId})async {
    return await RealtimeDatabaseProvider.addProfileUserFollower(optimisedFFModel: optimisedFFModel, profileUserId: profileUserId);
  }

  @override
  Future<void> removeProfileUserFollower({@required String currentUserId, @required String profileUserId})async {
    return await RealtimeDatabaseProvider.removeProfileUserFollower(currentUserId: currentUserId, profileUserId: profileUserId);
  }


  @override
  Future<Function> addCurrentUserFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId}) async {
    await RealtimeDatabaseProvider.addCurrentUserFollowing(optimisedFFModel: optimisedFFModel, currentUserId: currentUserId);
  }

  @override
  Future<Function> removeCurrentUserFollowing({@required String profileUserId, @required String currentUserId})async {
    await RealtimeDatabaseProvider.removeCurrentUserFollowing(profileUserId: profileUserId, currentUserId: currentUserId);
  }

  @override
  Future<FirebaseUser> getFirebaseUser()async {
    return await FirebaseAuthProvider.getFirebaseUser();
  }


  @override
  Future<int> getNumberFollowers({@required String profileUserId})async {
    return await RealtimeDatabaseProvider.getNumberFollowers(profileUserId: profileUserId);
  }

  @override
  Future<int> getNumberFollowings({@required String profileUserId}) async{
    return await RealtimeDatabaseProvider.getNumberFollowings(profileUserId: profileUserId);
  }


  @override
  Future<int> getNumberOfPosts({@required String profileUserId})async {
    return await RealtimeDatabaseProvider.getNumberOfPosts(profileUserId: profileUserId);
  }


  @override
  Stream<Event> getNumberOfPostsStreamEvent({@required String profileUserId}) {
    return RealtimeDatabaseProvider.getNumberOfPostsStreamEvent(profileUserId: profileUserId);
  }

  @override
  Future<String> uploadFile({@required storagePath, @required File file})async {
    return await FirebaseStorageProvider.uploadFile(storagePath: storagePath, file: file);
  }



  @override
  Future<bool> removeFile({@required String urlPath})async {

    return await FirebaseStorageProvider.removeFile(urlPath: urlPath);
  }

  @override
  Future<List<PostModel>> getProfileUserPostsData({
    @required String profileUserId,
    @required postType = null,
    @required String postAudience,
    @required POST_QUERY_TYPE postQueryType = POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap}) async{

    return await FirestoreProvider.getProfileUserPostsData(
        profileUserId: profileUserId,
        postType: postType,
        postAudience: postAudience,
        postQueryType: postQueryType,
        queryLimit: queryLimit,
        startAfterMap: startAfterMap
    );
  }

  @override
  Future<Function> removePostData({@required String postId, @required String currentUserId})async {
    await FirestoreProvider.removePostData(postId: postId, currentUserId: currentUserId);
  }

  @override
  Future<bool> deleteFile({@required String urlPath}) async{
    return await ServerRestProvider.deleteFile(urlPath: urlPath);
  }

  @override
  Future<Function> removePostLikes({@required String postId, @required String postUserId})async {
    await RealtimeDatabaseProvider.removePostLikes(postId: postId, postUserId: postUserId);
  }

  @override
  Future<Function> removePostComments({@required String postId, @required String postUserId})async {
    await RealtimeDatabaseProvider.removePostComments(postId: postId, postUserId: postUserId);
  }

  @override
  Future<Function> removeOptimisedPostData({@required String postId, @required String currentUserId})async {
    await RealtimeDatabaseProvider.removeOptimisedPostData(postId: postId, currentUserId: currentUserId);
  }

  @override
  Stream<Event> checkProfileUserIsCurrentUserFollowerStreamEvent({@required String currentUserId, @required profileUserId}){
    return RealtimeDatabaseProvider.checkProfileUserIsCurrentUserFollowerStreamEvent(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Future<Function> removeFriendRequest({@required String currentUserId, @required String profileUserId})async {
    await RealtimeDatabaseProvider.removeFriendRequest(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Future<Function> sendFriendRequest({@required String currentUserId, @required String profileUserId})async {
    await RealtimeDatabaseProvider.sendFriendRequest(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Stream<Event> checkProfileUserSentFriendRequestToCurrentUserStreamEvent({@required String currentUserId, @required profileUserId}) {
    return RealtimeDatabaseProvider.checkProfileUserSentFriendRequestToCurrentUserStreamEvent(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Stream<Event> checkCurrentUserSentFriendRequestToProfileUserStreamEvent({@required String currentUserId, @required profileUserId}) {

    return RealtimeDatabaseProvider.checkCurrentUserSentFriendRequestToProfileUserStreamEvent(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Future<Function> sendFriendRequestNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId})async {

    await RealtimeDatabaseProvider.sendFriendRequestNotification(optimisedNotificationModel: optimisedNotificationModel, profileUserId: profileUserId);
  }

  @override
  Future<Function> addFriendToUserFriendList({@required FriendModel friendModel, @required String userId})async {
    await FirestoreProvider.addFriendToUserFriendList(friendModel: friendModel, userId: userId);
  }

  @override
  Future<Function> sendFriendRequestAcceptedNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId})async {

    await RealtimeDatabaseProvider.sendFriendRequestAcceptedNotification(optimisedNotificationModel: optimisedNotificationModel, profileUserId: profileUserId);
  }

  @override
  Future<void> removeFriendRequestNotification({@required String currentUserId, @required String profileUserId})async {
    await RealtimeDatabaseProvider.removeFriendRequestNotification(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Future<bool> checkIfUserSentFriendRequestNotification({@required String currentUserId, @required String profileUserId})async{
    return await RealtimeDatabaseProvider.checkIfUserSentFriendRequestNotification(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Future<int> getTotalAchievedPoints({@required String userId})async {
    return await RealtimeDatabaseProvider.getTotalAchievedPoints(userId: userId);
  }

  @override
  Future<File> getCachedNetworkFile({@required String urlPath})async {
    return await CacheManagerProvider.getCachedNetworkFile(urlPath: urlPath);
  }


}