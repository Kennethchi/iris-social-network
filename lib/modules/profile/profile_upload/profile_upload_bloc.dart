import 'package:meta/meta.dart';
import 'dart:io';
import 'media_provider.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'profile_upload_validators.dart';
import 'ffmpeg_provider.dart';
import 'package:iris_social_network/services/ffmpeg_services/ffmpeg_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';




abstract class ProfileUploadBlocBlueprint{

  Future<MediaInfo> getMediaInfo({@required String mediaPath});

  Future<String> getVideoThumbnail({@required File videoFile, @required int quality});

  //Future<String> compressVideo({@required String videoPath});

  //Future<List<SplittedVideoModel>> getSplittedVideoParts({@required String videoPath, @required int videoTotalDuration, @required int trimmedVideoDuration});

  void dispose();
}


class ProfileUploadBloc with ProfileUploadValidator implements ProfileUploadBlocBlueprint{


  // Variable to store video file path
  String _videoFilePath;
  String get getVideoFilePath => _videoFilePath;
  set setVideoFilePath(String videoFilePath) {
    _videoFilePath = videoFilePath;
  }

  // variable to store video thumb path
  String _videoThumbPath;
  String get getVideoThumbPath => _videoThumbPath;
  set setVideoThumbPath(String videoThumbPath) {
    _videoThumbPath = videoThumbPath;
  }

  // Variable tp store cleaned caption text
  String _cleanedVideoCaptionText;
  String get getCleanedVideoCaptionText => _cleanedVideoCaptionText;
  set setCleanedVideoCaptionText(String cleanedVideoCaptionText) {
    _cleanedVideoCaptionText = cleanedVideoCaptionText;
  }

  // Variable to store talent type
  String _talentType;
  String get getTalentType => _talentType;
  set setTalentType(String talentType) {
    _talentType = talentType;
  }

  // Variable to store video duration in seconds
  int _videoDurationInSeconds;
  int get getVideoDurationInSeconds => _videoDurationInSeconds;
  set setVideoDurationInSeconds(int videoDurationInSeconds) {
    _videoDurationInSeconds = videoDurationInSeconds;
  }



  // Streams video path
  BehaviorSubject<String> _videoPathBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getVideoPathStream => _videoPathBehaviorSubject.stream;
  StreamSink<String> get _getVideoPathSink => _videoPathBehaviorSubject.sink;



  // Streams video thumbnail path
  BehaviorSubject<String> _videoThumbBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getVideoThumbStream => _videoThumbBehaviorSubject.stream;
  StreamSink<String> get _getVideoThumbSink => _videoThumbBehaviorSubject.sink;


  // Streams video caption
  BehaviorSubject<String> _videoCaptionTextEditingBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getVideoCaptionTextEditingStream => _videoCaptionTextEditingBehaviorSubject.stream.transform(textValidator);
  StreamSink<String> get _getVideoCaptionTextEditingSink => _videoCaptionTextEditingBehaviorSubject.sink;


  // Streams talent type
  BehaviorSubject<String> _talentTypeBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getTalentTypeStream => _talentTypeBehaviorSubject.stream;
  StreamSink<String> get _getTalentTypeSink => _talentTypeBehaviorSubject.sink;


  Observable<bool> get _uploadViewObservable => Observable.combineLatest4(
      getVideoPathStream,
      getVideoThumbStream,
      getVideoCaptionTextEditingStream,
      getTalentTypeStream, (String videoPath, String videoThumb, String videoCaption, String talentType){

        // gets cleaned text from stream when all streams emit atleast one event
        setCleanedVideoCaptionText = videoCaption;

        setTalentType = talentType;

        return true;
  });
  StreamSubscription<bool> _uploadViewObservableStreamSubscription;



  // Streams talent type
  BehaviorSubject<bool> _validateUploadBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getValidateUploadStream => _validateUploadBehaviorSubject.stream;
  StreamSink<bool> get _getValidateUploadSink => _validateUploadBehaviorSubject.sink;




