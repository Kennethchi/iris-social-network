import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';

import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/post_model.dart';



abstract class ProfileRepository{

  Future<UserModel> getProfileUserData({@required String profileUserId});


  Stream<Event> checkCurrentUserIsAFollowerStreamEvent({@required String currentUserId, @required profileUserId});

  Stream<Event> checkProfileUserIsCurrentUserFollowerStreamEvent({@required String currentUserId, @required profileUserId});


  Future<void> addProfileUserFollower({@required OptimisedFFModel optimisedFFModel, @required String profileUserId});

  Future<void> addCurrentUserFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId});


  Future<void> removeProfileUserFollower({@required String currentUserId, @required String profileUserId});

  Future<void> removeCurrentUserFollowing({@required String profileUserId, @required String currentUserId});

  Future<FirebaseUser> getFirebaseUser();

  Future<int> getNumberFollowers({@required String profileUserId});

  Future<int> getNumberFollowings({@required String profileUserId});

  Stream<Event> getNumberOfPostsStreamEvent({@required String profileUserId});

  Future<int> getNumberOfPosts({@required String profileUserId});

  Future<String> uploadFile({@required storagePath, @required File file});


  Future<bool> removeFile({@required String urlPath});


  Future<List<PostModel>> getProfileUserPostsData({
    @required String profileUserId,
    @required postType = null,
    @required String postAudience,
    @required POST_QUERY_TYPE postQueryType = POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  });

  Future<void> removePostData({@required String postId, @required String currentUserId});

  Future<bool> deleteFile({@required String urlPath});

  Future<void> removePostComments({@required String postId, @required String postUserId});

  Future<void> removePostLikes({@required String postId, @required String postUserId});

  Future<void> removeOptimisedPostData({@required String postId, @required String currentUserId});


  Stream<Event> checkCurrentUserSentFriendRequestToProfileUserStreamEvent({@required String currentUserId, @required profileUserId});

  Stream<Event> checkProfileUserSentFriendRequestToCurrentUserStreamEvent({@required String currentUserId, @required profileUserId});

  Future<void> sendFriendRequest({@required String currentUserId, @required String profileUserId});

  Future<void> removeFriendRequest({@required String currentUserId, @required String profileUserId});

  Future<void> sendFriendRequestNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId});

  Future<void> addFriendToUserFriendList({@required FriendModel friendModel, @required String userId});

  Future<void> sendFriendRequestAcceptedNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId});


  Future<bool> checkIfUserSentFriendRequestNotification({@required String currentUserId, @required String profileUserId});

  Future<void> removeFriendRequestNotification({@required String currentUserId, @required String profileUserId});

  Future<int> getTotalAchievedPoints({@required String userId});

  Future<File> getCachedNetworkFile({@required String urlPath});
}