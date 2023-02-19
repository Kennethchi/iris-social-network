import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/services/models/post_model.dart';

import 'comment_space_dependency_injection.dart';
import 'comment_space_repository.dart';
import 'package:iris_social_network/services/optimised_models/optimised_comment_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'comment_space_validators.dart';
import 'package:rxdart/rxdart.dart';






abstract class CommentSpaceBlocBlueprint{

  //Future<List<OptimisedCommentModel>> getCommentsData({@required String videoid, @required int queryLimit});

  Future<List<OptimisedCommentModel>> getCommentsData({@required String postId, @required String postUserId, @required int queryLimit, @required int endAtValue});

  Future<String> addCommentData({@required OptimisedCommentModel optimisedCommentModel, @required String postUserId, @required String postId});

  Future<String> getCommentUserId({@required String postId, @required String postUserId,});

  Future<String> getCommentUserProfileName({@required String commentUserId});

  Future<String> getCommentUserProfileThumb({@required String commentUserId});

  Future<String> getCommentUserUserName({@required String commentUserId});

  Future<bool> getIsUserVerified({@required String commentUserId});

  Future<void> deletePostComment({@required String postUserId, @required String postId, @required String commentId});

  void dispose();
}



class CommentSpaceBloc with CommentSpaceValidators  implements CommentSpaceBlocBlueprint{



  PostModel _postModel;
  PostModel get getPostModel => _postModel;
  set setPostModel(PostModel postModel) {
    _postModel = postModel;
  }




  int _commentsQueryLimit;
  int get getCommentsQueryLimit => _commentsQueryLimit;
  set setCommentsQueryLimit(int commentsQueryLimit) {
    _commentsQueryLimit = commentsQueryLimit;
  }



  int _queryEndAtValue;
  int get getQueryEndAtValue => _queryEndAtValue;
  set setQueryEndAtValue(int queryEndAtValue) {
    _queryEndAtValue = queryEndAtValue;
  }


  // List of videos
  List<OptimisedCommentModel> _CommentsList;
  List<OptimisedCommentModel> get getCommentsList => _CommentsList;
  set setCommentsList(List<OptimisedCommentModel> commentsList) {
    _CommentsList = commentsList;
  }
  

  bool _hasMoreComments;
  bool get getHasMoreComments => _hasMoreComments;
  set setHasMoreComments(bool hasMoreComments) {
    _hasMoreComments = hasMoreComments;
  }



  // has loaded comments to avoid repetition of comments
  // bloc provider implements this
  bool _hasLoadedComments;
  bool get getHasLoadedComments => _hasLoadedComments;
  set setHasLoadedComments(bool hasLoadedComments) {
    _hasLoadedComments = hasLoadedComments;
  }


  // comment Text Stream Controller
  BehaviorSubject<String> _textBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getTextStream => _textBehaviorSubject.stream.transform(textValidator);
  StreamSink<String> get _getTextSink => _textBehaviorSubject.sink;




  BehaviorSubject<List<OptimisedCommentModel>> _commentsListBehaviorSubject = BehaviorSubject<List<OptimisedCommentModel>>();
  Stream<List<OptimisedCommentModel>> get getCommentListStream => _commentsListBehaviorSubject.stream;
  StreamSink<List<OptimisedCommentModel>> get _getCommentListSink => _commentsListBehaviorSubject.sink;



  BehaviorSubject<bool> _hasMoreCommentsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMoreCommentsStream => _hasMoreCommentsBehaviorSubject.stream;
  StreamSink<bool> get _getHasMoreCommentsSink => _hasMoreCommentsBehaviorSubject.sink;



  // comment Text Stream Controller
  BehaviorSubject<String> _currentUserIdBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getCurrentUserIdStream => _currentUserIdBehaviorSubject.stream;
  StreamSink<String> get _getCurrentUserIdSink => _currentUserIdBehaviorSubject.sink;


  // Variable to hold repository
  CommentSpaceRepository _commentSpaceRepository;


  CommentSpaceBloc({@required PostModel postModel}){

    // sets post model
    setPostModel = postModel;

    // sets limit for comments query
    setCommentsQueryLimit = DatabaseQueryLimits.COMMENTS_QUERY_LIMIT;


    // assigning comment space repository through dependency injection
    _commentSpaceRepository = CommentSpaceDependencyInjector().getCommentSpaceRepository;


    setCommentsList = List<OptimisedCommentModel>();
    setHasMoreComments = true;
    setHasLoadedComments = false;
    
    // LoadComments
    loadComments(
        commentsPostId: postModel.postId,
        postUserId: postModel.userId,
        queryLimit: DatabaseQueryLimits.COMMENTS_QUERY_LIMIT,
      endAtValue: null
    );

  }





