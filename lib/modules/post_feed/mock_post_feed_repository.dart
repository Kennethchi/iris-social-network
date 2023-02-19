import 'dart:async';
import 'post_feed_repository.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/optimised_models/optimised_user_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;




class MockPostFeedRepository extends PostFeedRepository{


  @override
  Future<List<PostModel>> getPostsData(
      {@required postType = null, @required app_constants
          .POST_QUERY_TYPE postQueryType = app_constants.POST_QUERY_TYPE
          .MOST_RECENT, @required int queryLimit, @required Map<String,
          dynamic> startAfterMap}) {

  }

  @override
  Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId}) {

  }

  @override
  Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId}) {

  }

  @override
  Future<bool> getIsPostUserVerified({@required String postUserId}) {

  }

  @override
  Future<String> getPostUserProfileThumb({@required String postUserId}) {

  }

  @override
  Future<String> getPostUserProfileName({@required String postUserId}) {

  }

  @override
  Future<String> getPostUserUserName({@required String postUserId}) {

  }


}