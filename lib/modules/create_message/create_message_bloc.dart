import 'dart:async';
import 'dart:io';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:meta/meta.dart';
import 'create_message_dependency_injection.dart';
import 'create_message_repository.dart';
import 'package:rxdart/rxdart.dart';


abstract class CreateMessageBlocBlueprint{

  Future<File> getVideoThumbNailFile({@required File videoFile});

  Future<MediaInfo> getMediaInfo({@required String mediaPath});

  Future<File> compressVideo({@required String videoPath});

  void dispose();
}


class CreateMessageBloc implements CreateMessageBlocBlueprint{




  // message background image streaming
  BehaviorSubject<String> _messageBackgroundImageBehaviorSubject =  BehaviorSubject<String>();
  Stream<String> get getMessageBackgroundImageStream => _messageBackgroundImageBehaviorSubject.stream;
  StreamSink<String> get _getMessageBackgroundImageSink => _messageBackgroundImageBehaviorSubject.sink;

  void addMessageBackgroundImageToStream(String backgroundImage){
    _getMessageBackgroundImageSink.add(backgroundImage);
  }



  String _messageType;
  String get getMessageType => _messageType;
  set setMessageType(String messageType) {
    _messageType = messageType;
  }


  // images for image message
  List<String> _messageImagesPaths;
  List<String> get getMessageImagesPaths => _messageImagesPaths;
  set setMessageImagesPaths(List<String> messageImagesPaths) {
    _messageImagesPaths = messageImagesPaths;
  }

  // video path for video message
  String _videoPath;
  String get getVideoPath => _videoPath;
  set setVideoPath(String videoPath) {
    _videoPath = videoPath;
  }

  // video thumb for video message
  String _videoThumbPath;
  String get getVideoThumbPath => _videoThumbPath;
  set setVideoThumbPath(String videoThumbPath) {
    _videoThumbPath = videoThumbPath;
  }

  // get Auddio path for audio message
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


  int _audioDuration;
  int get getAudioDuration => _audioDuration;
  set setAudioDuration(int audioDuration) {
    _audioDuration = audioDuration;
  }


  bool _isMessageMediaDownloadable;
  bool get getIsMessageMediaDownloadable => _isMessageMediaDownloadable;
  set setIsMessageMediaDownloadable(bool isMessageMediaDownloadable) {
    _isMessageMediaDownloadable = isMessageMediaDownloadable;
  }


  // Streaming video path
  BehaviorSubject<String> _videoPathBehaviorSubject= BehaviorSubject<String>();
  Stream<String> get getVideoPathStream => _videoPathBehaviorSubject.stream;
  StreamSink<String> get _getVideoPathSink => _videoPathBehaviorSubject.sink;


  // Streaming video thumbnail path
  BehaviorSubject<String> _videoThumbNailPathBehaviorSubject= BehaviorSubject<String>();
  Stream<String> get getVideoThumbNailPathStream => _videoThumbNailPathBehaviorSubject.stream;
  StreamSink<String> get _getVideoThumbNailPathSink => _videoThumbNailPathBehaviorSubject.sink;


  // Streaming message images list paths
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


  BehaviorSubject<String> _messageTypeBehaviorSubject= BehaviorSubject<String>();
  Stream<String> get getMessageTypeStream => _messageTypeBehaviorSubject.stream;
  StreamSink<String> get _getMessageTypeSink => _messageTypeBehaviorSubject.sink;


  BehaviorSubject<bool> _isVideoInitialisedBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsVideoInitialisedStream => _isVideoInitialisedBehaviorSubject.stream;
  StreamSink<bool> get _getIsVideoInitialisedSink => _isVideoInitialisedBehaviorSubject.sink;


  BehaviorSubject<bool> _isMessageImagesLimitReachedBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsMessageImagesLimitReachedStream => _isMessageImagesLimitReachedBehaviorSubject.stream;
  StreamSink<bool> get _getIsMessageImagesLimitReachedSink => _isMessageImagesLimitReachedBehaviorSubject.sink;

  BehaviorSubject<bool> _isMessageMediaDownloadableBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsMessageMediaDownloadableStream => _isMessageMediaDownloadableBehaviorSubject.stream;
  StreamSink<bool> get _getIsMessageMediaDownloadableSink => _isMessageMediaDownloadableBehaviorSubject.sink;



