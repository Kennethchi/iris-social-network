import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';

import 'post_room_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';




class MockPostRoomRepository extends PostRoomRepository{


  @override
  Stream<Event> getIfUserLikedPostStream(
      {@required String postId, @required String postUserId, @required String currentUserId}) {

  }

  @override
  Future<int> getNumberOfPostAudioListens(
      {@required String postId, @required String postUserId}) {

  }

  @override
  Future<Function> addPostAudioListen(
      {@required String postId, @required String postUserId}) {

  }

  @override
  Future<int> getNumberOfPostVideoViews(
      {@required String postId, @required String postUserId}) {

  }

  @override
  Future<Function> addPostVideoView(
      {@required String postId, @required String postUserId}) {

  }

  @override
  Future<int> getNumberOfPostComments(
      {@required String postId, @required String postUserId}) {

  }

  @override
  Future<int> getNumberOfPostLikes(
      {@required String postId, @required String postUserId}) {

  }

  @override
  Future<Function> removePostLike(
      {@required String postId, @required String postUserId, @required String currentUserId}) {

  }

  @override
  Future<Function> addPostLike(
      {@required String postId, @required String postUserId, @required String currentUserId}) {

  }

  @override
  Stream<Event> checkIfCurrentUserFollowsPostUserStreamEvent({@required String currentUserId, @required postUserId}) {

  }

  @override
  Future<Function> addCurrentUserFollowing(
      {@required OptimisedFFModel optimisedFFModel, @required String currentUserId}) {

  }

  @override
  Future<Function> addPostUserFollower(
      {@required OptimisedFFModel optimisedFFModel, @required String postUserId}) {

  }

  @override
  Stream<Event> checkIfPostUserFollowsCurrentUserStreamEvent(
      {@required String currentUserId, @required postUserId}) {

  }


}