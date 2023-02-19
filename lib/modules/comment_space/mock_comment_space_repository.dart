import 'comment_space_repository.dart';
import 'package:iris_social_network/services/optimised_models/optimised_comment_model.dart';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';



class MockCommentSpaceRepository extends CommentSpaceRepository{


  @override
  Future<List<OptimisedCommentModel>> getCommentsData(
      {@required String postId, @required String postUserId, @required int queryLimit, @required int endAtValue}) {

  }

  @override
  Future<String> getCommentUserProfileThumb({@required String commentUserId}) {

  }

  @override
  Future<String> getCommentUserProfileName({@required String commentUserId}) {

  }

  @override
  Future<String> getCommentUserId({@required String postUserId, @required String postId}) {

  }

  @override
  Future<String> addCommentData(
      {@required OptimisedCommentModel optimisedCommentModel, @required String postId, @required String postUserId,}) {

  }

  @override
  Future<String> getCommentUserUserName({@required String commentUserId}) {

  }

  @override
  Future<bool> getIsUserVerified({@required String commentUserId}) {

  }

  @override
  Future<Function> deletePostComment(
      {@required String postUserId, @required String postId, @required String commentId}) {

  }


}


