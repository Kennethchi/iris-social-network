import 'dart:async';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;



abstract class PostFeedRepository{

  Future<List<PostModel>> getPostsData({
    @required postType = null,
    @required app_constants.POST_QUERY_TYPE postQueryType = app_constants.POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  });


  Future<String> getPostUserUserName({@required String postUserId});

  Future<String> getPostUserProfileName({@required String postUserId});

  Future<String> getPostUserProfileThumb({@required String postUserId});

  Future<bool> getIsPostUserVerified({@required String postUserId});

  Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId});

  Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId});


}