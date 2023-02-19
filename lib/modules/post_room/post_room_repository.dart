import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';



abstract class PostRoomRepository{


  Stream<Event> getIfUserLikedPostStream({@required String postId, @required String postUserId, @required String currentUserId});

  Future<void> addPostLike({@required String postId, @required String postUserId, @required String currentUserId});

  Future<void> removePostLike({@required String postId, @required String postUserId, @required String currentUserId});

  Future<int> getNumberOfPostLikes({@required String postId, @required String postUserId});

  Future<int> getNumberOfPostComments({@required String postId, @required String postUserId});

  Future<void> addPostVideoView({@required String postId, @required String postUserId});

  Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId});

  Future<void> addPostAudioListen({@required String postId, @required String postUserId});

  Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId});

  Stream<Event> checkIfCurrentUserFollowsPostUserStreamEvent({@required String currentUserId, @required postUserId});

  Stream<Event> checkIfPostUserFollowsCurrentUserStreamEvent({@required String currentUserId, @required postUserId});

  Future<void> addPostUserFollower({@required OptimisedFFModel optimisedFFModel, @required String postUserId});

  Future<void> addCurrentUserFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId});
}