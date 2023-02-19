import 'package:iris_social_network/services/optimised_models/optimised_comment_model.dart';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';


abstract class CommentSpaceRepository{

  //Future<List<OptimisedCommentModel>> getCommentsData({@required String videoid, @required int queryLimit});

  Future<List<OptimisedCommentModel>> getCommentsData({@required String postId, @required String postUserId, @required int queryLimit, @required int endAtValue});

  Future<String> addCommentData({@required OptimisedCommentModel optimisedCommentModel, @required String postUserId, @required String postId});

  Future<String> getCommentUserId({@required String postUserId, @required String postId});

  Future<String> getCommentUserUserName({@required String commentUserId});

  Future<String> getCommentUserProfileName({@required String commentUserId});

  Future<String> getCommentUserProfileThumb({@required String commentUserId});

  Future<bool> getIsUserVerified({@required String commentUserId});

  Future<void> deletePostComment({@required String postUserId, @required String postId, @required String commentId});
}