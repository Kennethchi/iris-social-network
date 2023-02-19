import 'dart:async';
import 'friends_post_feed_repository.dart';
import 'package:meta/meta.dart';
import 'firestore_provider.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'realtime_database_provider.dart';



class ProductionFriendsPostFeedRepository extends FriendsPostFeedRepository{


  @override
  Future<List<PostModel>> getPostsData({
    @required postType = null,
    @required app_constants.POST_QUERY_TYPE postQueryType = app_constants.POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap,
    @required String currentUserId
  })
  async {

    return await FirestoreProvider.getPostsData(
        postType: postType, postQueryType: postQueryType, queryLimit: queryLimit, startAfterMap: startAfterMap, currentUserId: currentUserId
    );
  }

  @override
  Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId}) async{
    return await RealtimeDatabaseProvider.getNumberOfPostAudioListens(postId: postId, postUserId: postUserId);
  }

  @override
  Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId})async {
    return await RealtimeDatabaseProvider.getNumberOfPostVideoViews(postId: postId, postUserId: postUserId);
  }

  @override
  Future<bool> getIsPostUserVerified({@required String postUserId})async {
    return await RealtimeDatabaseProvider.getIsPostUserVerified(postUserId: postUserId);
  }

  @override
  Future<String> getPostUserProfileThumb({@required String postUserId})async {
    return await RealtimeDatabaseProvider.getPostUserProfileThumb(postUserId: postUserId);
  }

  @override
  Future<String> getPostUserProfileName({@required String postUserId})async {
    return await RealtimeDatabaseProvider.getPostUserProfileName(postUserId: postUserId);
  }

  @override
  Future<String> getPostUserUserName({@required String postUserId})async {

    return await RealtimeDatabaseProvider.getPostUserUserName(postUserId: postUserId);
  }


}


