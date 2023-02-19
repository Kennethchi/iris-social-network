import 'comment_space_repository.dart';
import 'package:iris_social_network/services/optimised_models/optimised_comment_model.dart';
import 'realtime_database_provider.dart';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';



class ProductionCommentSpaceRepository extends CommentSpaceRepository{





  @override
  Future<String> addCommentData({@required OptimisedCommentModel optimisedCommentModel,@required String postUserId, @required String postId})async {

    return await RealtimeDatabaseProvider.addCommentData(optimisedCommentModel: optimisedCommentModel, postUserId: postUserId, postId: postId);
  }

  @override
  Future<List<OptimisedCommentModel>> getCommentsData({@required String postId, @required String postUserId, @required int queryLimit, @required int endAtValue})async {

    return await RealtimeDatabaseProvider.getCommentsData(postId: postId, postUserId: postUserId, queryLimit: queryLimit, endAtValue: endAtValue);
  }

  @override
  Future<String> getCommentUserProfileName({@required String commentUserId})async {

    return await RealtimeDatabaseProvider.getCommentUserProfileName(commentUserId: commentUserId);
  }

  @override
  Future<String> getCommentUserId({@required String postId, @required String postUserId,})async {

    return await RealtimeDatabaseProvider.getCommentUserId(postId: postId, postUserId: postUserId);
  }

  @override
  Future<String> getCommentUserProfileThumb({@required String commentUserId})async {
    return await RealtimeDatabaseProvider.getCommentUserProfileThumb(commentUserId: commentUserId);
  }

  @override
  Future<String> getCommentUserUserName({@required String commentUserId})async {
    return await RealtimeDatabaseProvider.getCommentUserUserName(commentUserId: commentUserId);
  }

  @override
  Future<bool> getIsUserVerified({@required String commentUserId})async {
    return await RealtimeDatabaseProvider.getIsUserVerified(commentUserId: commentUserId);
  }

  @override
  Future<Function> deletePostComment(
      {@required String postUserId, @required String postId, @required String commentId})async {
    await RealtimeDatabaseProvider.deletePostComment(postUserId: postUserId, postId: postId, commentId: commentId);
  }


}