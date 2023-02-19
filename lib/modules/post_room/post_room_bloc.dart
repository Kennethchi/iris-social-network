import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'post_room_repository.dart';
import 'post_room_dependency_injection.dart';




abstract class PostRoomBlocBlueprint{

  Stream<Event> getIfUserLikedPostStream({@required String postId, @required String postUserId, @required String currentUserId});

  Future<void> addPostLike({@required String postId, @required String postUserId, @required String currentUserId});

  Future<void> removePostLike({@required String postId, @required String postUserId, @required String currentUserId});

  Future<int> getNumberOfPostLikes({@required String postId, @required String postUserId});

  Future<int> getNumberOfPostComments({@required String postId, @required String postUserId});

  Future<void> addPostVideoView({@required String postId, @required String postUserId});

  Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId});

  Future<void> addPostAudioListen({@required String postId, @required String postUserId});

  Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId});

  Stream<Event> checkIfCurrentUserFollowsPostUserStreamEvent({@required String currentUserId, @required postUserId});

  Stream<Event> checkIfPostUserFollowsCurrentUserStreamEvent({@required String currentUserId, @required postUserId});

  Future<void> addPostUserFollower({@required OptimisedFFModel optimisedFFModel, @required String postUserId});

  Future<void> addCurrentUserFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId});

  void dispose();
}


