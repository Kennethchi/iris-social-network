import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';

import 'post_room_repository.dart';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'realtime_database_provider.dart';




class ProductionPostRoomRepository extends PostRoomRepository{


  @override
  Stream<Event> getIfUserLikedPostStream({@required String postId, @required String postUserId, @required String currentUserId}) {
    return RealtimeDatabaseProvider.getIfUserLikedPostStream(postId: postId, postUserId: postUserId, currentUserId: currentUserId);
  }

  @override
  Future<Function> addPostLike({@required String postId, @required String postUserId, @required String currentUserId})async {
    await RealtimeDatabaseProvider.addPostLike(postId: postId, postUserId: postUserId, currentUserId: currentUserId);
  }

  @override
  Future<Function> removePostLike({@required String postId, @required String postUserId, @required String currentUserId})async {
    await RealtimeDatabaseProvider.removePostLike(postId: postId, postUserId: postUserId, currentUserId: currentUserId);
  }

  @override
  Future<int> getNumberOfPostLikes({@required String postId, @required String postUserId})async {
    return await RealtimeDatabaseProvider.getNumberOfPostLikes(postId: postId, postUserId: postUserId);
  }

  @override
  Future<int> getNumberOfPostComments({@required String postId, @required String postUserId})async {
    return await RealtimeDatabaseProvider.getNumberOfPostComments(postId: postId, postUserId: postUserId);
  }

  @override
  Future<Function> addPostVideoView({@required String postId, @required String postUserId})async {
    await RealtimeDatabaseProvider.addPostVideoView(postId: postId, postUserId: postUserId);
  }

  @override
  Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId})async {
    return await RealtimeDatabaseProvider.getNumberOfPostVideoViews(postId: postId, postUserId: postUserId);
  }

  @override
  Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId})async {
    return await RealtimeDatabaseProvider.getNumberOfPostAudioListens(postId: postId, postUserId: postUserId);
  }

  @override
  Future<Function> addPostAudioListen({@required String postId, @required String postUserId})async {
    await RealtimeDatabaseProvider.addPostAudioListen(postId: postId, postUserId: postUserId);
  }

  @override
  Stream<Event> checkIfCurrentUserFollowsPostUserStreamEvent({@required String currentUserId, @required postUserId}) {
    return RealtimeDatabaseProvider.checkIfCurrentUserFollowsPostUserStreamEvent(currentUserId: currentUserId, postUserId: postUserId);
  }

  @override
  Future<Function> addCurrentUserFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId})async {
    await RealtimeDatabaseProvider.addCurrentUserFollowing(optimisedFFModel: optimisedFFModel, currentUserId: currentUserId);
  }

  @override
  Future<Function> addPostUserFollower({@required OptimisedFFModel optimisedFFModel, @required String postUserId})async {
    await RealtimeDatabaseProvider.addPostUserFollower(optimisedFFModel: optimisedFFModel, postUserId: postUserId);
  }

  @override
  Stream<Event> checkIfPostUserFollowsCurrentUserStreamEvent({@required String currentUserId, @required postUserId}) {
    return RealtimeDatabaseProvider.checkIfPostUserFollowsCurrentUserStreamEvent(currentUserId: currentUserId, postUserId: postUserId);
  }


}