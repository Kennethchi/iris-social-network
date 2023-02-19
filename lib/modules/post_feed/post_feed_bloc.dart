import 'dart:async';
import 'package:meta/meta.dart';
import 'post_feed_dependency_injection.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'post_feed_repository.dart';
import 'package:rxdart/rxdart.dart';


abstract class PostFeedBlocBlueprint{

  Future<List<PostModel>> getPostsData({
    @required postType = null,
    @required app_constants.POST_QUERY_TYPE postQueryType = app_constants.POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap});


  Future<String> getPostUserUserName({@required String postUserId});

  Future<String> getPostUserProfileName({@required String postUserId});

  Future<String> getPostUserProfileThumb({@required String postUserId});

  Future<bool> getIsPostUserVerified({@required String postUserId});

  Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId});

  Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId});

  void dispose();
}


class PostFeedBloc implements PostFeedBlocBlueprint{



  // post query limits
  int _postsQueryLimit;
  int get getPostsQueryLimit => _postsQueryLimit;
  set setPostsQueryLimit(int postsQueryLimit) {
    _postsQueryLimit = postsQueryLimit;
  }


  // startMap for checkpoint for get posts
  Map<String, dynamic> _queryStartAfterMap;
  Map<String, dynamic> get getQueryStartAfterMap => _queryStartAfterMap;
  set setQueryStartAfterMap(Map<String, dynamic> queryStartAfterMap) {
    _queryStartAfterMap = queryStartAfterMap;
  }


  // List of posts
  List<PostModel> _postsList;
  List<PostModel> get getPostsList => _postsList;
  set setPostsList(List<PostModel> postsList) {
    _postsList = postsList;
  }

  // has more posts to loaded
  bool _hasMorePosts;
  bool get getHasMorePosts => _hasMorePosts;
  set setHasMorePosts(bool hasMorePosts) {
    _hasMorePosts = hasMorePosts;
  }


  // has loaded posts to avoid repetition of posts
  // bloc provider implements this
  bool _hasLoadedPosts;
  bool get getHasLoadedPosts => _hasLoadedPosts;
  set setHasLoadedPosts(bool hasLoadedPosts) {
    _hasLoadedPosts = hasLoadedPosts;
  }


  // stores post typee e.g image, video, audio etc
  String _postType;
  String get getPostType => _postType;
  set setPostType(String postType) {
    _postType = postType;
  }


  // Stream post type
  BehaviorSubject<String> _postTypeBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getPostTypeStream => _postTypeBehaviorSubject.stream;
  StreamSink<String> get _getPostTypeSink => _postTypeBehaviorSubject.sink;
  StreamSubscription<String> getPostTypeStreamSubscription;

  // stream postList
  BehaviorSubject<List<PostModel>> _postsListBehaviorSubject = BehaviorSubject<List<PostModel>>();
  Stream<List<PostModel>> get getPostsListStream => _postsListBehaviorSubject.stream;
  StreamSink<List<PostModel>> get _getPostsListSink => _postsListBehaviorSubject.sink;

  // stream has more posts
  BehaviorSubject<bool> _hasMorePostsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMorePostsStream => _hasMorePostsBehaviorSubject.stream;
  StreamSink<bool> get _getHasMorePostsSink => _hasMorePostsBehaviorSubject.sink;





  // Variable to hold post feed repository
  PostFeedRepository _postFeedRepository;


  PostFeedBloc(){

    // initialises post feed repository using dependency injection
    _postFeedRepository = PostFeedDependencyInjector().getPostFeedRepository;


    this.setPostsList = List<PostModel>();
    // sets posts query limit
    setPostsQueryLimit = app_constants.DatabaseQueryLimits.POSTS_QUERY_LIMIT;
    // for loading all posts
    setPostType = null;


    loadPosts(postType: getPostType, postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT, postQueryLimit: this.getPostsQueryLimit);

    // listens for video talent that has been clicked
    getPostTypeStreamSubscription = getPostTypeStream.listen((String postType){

      setPostType = postType;
    });
  }




  Future<List<PostModel>> setPostsData({@required List<PostModel> postsList})async{

    List<PostModel> processedList = List<PostModel>();

    for (int index = 0; index < postsList.length; ++index){

      String userId = postsList[index].userId;
      //String postId = postsList[index].postId;

      postsList[index].userName = await this.getPostUserUserName(postUserId: userId);
      postsList[index].userProfileName = await this.getPostUserProfileName(postUserId: userId);
      postsList[index].verifiedUser = await this.getIsPostUserVerified(postUserId: userId);
      postsList[index].userThumb = await this.getPostUserProfileThumb(postUserId: userId);

      processedList.add(postsList[index]);
    }

    return processedList;
  }