class PostRoomBloc implements PostRoomBlocBlueprint{


  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }



  String _postUserId;
  String get getPostUserId => _postUserId;
  set setPostUserId(String postUserId) {
    _postUserId = postUserId;
  }


  String _postId;
  String get getPostId => _postId;
  set setPostId(String postId) {
    _postId = postId;
  }


  // stores if video is viewed
  // this is for the chewie controller listener since it listens so many times and ends up ading more than 1 view
  bool _isVideoViewed;
  bool get getIsVideoViewed => _isVideoViewed;
  set setIsVideoViewed(bool isVideoViewed) {
    _isVideoViewed = isVideoViewed;
  }

  // stores audio is listened
  bool _isAudioListened;
  bool get getIsAudioListened => _isAudioListened;
  set setIsAudioListened(bool isAudioListened) {
    _isAudioListened = isAudioListened;
  }



  int _numberOfLikes;
  int get getNumberOfLikes => _numberOfLikes;
  set setNumberOfLikes(int numberOfLikes) {
    _numberOfLikes = numberOfLikes;
  }


  // Streaming video playing state
  BehaviorSubject<bool> _isVideoPlayingBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsVideoPlayingStream => _isVideoPlayingBehaviorSubject.stream;
  Sink<bool> get _getIsVideoPlayingSink => _isVideoPlayingBehaviorSubject.sink;


  // Streaming video duration
  BehaviorSubject<int> _videoDurationInSecondsBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getVideoDurationInSecondsStream => _videoDurationInSecondsBehaviorSubject.stream;
  Sink<int> get _getVideoDurationInSecondsSink => _videoDurationInSecondsBehaviorSubject.sink;


  // Streaming is video video buffering
  BehaviorSubject<bool> _isVideoBufferingBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsVideoBufferingStream => _isVideoBufferingBehaviorSubject.stream;
  Sink<bool> get _getIsVideoBufferingSink => _isVideoBufferingBehaviorSubject.sink;


  // get number of post likes
  BehaviorSubject<int> _numberOfLikesBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getNumberOfLikesStream => _numberOfLikesBehaviorSubject.stream;
  StreamSink<int> get _getNumberOfLikesSink => _numberOfLikesBehaviorSubject.sink;

  // get number of post comments
  BehaviorSubject<int> _numberOfCommentsBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getNumberOfCommentsStream => _numberOfCommentsBehaviorSubject.stream;
  StreamSink<int> get _getNumberOfCommentsSink => _numberOfCommentsBehaviorSubject.sink;


  // get number of post video viewa
  BehaviorSubject<int> _numberOfVideoViewsBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getNumberOfVideoViewsStream => _numberOfVideoViewsBehaviorSubject.stream;
  StreamSink<int> get _getNumberOfVideoViewsSink => _numberOfVideoViewsBehaviorSubject.sink;


  // get number of post audio listens
  BehaviorSubject<int> _numberOfAudioListensBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getNumberOfAudioListensStream => _numberOfAudioListensBehaviorSubject.stream;
  StreamSink<int> get _getNumberOfAudioListensSink => _numberOfAudioListensBehaviorSubject.sink;



  // Streaming postType
  BehaviorSubject<PostModel> _postModelBehaviorSubject= BehaviorSubject<PostModel>();
  Stream<PostModel> get getPostModelStream => _postModelBehaviorSubject.stream;
  StreamSink<PostModel> get _getPostModelSink => _postModelBehaviorSubject.sink;

  // Stream is video initialised
  BehaviorSubject<bool> _isVideoInitialisedBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsVideoInitialisedStream => _isVideoInitialisedBehaviorSubject.stream;
  StreamSink<bool> get _getIsVideoInitialisedSink => _isVideoInitialisedBehaviorSubject.sink;


  // post background image streaming
  BehaviorSubject<String> _postBackgroundImageBehaviorSubject =  BehaviorSubject<String>();
  Stream<String> get getPostBackgroundImageStream => _postBackgroundImageBehaviorSubject.stream;
  StreamSink<String> get _getPostBackgroundImageSink => _postBackgroundImageBehaviorSubject.sink;



  // Streaming images index streaming
  BehaviorSubject<int> _imagesCurrentIndexBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getImagesCurrentIndexStream => _imagesCurrentIndexBehaviorSubject.stream;
  StreamSink<int> get _getImagesCurrentIndexSink => _imagesCurrentIndexBehaviorSubject.sink;


  PostRoomRepository _postRoomRepository;

  PostRoomBloc({@required PostModel postModel}){


    getFirebaseUser().then((FirebaseUser firebaseUser){
      if (firebaseUser != null){
        setCurrentUserId = firebaseUser.uid;
      }
    });


    _postRoomRepository = PostRoomDependencyInjector().getPostRoomRepository;


    if (postModel.postType == PostType.video){
      addPostBackgroundImageToStream(VideoModel.fromJson(postModel.postData).videoThumb);
    }
    else if (postModel.postType == PostType.image){
      addPostBackgroundImageToStream(ImageModel.fromJson(postModel.postData).imagesThumbsUrl[0]);
    }
    else if (postModel.postType == PostType.audio){
      addPostBackgroundImageToStream(AudioModel.fromJson(postModel.postData).audioThumb);
    }


    // Adds the postModel to stream for streaming
    addPostModelToStream(postModel);

    setPostUserId = postModel.userId;
    setPostId = postModel.postId;

    // video viewed is first set to false
    setIsVideoViewed = false;



    getNumberOfPostLikes(postId: getPostId, postUserId: postModel.userId).then((int numberOfLikes){
      addNumberOfLikesToStream(numberOfLikes);
      setNumberOfLikes = numberOfLikes;
    });
    getNumberOfPostComments(postId: postModel.postId, postUserId: postModel.userId).then((int numComments){
      addNumberOfCommentsToStream(numComments);
    });
    getNumberOfPostVideoViews(postId: postModel.postId, postUserId: postModel.userId).then((int numVideoViews){
      addNumberOfVideoViewsToStream(numVideoViews);
    });
    getNumberOfPostAudioListens(postId: postModel.postId, postUserId: postModel.userId).then((int numAudioListens){
      addNumberOfAudioListensToStream(numAudioListens);
    });

    getNumberOfLikesStream.listen((int d){});


    // initialises image post images current index for image index count widget
    addImagesCurrentIndexToStream(0);
  }



  Future<FirebaseUser> getFirebaseUser()async{
    return await FirebaseAuth.instance.currentUser();
  }



  void addImagesCurrentIndexToStream(int imagesCurrentIndex){
    _getImagesCurrentIndexSink.add(imagesCurrentIndex);
  }


  void addPostBackgroundImageToStream(String backgroundImage){
    _getPostBackgroundImageSink.add(backgroundImage);
  }

  void addIsVideoInitialisedToStream(bool isVideoInitialised){
    _getIsVideoInitialisedSink.add(isVideoInitialised);
  }

  void addPostModelToStream(PostModel postModel){
    _getPostModelSink.add(postModel);
  }


  void addNumberOfLikesToStream(int numberOfLikes){
    _getNumberOfLikesSink.add(numberOfLikes);
  }

  void addNumberOfCommentsToStream(int numberOfComments){
    _getNumberOfCommentsSink.add(numberOfComments);
  }

  void addNumberOfVideoViewsToStream(int numberOfVideoViews){
    _getNumberOfVideoViewsSink.add(numberOfVideoViews);
  }

  void addNumberOfAudioListensToStream(int numberOfAudioListens){
    _getNumberOfAudioListensSink.add(numberOfAudioListens);
  }

  // adds video is playing to stream
  void addIsVideoBufferingToStream(bool isVideoPlaying){
    _getIsVideoBufferingSink.add(isVideoPlaying);
  }

  // adds video is playing to stream
  void addIsVideoPlayingToStream(bool isVideoPlaying){
    _getIsVideoPlayingSink.add(isVideoPlaying);
  }

  void addVideoDurationInSecondsToStream(int videoDurationInSeconds){
    _getVideoDurationInSecondsSink.add(videoDurationInSeconds);
  }




  @override
  Stream<Event> getIfUserLikedPostStream(
      {@required String postId, @required String postUserId, @required String currentUserId}) {
    return _postRoomRepository.getIfUserLikedPostStream(postId: postId, postUserId: postUserId, currentUserId: currentUserId);
  }

  @override
  Future<Function> addPostLike(
      {@required String postId, @required String postUserId, @required String currentUserId})async {
    await _postRoomRepository.addPostLike(postId: postId, postUserId: postUserId, currentUserId: currentUserId);
  }

  @override
  Future<Function> removePostLike(
      {@required String postId, @required String postUserId, @required String currentUserId})async {
    await _postRoomRepository.removePostLike(postId: postId, postUserId: postUserId, currentUserId: currentUserId);
  }

  @override
  Future<int> getNumberOfPostLikes({@required String postId, @required String postUserId})async {
    return await _postRoomRepository.getNumberOfPostLikes(postId: postId, postUserId: postUserId);
  }

  @override
  Future<int> getNumberOfPostComments({@required String postId, @required String postUserId})async {
    return await _postRoomRepository.getNumberOfPostComments(postId: postId, postUserId: postUserId);
  }

  @override
  Future<Function> addPostVideoView({@required String postId, @required String postUserId})async {
    await _postRoomRepository.addPostVideoView(postId: postId, postUserId: postUserId);
  }

  @override
  Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId})async {
    return await _postRoomRepository.getNumberOfPostVideoViews(postId: postId, postUserId: postUserId);
  }


  @override
  Future<Function> addPostAudioListen({@required String postId, @required String postUserId})async {
    await _postRoomRepository.addPostAudioListen(postId: postId, postUserId: postUserId);
  }

  @override
  Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId})async {
    return await _postRoomRepository.getNumberOfPostAudioListens(postId: postId, postUserId: postUserId);
  }

  @override
  Stream<Event> checkIfCurrentUserFollowsPostUserStreamEvent({@required String currentUserId, @required postUserId}) {
    return _postRoomRepository.checkIfCurrentUserFollowsPostUserStreamEvent(currentUserId: currentUserId, postUserId: postUserId);
  }


  @override
  Stream<Event> checkIfPostUserFollowsCurrentUserStreamEvent({@required String currentUserId, @required postUserId}) {
    return _postRoomRepository.checkIfPostUserFollowsCurrentUserStreamEvent(currentUserId: currentUserId, postUserId: postUserId);
  }

  @override
  Future<Function> addPostUserFollower({@required OptimisedFFModel optimisedFFModel, @required String postUserId})async {
    await _postRoomRepository.addPostUserFollower(optimisedFFModel: optimisedFFModel, postUserId: postUserId);
  }

  @override
  Future<Function> addCurrentUserFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId})async {
    await _postRoomRepository.addCurrentUserFollowing(optimisedFFModel: optimisedFFModel, currentUserId: currentUserId);
  }


  @override
  void dispose() {

    _isVideoInitialisedBehaviorSubject?.close();
    _imagesCurrentIndexBehaviorSubject?.close();
    _postBackgroundImageBehaviorSubject?.close();

    _isVideoBufferingBehaviorSubject?.close();
    _numberOfAudioListensBehaviorSubject?.close();
    _numberOfCommentsBehaviorSubject?.close();
    _numberOfVideoViewsBehaviorSubject?.close();

    _isVideoPlayingBehaviorSubject?.close();
    _postBackgroundImageBehaviorSubject?.close();

    _videoDurationInSecondsBehaviorSubject?.close();
    _postModelBehaviorSubject?.close();
  }


}


