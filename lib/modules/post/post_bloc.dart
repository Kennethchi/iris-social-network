import 'dart:async';
import 'package:meta/meta.dart';
import 'post_repository.dart';
import 'post_dependency_injection.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_post_model.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'media_provider.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'media_provider.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';




abstract class PostBlocBlueprint{

  Future<String> addPostData({@required PostModel postModel, @required String currentUserId});

  Future<void> addOptimisedPostData({@required OptimisedPostModel optimisedPostModel, @required String currentUserId, @required String postId});

  Future<File> getVideoThumbNailFile({@required File videoFile});

  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink});

  Future<MediaInfo> getMediaInfo({@required String mediaPath});

  Future<File> compressVideo({@required String videoPath});

  void dispose();
}


class PostBloc implements PostBlocBlueprint{


  // progress byte
  BehaviorSubject<int> _progressTransferDataBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getProgressTransferDataStream => _progressTransferDataBehaviorSubject.stream;
  StreamSink<int> get getProgressTransferDataSink => _progressTransferDataBehaviorSubject.sink;

  void addProgressTransferDataToStream(int progressTransferData){
    getProgressTransferDataSink.add(progressTransferData);
  }

  // total byte
  BehaviorSubject<int> _totalTransferDataBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getTotalTransferDataStream => _totalTransferDataBehaviorSubject.stream;
  StreamSink<int> get getTotalTransferDataSink => _totalTransferDataBehaviorSubject.sink;

  void addTotalTransferDataToStream(int totalTransferData){
    getTotalTransferDataSink.add(totalTransferData);
  }

  // percent ratio progress stream
  BehaviorSubject<double> _percentRatioProgressBehaviorSubject = BehaviorSubject<double>();
  Stream<double> get getPercentRatioProgressStream => _percentRatioProgressBehaviorSubject.stream;
  Sink<double> get _getPercentRatioProgressSink => _percentRatioProgressBehaviorSubject.sink;

  void addPercentRatioProgress(double percentRatioProgress){
    _getPercentRatioProgressSink.add(percentRatioProgress);
  }

  // Stream subscription for observing latest combination of ongoing progress transfer and total transfer
  StreamSubscription<double> _observeCombineLatestProgressAndTotalTransfer;




  // post background image streaming
  BehaviorSubject<String> _postBackgroundImageBehaviorSubject =  BehaviorSubject<String>();
  Stream<String> get getPostBackgroundImageStream => _postBackgroundImageBehaviorSubject.stream;
  StreamSink<String> get _getPostBackgroundImageSink => _postBackgroundImageBehaviorSubject.sink;

  void addPostBackgroundImageToStream(String backgroundImage){
    _getPostBackgroundImageSink.add(backgroundImage);
  }




  // images for image post
  List<String> _postImagesPaths;
  List<String> get getPostImagesPaths => _postImagesPaths;
  set setPostImagesPaths(List<String> postImagesPaths) {
    _postImagesPaths = postImagesPaths;
  }

  // video path for video post
  String _videoPath;
  String get getVideoPath => _videoPath;
  set setVideoPath(String videoPath) {
    _videoPath = videoPath;
  }

  // video thumb for video post
  String _videoThumbPath;
  String get getVideoThumbPath => _videoThumbPath;
  set setVideoThumbPath(String videoThumbPath) {
    _videoThumbPath = videoThumbPath;
  }

  // get Auddio path for audio post
  String _audioPath;
  String get getAudioPath => _audioPath;
  set setAudioPath(String audioPath) {
    _audioPath = audioPath;
  }

  //
  String _audioImage;
  String get getAudioImage => _audioImage;
  set setAudioImage(String audioImage) {
    _audioImage = audioImage;
  }

  String _postAudience;
  String get getPostAudience => _postAudience;
  set setPostAudience(String postAudience) {
    _postAudience = postAudience;
  }

  int _audioDuration;
  int get getAudioDuration => _audioDuration;
  set setAudioDuration(int audioDuration) {
    _audioDuration = audioDuration;
  }

  // Streaming video path
  BehaviorSubject<String> _videoPathBehaviorSubject= BehaviorSubject<String>();
  Stream<String> get getVideoPathStream => _videoPathBehaviorSubject.stream;
  StreamSink<String> get _getVideoPathSink => _videoPathBehaviorSubject.sink;


  // Streaming video thumbnail path
  BehaviorSubject<String> _videoThumbNailPathBehaviorSubject= BehaviorSubject<String>();
  Stream<String> get getVideoThumbNailPathStream => _videoThumbNailPathBehaviorSubject.stream;
  StreamSink<String> get _getVideoThumbNailPathSink => _videoThumbNailPathBehaviorSubject.sink;