  Future<void> loadPosts({@required String postType = null,  @required app_constants.POST_QUERY_TYPE postQueryType, @required int postQueryLimit, })async{

    this.setPostsList = List<PostModel>();
    this.setHasMorePosts = false;
    this.setHasLoadedPosts = false;

    addHasMorePostsToStream(true);

    addPostTypeToStream(postType);

    getPostsData(postType: postType, postQueryType: postQueryType, queryLimit: postQueryLimit, startAfterMap: null).then((postsList)async{

      this.getPostsList.clear();

      if (postsList.length < postQueryLimit){


        List<PostModel> postsListRefined = await setPostsData(postsList: postsList);
        getPostsList.addAll(postsListRefined);

        addPostsListToStream(this.getPostsList);

        addHasMorePostsToStream(false);
        this.setHasMorePosts = false;
        return;
      }
      else{

        setQueryStartAfterMap = postsList.last.toJson();


        List<PostModel> postsListRefined = await setPostsData(postsList: postsList);
        getPostsList.addAll(postsListRefined);

        addPostsListToStream(this.getPostsList);

        addHasMorePostsToStream(true);
        this.setHasMorePosts = true;
      }

    });
  }




  Future<void> loadMorePosts({@required String postType = null,  @required app_constants.POST_QUERY_TYPE postQueryType, @required int postQueryLimit})async{

    addHasMorePostsToStream(true);

    if (getHasMorePosts){

      List<PostModel> postsList = await getPostsData(postType: postType, postQueryType: postQueryType, queryLimit: postQueryLimit, startAfterMap: this.getQueryStartAfterMap);


      if (postsList.length < postQueryLimit){


        List<PostModel> postsListRefined = await setPostsData(postsList: postsList);
        getPostsList.addAll(postsListRefined);

        addPostsListToStream(this.getPostsList);

        setHasMorePosts = false;
        addHasMorePostsToStream(false);
      }
      else{

        setQueryStartAfterMap = postsList.last.toJson();

        List<PostModel> postsListRefined = await setPostsData(postsList: postsList);
        getPostsList.addAll(postsListRefined);

        addPostsListToStream(this.getPostsList);

        setHasMorePosts = true;
        addHasMorePostsToStream(true);
      }


    }
    else{
      addHasMorePostsToStream(false);
      setHasMorePosts = false;
    }

  }






  void addHasMorePostsToStream(bool hasMorePosts){

    _getHasMorePostsSink.add(hasMorePosts);
  }

  void addPostsListToStream(List<PostModel> postsList){
    _getPostsListSink.add(postsList);
  }

  void addPostTypeToStream(String postType){

    this.setPostType = postType;
    _getPostTypeSink.add(postType);
  }


  Future<List<PostModel>> getPostsData({
    @required postType = null,
    @required app_constants.POST_QUERY_TYPE postQueryType = app_constants.POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap})
  async{

    return _postFeedRepository.getPostsData(postType: postType, postQueryType: postQueryType, queryLimit: queryLimit, startAfterMap: startAfterMap);
  }


  @override
  Future<String> getPostUserUserName({@required String postUserId})async {
    return await _postFeedRepository.getPostUserUserName(postUserId: postUserId);
  }


  @override
  Future<String> getPostUserProfileName({@required String postUserId})async {
    return await _postFeedRepository.getPostUserProfileName(postUserId: postUserId);
  }

  @override
  Future<bool> getIsPostUserVerified({@required String postUserId})async {
    return await _postFeedRepository.getIsPostUserVerified(postUserId: postUserId);
  }

  @override
  Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId})async {
    return await _postFeedRepository.getNumberOfPostVideoViews(postId: postId, postUserId: postUserId);
  }

  @override
  Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId})async {
    return await _postFeedRepository.getNumberOfPostAudioListens(postId: postId, postUserId: postUserId);
  }

  @override
  Future<String> getPostUserProfileThumb({@required String postUserId})async {
    return await _postFeedRepository.getPostUserProfileThumb(postUserId: postUserId);
  }


  // dispose all resources
  @override
  void dispose() {

    _postsListBehaviorSubject?.close();
    _hasMorePostsBehaviorSubject?.close();
    _postTypeBehaviorSubject?.close();


  }


}


