import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';

import 'profile_repository.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:iris_social_network/services/models/video_model.dart';


import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/post_model.dart';




class MockProfileRepository extends ProfileRepository{


  @override
  Future<UserModel> getProfileUserData(
      {@required String profileUserId}) {

  }

  @override
  Future<Function> removePostLikes({@required String postId, @required String postUserId}) {

  }

  @override
  Future<Function> removePostComments({@required String postId, @required String postUserId}) {

  }

  @override
  Future<bool> deleteFile({@required String urlPath}) {

  }

  @override
  Future<Function> removePostData({@required String postId, @required String currentUserId}) {

  }

  @override
  Future<List<PostModel>> getProfileUserPostsData(
      {@required String profileUserId, @required postType = null, @required String postAudience, @required POST_QUERY_TYPE postQueryType = POST_QUERY_TYPE
          .MOST_RECENT, @required int queryLimit, @required Map<String,
          dynamic> startAfterMap}) {

  }

  @override
  Future<bool> removeFile({@required String urlPath}) {

  }

  @override
  Future<Function> removeVideoPreviewData(
      {@required String videoId, @required String profileUserId}) {

  }

  @override
  Future<List<OptimisedVideoPreviewModel>> getProfileUserVideosPreviewData(
      {@required String profileUserId}) {

  }

  @override
  Future<Function> addVideoPreviewData(
      {@required OptimisedVideoPreviewModel optimisedVideoPreviewModel, @required String videoId, @required String profileUserId}) {

  }

  @override
  Future<String> addVideoData(
      {@required VideoModel videoModel, @required String profileUserId}) {

  }

  @override
  Future<String> uploadFile({@required storagePath, @required File file}) {

  }

  @override
  Future<int> getNumberOfPosts({@required String profileUserId}) {

  }

  @override
  Stream<Event> getNumberOfPostsStreamEvent({@required String profileUserId}) {

  }

  @override
  Future<int> getNumberFollowings({@required String profileUserId}) {

  }

  @override
  Future<int> getNumberFollowers({@required String profileUserId}) {

  }

  @override
  Future<FirebaseUser> getFirebaseUser() {

  }

  @override
  Future<Function> removeCurrentUserFollowing(
      {@required String profileUserId, @required String currentUserId}) {

  }

  @override
  Future<Function> removeProfileUserFollower(
      {@required String currentUserId, @required String profileUserId}) {

  }

  @override
  Future<Function> addCurrentUserFollowing(
      {@required OptimisedFFModel optimisedFFModel, @required String currentUserId}) {

  }

  @override
  Future<Function> addProfileUserFollower(
      {@required OptimisedFFModel optimisedFFModel, @required String profileUserId}) {

  }

  @override
  Stream<Event> checkCurrentUserIsAFollowerStreamEvent(
      {@required String currentUserId, @required profileUserId}) {

  }

  @override
  Future<Function> removeOptimisedPostData(
      {@required String postId, @required String currentUserId}) {

  }

  @override
  Stream<Event> checkProfileUserIsCurrentUserFollowerStreamEvent(
      {@required String currentUserId, @required profileUserId}) {

  }

  @override
  Future<Function> removeFriendRequest(
      {@required String currentUserId, @required String profileUserId}) {

  }

  @override
  Future<Function> sendFriendRequest(
      {@required String currentUserId, @required String profileUserId}) {

  }

  @override
  Stream<Event> checkProfileUserSentFriendRequestToCurrentUserStreamEvent(
      {@required String currentUserId, @required profileUserId}) {

  }

  @override
  Stream<Event> checkCurrentUserSentFriendRequestToProfileUserStreamEvent(
      {@required String currentUserId, @required profileUserId}) {

  }

  @override
  Future<Function> sendFriendRequestNotification(
      {@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId}) {

  }

  @override
  Future<Function> addFriendToUserFriendList({@required FriendModel friendModel, @required String userId}) {

  }

  @override
  Future<Function> sendFriendRequestAcceptedNotification(
      {@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId}) {

  }

  @override
  Future<void> removeFriendRequestNotification(
      {@required String currentUserId, @required String profileUserId}) {

  }

  @override
  Future<bool> checkIfUserSentFriendRequestNotification(
      {@required String currentUserId, @required String profileUserId}) {

  }

  @override
  Future<int> getTotalAchievedPoints({@required String userId}) {

  }

  @override
  Future<File> getCachedNetworkFile({@required String urlPath}) {

  }


}