  // Streaming post images list paths
  BehaviorSubject<List<String>> _imagesPathBehaviorSubject= BehaviorSubject<List<String>>();
  Stream<List<String>> get getImagesPathStream => _imagesPathBehaviorSubject.stream;
  StreamSink<List<String>> get _getImagesPathSink => _imagesPathBehaviorSubject.sink;


  // Streaming audio Path
  BehaviorSubject<String> _audioPathBehaviorSubject= BehaviorSubject<String>();
  Stream<String> get getAudioPathStream => _audioPathBehaviorSubject.stream;
  StreamSink<String> get _getAudioPathSink => _audioPathBehaviorSubject.sink;

  // Streaming audio image Path
  BehaviorSubject<String> _audioImagePathBehaviorSubject= BehaviorSubject<String>();
  Stream<String> get getAudioImagePathStream => _audioImagePathBehaviorSubject.stream;
  StreamSink<String> get _getAudioImagePathSink => _audioImagePathBehaviorSubject.sink;


  BehaviorSubject<String> _postTypeBehaviorSubject= BehaviorSubject<String>();
  Stream<String> get getPostTypeStream => _postTypeBehaviorSubject.stream;
  StreamSink<String> get _getPostTypeSink => _postTypeBehaviorSubject.sink;


  BehaviorSubject<bool> _isVideoInitialisedBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsVideoInitialisedStream => _isVideoInitialisedBehaviorSubject.stream;
  StreamSink<bool> get _getIsVideoInitialisedSink => _isVideoInitialisedBehaviorSubject.sink;


  BehaviorSubject<bool> _isPostImagesLimitReachedBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsPostImagesLimitReachedStream => _isPostImagesLimitReachedBehaviorSubject.stream;
  StreamSink<bool> get _getIsPostImagesLimitReachedSink => _isPostImagesLimitReachedBehaviorSubject.sink;


  BehaviorSubject<String> _postAudienceBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getPostAudienceStream => _postAudienceBehaviorSubject.stream;
  StreamSink<String> get _getPostAudienceSink => _postAudienceBehaviorSubject.sink;

  BehaviorSubject<bool> _isPostMediaDownloadableBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsPostMediaDownloadableStream => _isPostMediaDownloadableBehaviorSubject.stream;
  StreamSink<bool> get _getIsPostMediaDownloadableSink => _isPostMediaDownloadableBehaviorSubject.sink;


  BehaviorSubject<bool> _isPostSharableBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsPostSharableStream => _isPostSharableBehaviorSubject.stream;
  StreamSink<bool> get _getIsPostSharableSink => _isPostSharableBehaviorSubject.sink;




  Observable<bool> get getIsPostImageSetupCompleteObservable => Observable.combineLatest4(
          getImagesPathStream,
          getPostAudienceStream,
          getIsPostMediaDownloadableStream,
          getIsPostSharableStream,
          (List<String> imagesPath, String postAudience, bool isPostMediaDownloadable, bool isPostSharable, ){

            if ((imagesPath == null || imagesPath?.length == 0) || postAudience == null || isPostMediaDownloadable == null || isPostSharable == null){
              return false;
            }

            this.setPostAudience = postAudience;

            return true;
  });


  Observable<bool> get getIsPostVideoSetupCompleteObservable => Observable.combineLatest5(
      getVideoPathStream,
      getVideoThumbNailPathStream,
      getPostAudienceStream,
      getIsPostMediaDownloadableStream,
      getIsPostSharableStream,
          (String videoPath, String videoThumbNailPath, String postAudience, bool isPostMediaDownloadable, bool isPostSharable, ){

        if (videoPath == null || videoThumbNailPath == null || postAudience == null || isPostMediaDownloadable == null || isPostSharable == null){
          return false;
        }

        this.setVideoPath = videoPath;
        this.setVideoThumbPath = videoThumbNailPath;
        this.setPostAudience = postAudience;

        return true;
      });


  Observable<bool> get getIsPostAudioSetupCompleteObservable => Observable.combineLatest4(
      getAudioPathStream,
      getPostAudienceStream,
      getIsPostMediaDownloadableStream,
      getIsPostSharableStream,
          (String audioPath, String postAudience, bool isPostMediaDownloadable, bool isPostSharable, ){

        if (audioPath == null || postAudience == null || isPostMediaDownloadable == null || isPostSharable == null){
          return false;
        }


        this.setAudioPath = audioPath;
        this.setPostAudience = postAudience;

        return true;
      });



  // declare repository
  PostRepository _postRepository;