  Future<List<OptimisedCommentModel>> setUpCommentsData({@required List<OptimisedCommentModel> commentsList})async{

    List<OptimisedCommentModel> processedList = List<OptimisedCommentModel>();

    for (int index = 0; index < commentsList.length; ++index){

      String userId = commentsList[index].user_id;

      //commentsList[index].name = await this.getCommentUserProfileName(commentUserId: userId);
      commentsList[index].thumb = await this.getCommentUserProfileThumb(commentUserId: userId);
      commentsList[index].username = await this.getCommentUserUserName(commentUserId: userId);
      commentsList[index].v_user = await this.getIsUserVerified(commentUserId: userId);

      processedList.add(commentsList[index]);
    }

    return processedList;
  }



  void loadComments({@required String commentsPostId, @required String postUserId, @required int queryLimit, int endAtValue}){

    this.setCommentsList = List<OptimisedCommentModel>();
    setHasMoreComments = true;
    setHasLoadedComments = false;


    getCommentsData(postId: commentsPostId, postUserId: postUserId, queryLimit: queryLimit, endAtValue: endAtValue).then((commentsList){

      this.getCommentsList.clear();

      if (commentsList.length < getCommentsQueryLimit){

        setHasMoreComments = false;
        addHasMoreCommentsToStream(false);
      }
      else{
        setQueryEndAtValue = commentsList.removeLast().t;
      }


      setUpCommentsData(commentsList: commentsList).then((List<OptimisedCommentModel> processedCommentsList){

        getCommentsList.addAll(processedCommentsList);

        addCommentListToStream(this.getCommentsList);
      });


    });
  }



  Future<void> loadMoreComments({String commentsPostId, @required String postUserId, @required int queryLimit, int endAtValue})async{


    if (getHasMoreComments){

      List<OptimisedCommentModel> commentsList = await getCommentsData(postId: commentsPostId, postUserId: postUserId, queryLimit: queryLimit, endAtValue: endAtValue);

      if (commentsList.length < getCommentsQueryLimit){

        setHasMoreComments = false;
        addHasMoreCommentsToStream(false);
      }
      else{

        setQueryEndAtValue = commentsList.removeLast().t;
      }

      setUpCommentsData(commentsList: commentsList).then((List<OptimisedCommentModel> processedCommentsList){

        this.getCommentsList.addAll(processedCommentsList);

        addCommentListToStream(getCommentsList);
      });

    }
    else{
      addHasMoreCommentsToStream(false);
      setHasMoreComments = false;

    }

  }


  Future<String> getCurrentUserId()async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    return firebaseUser.uid;
  }




  void addHasMoreCommentsToStream(bool hasMoreVideos){
    _getHasMoreCommentsSink.add(hasMoreVideos);
  }

  void addCommentListToStream(List<OptimisedCommentModel> optimisedVideoPreviewList){
    _getCommentListSink.add(optimisedVideoPreviewList);
  }
  
  
  



  void addTextToStream({@required String text}) {
    _getTextSink.add(text);
  }


  @override
  Future<List<OptimisedCommentModel>> getCommentsData({@required String postId, @required String postUserId, @required int queryLimit, @required int endAtValue})async {

    return await _commentSpaceRepository.getCommentsData(postId: postId, postUserId: postUserId, queryLimit: queryLimit, endAtValue: endAtValue);
  } // gets comments from database



  // adds comment data to database
  @override
  Future<String> addCommentData({@required OptimisedCommentModel optimisedCommentModel, @required String postId, @required String postUserId})async {
    return await _commentSpaceRepository.addCommentData(optimisedCommentModel: optimisedCommentModel, postId: postId, postUserId: postUserId);
  }


  @override
  Future<String> getCommentUserId({@required String postId, @required String postUserId,})async {
    return await _commentSpaceRepository.getCommentUserId(postId: postId, postUserId: postUserId);
  }


  @override
  Future<String> getCommentUserProfileName({@required String commentUserId})async {
    return await _commentSpaceRepository.getCommentUserProfileName(commentUserId: commentUserId);
  }


  @override
  Future<String> getCommentUserProfileThumb({@required String commentUserId})async {
    return await _commentSpaceRepository.getCommentUserProfileThumb(commentUserId: commentUserId);
  }


  @override
  Future<String> getCommentUserUserName({@required String commentUserId})async {
    return await _commentSpaceRepository.getCommentUserUserName(commentUserId: commentUserId);
  }


  @override
  Future<bool> getIsUserVerified({@required String commentUserId})async {
    return await _commentSpaceRepository.getIsUserVerified(commentUserId: commentUserId);
  }


  @override
  Future<Function> deletePostComment({@required String postUserId, @required String postId, @required String commentId})async {
    await _commentSpaceRepository.deletePostComment(postUserId: postUserId,postId: postId, commentId: commentId);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _commentsListBehaviorSubject?.close();
    _hasMoreCommentsBehaviorSubject?.close();
    _textBehaviorSubject?.close();
  }



}