  Observable<bool> get getIsMessageImageSetupCompleteObservable => Observable.combineLatest3(
      getImagesPathStream, getMessageTypeStream, getIsMessageMediaDownloadableStream,  (List<String> messageImagesPath, String messageType, bool mediaDownloadable){

    if (messageImagesPath == null || messageType == null || mediaDownloadable == null){
      return false;
    }

    this.setMessageImagesPaths = messageImagesPath;
    this.setIsMessageMediaDownloadable = mediaDownloadable;

    return true;
  });

  Observable<bool> get getIsMessageVideoSetupCompleteObservable => Observable.combineLatest4(
      getVideoPathStream,
      getVideoThumbNailPathStream,
      getMessageTypeStream, getIsMessageMediaDownloadableStream, (String videoPath, String videoThumbNailPath, String messageType, bool mediaDownloadable){

        if (videoPath == null || videoThumbNailPath == null || messageType == null || mediaDownloadable == null ){
          return false;
        }

        this.setVideoPath = videoPath;
        this.setVideoThumbPath = videoThumbNailPath;
        this.setIsMessageMediaDownloadable = mediaDownloadable;

        return true;
      });


  Observable<bool> get getIsMessageAudioSetupCompleteObservable => Observable.combineLatest3(
      getAudioPathStream, getMessageTypeStream, getIsMessageMediaDownloadableStream, (String audioPath, String messageType, bool mediaDownloadable){

    if (audioPath == null || messageType == null || mediaDownloadable == null){
      return false;
    }

    this.setAudioPath = audioPath;
    this.setIsMessageMediaDownloadable = mediaDownloadable;

    return true;
  });



  CreateMessageRepository _createMessageRepository;



  CreateMessageBloc({@required File messageFile}){

    _createMessageRepository = CreateMessageDependencyInjector().getCreateMessageRepository;


    setMessageImagesPaths = List<String>();


    // initialise post settings
    addIsMessageMediaDownloadable(true);
    //addIsPostSharable(true);

    

    getMessageTypeStream.listen((String messageType){

      this.setMessageType = messageType;

      switch(messageType){
        case MessageType.image:

          getMessageImagesPaths.add(messageFile.path);

          addImagesPathToStream(getMessageImagesPaths);
          addMessageBackgroundImageToStream(messageFile.path);


          break;
        case MessageType.video:

          getVideoThumbNailFile(videoFile: messageFile).then((File videoThumbNailFile){

            addVideoThumbNailPathToStream(videoThumbNailFile.path);
            addMessageBackgroundImageToStream(videoThumbNailFile.path);
          });

          addVideoPathToStream(messageFile.path);


          break;
        case MessageType.audio:
          addAudioPathToStream(messageFile.path);
          break;
      }

    });


    // streaming audio image
    getAudioImagePathStream.listen((String audioImage){
      setAudioImage = audioImage;
    });
  }



  void addIsMessageMediaDownloadable(bool isMessageMediaDownloadable){
    _getIsMessageMediaDownloadableSink.add(isMessageMediaDownloadable);
  }


  void addIsMessageImagesLimitReachedToStream(bool isMessageImagesLimitReached){
    _getIsMessageImagesLimitReachedSink.add(isMessageImagesLimitReached);
  }

  void addIsVideoInitialisedToStream(bool isVideoInitialised){
    _getIsVideoInitialisedSink.add(isVideoInitialised);
  }

  void addMessageTypeToStream(String messageType){
    this.setMessageType = messageType;
    _getMessageTypeSink.add(messageType);
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



  @override
  Future<File> getVideoThumbNailFile({@required File videoFile})async {
    return await _createMessageRepository.getVideoThumbNailFile(videoFile: videoFile);
  }


  @override
  Future<File> compressVideo({@required String videoPath})async {

    return await _createMessageRepository.compressVideo(videoPath: videoPath);
  }


  @override
  Future<MediaInfo> getMediaInfo({@required String mediaPath})async {
    return await _createMessageRepository.getMediaInfo(mediaPath: mediaPath);
  }
  
  
  @override
  void dispose() {


    _imagesPathBehaviorSubject?.close();
    _videoPathBehaviorSubject?.close();
    _audioPathBehaviorSubject?.close();
    _audioImagePathBehaviorSubject?.close();
    _messageTypeBehaviorSubject?.close();
    _messageBackgroundImageBehaviorSubject?.close();
    _isVideoInitialisedBehaviorSubject?.close();
    _isMessageImagesLimitReachedBehaviorSubject?.close();

  }
}