  // Has initialised video controller
  BehaviorSubject<bool> _hasInitialisedVideoBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasInitialisedVideoStream => _hasInitialisedVideoBehaviorSubject.stream;
  StreamSink<bool> get _getHasInitialisedVideoSink => _hasInitialisedVideoBehaviorSubject.sink;


  ProfileUploadBloc({@required File videoFile, @required int videoDurationInSeconds, @required int thumbQuality}){

    // Observes all the streams in the upload view
    _uploadViewObservableStreamSubscription = _uploadViewObservable.listen((bool validateUpload){
      addValidateUploadToStream(validateUpload: validateUpload);
    });


    // set video duration in seconds
    setVideoDurationInSeconds = videoDurationInSeconds;

    // set video file path
    setVideoFilePath = videoFile.path;


    // adds video path to video path stream
    addVideoPathToStream(videoPath: videoFile.path);


    // Gets video thumb from file and sents it to a stream
    getVideoThumbnail(videoFile: videoFile, quality: thumbQuality).then((String thumbPath){
      addVideoThumbToStream(videoThumbPath: thumbPath);
    });



    /*
    getSplittedVideoParts(videoPath: videoFile.path, videoTotalDuration: videoDurationInSeconds, trimmedVideoDuration: 60)
        .then((List<SplittedVideoModel> splittedVideosList){

          addSplittedVideosToStream(splittedVideosList: splittedVideosList);

          if (splittedVideosList != null){
            setVideoFilePath = splittedVideosList[0].videoPath;
            addVideoPathToStream(videoPath: splittedVideosList[0].videoPath);
          }
    });
    */


  }



  void addHasInitialisedVideoToStream({bool hasInitialisedVideo}){
    _getHasInitialisedVideoSink.add(hasInitialisedVideo);
  }


  void addVideoThumbToStream({String videoThumbPath}){
    if (videoThumbPath != null){
      _getVideoThumbSink.add(videoThumbPath);
      setVideoThumbPath = videoThumbPath;
    }
  }

  void addVideoPathToStream({String videoPath}){
    _getVideoPathSink.add(videoPath);
  }

  void addVideoCaptionToStream({String videoCaption}){
    _getVideoCaptionTextEditingSink.add(videoCaption);
  }

  void addTalentTypeToStream({String talentType}){
    _getTalentTypeSink.add(talentType);
  }

  void addValidateUploadToStream({bool validateUpload}){
    _getValidateUploadSink.add(validateUpload);
  }


  @override
  Future<MediaInfo> getMediaInfo({@required String mediaPath}) {
    return MediaProvider.getMediaInfo(mediaPath: mediaPath);
  }

  @override
  Future<String> getVideoThumbnail({File videoFile, int quality})async {
    // TODO: implement getVideoThumbnail
    return await MediaProvider.getVideoThumbnail(videoFile: videoFile, quality: quality);
  }


  @override
  Future<String> compressVideo({@required String videoPath})async{
    return await MediaProvider.compressVideo(videoPath: videoPath);
  }


  /*
  @override
  Future<List<SplittedVideoModel>> getSplittedVideoParts({@required String videoPath, @required int videoTotalDuration, @required int trimmedVideoDuration})async {

    return await FFmpegProvider.getSplittedVideoParts(
        videoPath: videoPath,
        videoTotalDuration: videoTotalDuration,
        trimmedVideoDuration: trimmedVideoDuration
    );

  }
  */


  @override
  void dispose() {
    // TODO: implement dispose

    _videoPathBehaviorSubject?.close();
    _videoThumbBehaviorSubject?.close();
    _videoCaptionTextEditingBehaviorSubject?.close();
    _talentTypeBehaviorSubject?.close();
    _uploadViewObservableStreamSubscription?.cancel();

  }
}