  PostBloc({@required File postFile}){

    // initialise repository using dependency injection
    _postRepository = PostDependencyInjector().getPostRepository;


    setPostImagesPaths = List<String>();


    // initialise post settings
    addIsPostMediaDownloadable(false);
    addIsPostSharable(true);

    //addPostAudience(app_constants.PostAudience.only_me);
    addPostAudience(app_constants.PostAudience.private);

    getPostTypeStream.listen((String postType){

      switch(postType){
        case constants.PostType.image:

          getPostImagesPaths.add(postFile.path);

          addImagesPathToStream(getPostImagesPaths);
          addPostBackgroundImageToStream(postFile.path);


          break;
        case constants.PostType.video:

          getVideoThumbNailFile(videoFile: postFile).then((File videoThumbNailFile){

            addVideoThumbNailPathToStream(videoThumbNailFile.path);
            addPostBackgroundImageToStream(videoThumbNailFile.path);
          });

          addVideoPathToStream(postFile.path);


          break;
        case constants.PostType.audio:
          addAudioPathToStream(postFile.path);
          break;
      }

    });


    getAudioImagePathStream.listen((String audioImagePath){

      this.setAudioImage = audioImagePath;
    });

    // obserbing percentage ratio transfer
    _observeCombineLatestProgressAndTotalTransfer = Observable.combineLatest2(getProgressTransferDataStream, getTotalTransferDataStream, (int progressTransfer, int totalTransfer){

      print("Sent: $progressTransfer, total: $totalTransfer");

      return progressTransfer / totalTransfer;
    }).listen((double percentProgressRatio){
      addPercentRatioProgress(percentProgressRatio);
    });


    /*
    // streaming audio image
    getAudioImagePathStream.listen((String audioImage){

      setAudioImage = audioImage;
    });
    */
  }


  void addIsPostSharable(bool isPostSharable){
    _getIsPostSharableSink.add(isPostSharable);
  }

  void addIsPostMediaDownloadable(bool isPostMediaDownloadable){
    _getIsPostMediaDownloadableSink.add(isPostMediaDownloadable);
  }

  void addPostAudience(String postAudience){
    _getPostAudienceSink.add(postAudience);
  }

  void addIsPostImagesLimitReachedToStream(bool isPostImagesLimitReached){
    _getIsPostImagesLimitReachedSink.add(isPostImagesLimitReached);
  }

  void addIsVideoInitialisedToStream(bool isVideoInitialised){
    _getIsVideoInitialisedSink.add(isVideoInitialised);
  }

  void addPostTypeToStream(String postType){
    _getPostTypeSink.add(postType);
  }


  void addVideoThumbNailPathToStream(String videoThumbNailPath){
    _getVideoThumbNailPathSink.add(videoThumbNailPath);
  }

  void addVideoPathToStream(String videoPath){
    _getVideoPathSink.add(videoPath);
  }

  void addImagesPathToStream(List<String> imagesPath){
    _getImagesPathSink.add(imagesPath);
  }

  void addAudioImagePathToStream(String audioImagePath){
    _getAudioImagePathSink.add(audioImagePath);
  }

  void addAudioPathToStream(String audioPath){
    _getAudioPathSink.add(audioPath);
  }


  // adds post datat to firestore
  @override
  Future<String> addPostData({@required PostModel postModel, @required String currentUserId})async {
    return _postRepository.addPostData(postModel: postModel, currentUserId: currentUserId);
  }

  // adds optimised post data to realtime database
  @override
  Future<Function> addOptimisedPostData({@required OptimisedPostModel optimisedPostModel, @required String currentUserId, @required String postId})async {
    await _postRepository.addOptimisedPostData(optimisedPostModel: optimisedPostModel, currentUserId: currentUserId, postId: postId);
  }


  @override
  Future<File> getVideoThumbNailFile({@required File videoFile})async {
    return MediaProvider.getVideoThumbNailFile(videoFile: videoFile);
  }


  @override
  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {

    return await _postRepository.uploadFile(sourceFile: sourceFile, filename: filename, progressSink: progressSink, totalSink: totalSink);
  }


  @override
  Future<File> compressVideo({@required String videoPath})async {

    return await MediaProvider.compressVideo(videoPath: videoPath);
  }


  @override
  Future<MediaInfo> getMediaInfo({@required String mediaPath})async {
    return await MediaProvider.getMediaInfo(mediaPath: mediaPath);
  }


  // dispose all stream controllers
  @override
  void dispose() {

    _progressTransferDataBehaviorSubject?.close();
    _totalTransferDataBehaviorSubject?.close();
    _percentRatioProgressBehaviorSubject?.close();
    _observeCombineLatestProgressAndTotalTransfer?.cancel();

    _imagesPathBehaviorSubject?.close();
    _videoPathBehaviorSubject?.close();
    _audioPathBehaviorSubject?.close();
    _audioImagePathBehaviorSubject?.close();
    _postTypeBehaviorSubject?.close();
    _postBackgroundImageBehaviorSubject?.close();
    _isVideoInitialisedBehaviorSubject?.close();
    _isPostImagesLimitReachedBehaviorSubject?.close();
    _postAudienceBehaviorSubject?.close();
    _isPostMediaDownloadableBehaviorSubject?.close();
    _isPostSharableBehaviorSubject?.close();
  }



}


