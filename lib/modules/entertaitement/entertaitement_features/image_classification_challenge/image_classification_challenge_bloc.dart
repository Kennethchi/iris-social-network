import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/services/entertaitement_services/constants.dart' as entertaitement_services_constants;
import 'package:iris_social_network/services/entertaitement_services/models/image_classification_challenges_models.dart';
import 'package:iris_social_network/services/machine_learning_services/machine_learning_servers_api/models/image_prediction_result_model.dart';
import 'package:meta/meta.dart';
import 'image_classification_challenge_dependency_injection.dart';
import 'image_classification_challenge_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:iris_social_network/services/machine_learning_services/classification_classes/imagenet_object_classes.dart' as imagenet_classes;



abstract class ImageClassificationChallengeBlocBlueprint{

  Future<ImagePredictionResultModel> predictImage({@required File sourceFile, @required String filename, @required String endpoint});


  Future<ImageClassificationChallengeModel> getImageClassificationChallengeModel({@required String currentUserId});

  Future<ImageClassificationChallengeModel> initialiseImageClassificationChallengeState({
    @required String currentUserId,
    @required int timestampInMilliseconds,
    @required List<String> classification_classes_full_list,
    @required int num_of_target_predictions
  });

  Future<ImageClassificationChallengeModel> updateChallengeState({@required String currentUserId, @required String targetPredictionClass});

  Future<bool> getIsChallengeComplete({@required String currentUserId});

  void dispose();
}




class ImageClassificationChallengeBloc implements ImageClassificationChallengeBlocBlueprint{

  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }


  ImageClassificationChallengeModel _imageChallengeModel;
  ImageClassificationChallengeModel get getImageChallengeModel => _imageChallengeModel;
  set setImageChallengeModel(ImageClassificationChallengeModel imageChallengeModel) {
    _imageChallengeModel = imageChallengeModel;
  }


  BehaviorSubject<String> _userSelectedImagePathBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getUserSelectedImagePathStream => _userSelectedImagePathBehaviorSubject.stream;
  Sink<String> get _getUserSelectedImagePathSink => _userSelectedImagePathBehaviorSubject.sink;


  BehaviorSubject<bool> _showPredictionResultBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getShowPredictionResultStream => _showPredictionResultBehaviorSubject.stream;
  StreamSink<bool> get _getShowPredictionResultSink => _showPredictionResultBehaviorSubject.sink;


  BehaviorSubject<ImagePredictionResultModel> _imagePredictionResultModelBehaviorSubject = BehaviorSubject<ImagePredictionResultModel>();
  Stream<ImagePredictionResultModel> get getImagePredictionResultStream => _imagePredictionResultModelBehaviorSubject.stream;
  StreamSink<ImagePredictionResultModel> get _getImagePredictionResultSink => _imagePredictionResultModelBehaviorSubject.sink;


  BehaviorSubject<bool> _showPredictionOngoingProgressIndicatorBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getShowPredictionOngoingProgressIndicatorStream => _showPredictionOngoingProgressIndicatorBehaviorSubject.stream;
  StreamSink<bool> get _getShowPredictionOngoingProgressIndicatorSink => _showPredictionOngoingProgressIndicatorBehaviorSubject.sink;



  BehaviorSubject<ImageClassificationChallengeModel> _imageClassificationChallengeModelBehaviorSubject = BehaviorSubject<ImageClassificationChallengeModel>();
  Stream<ImageClassificationChallengeModel> get getImageClassificationChallengeModelStream => _imageClassificationChallengeModelBehaviorSubject.stream;
  StreamSink<ImageClassificationChallengeModel> get _getImageClassificationChallengeModelSink => _imageClassificationChallengeModelBehaviorSubject.sink;


  BehaviorSubject<bool> _isChallengeCompleteBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsChallengeCompleteStream => _isChallengeCompleteBehaviorSubject.stream;
  StreamSink<bool> get _getIsChallengeCompleteSink => _isChallengeCompleteBehaviorSubject.sink;





  ImageClassificationChallengeRepository _imageClassificationChallengeRepository;



  ImageClassificationChallengeBloc(){
    _imageClassificationChallengeRepository = ImageClassificationChallengeDependencyInjector().getRepository;


    getFirebaseUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){


        setCurrentUserId = firebaseUser.uid;
        getImageClassificationChallengeModel(currentUserId: firebaseUser.uid).then((ImageClassificationChallengeModel challengeModel){

          // initialise challenge complete
          addIsChallengeCompleteToStream(false);

          if (challengeModel != null){

            bool shouldResetChallenge = this.shouldResetChallenge(lastTimestampInMilliseconds: challengeModel.timestamp_in_milliseconds);

            if (shouldResetChallenge){

              initialiseImageClassificationChallengeState(
                  currentUserId: firebaseUser.uid,
                  timestampInMilliseconds: DateTime.now().millisecondsSinceEpoch,
                  classification_classes_full_list: imagenet_classes.imagenet_object_classes_list,
                  num_of_target_predictions: entertaitement_services_constants.number_of_challenge_prediction_classes_per_day
              ).then((ImageClassificationChallengeModel challengeModel){

                addImageClassificationChallengeModelToStream(challengeModel);
              });
            }
            else{

              // Challenge resumes
              addImageClassificationChallengeModelToStream(challengeModel);

              if (challengeModel.getRemainingTargetPredictionClasses().isEmpty){
                addIsChallengeCompleteToStream(true);
              }
            }

          }
          else{

            initialiseImageClassificationChallengeState(
                currentUserId: firebaseUser.uid,
                timestampInMilliseconds: DateTime.now().millisecondsSinceEpoch,
                classification_classes_full_list: imagenet_classes.imagenet_object_classes_list,
                num_of_target_predictions: entertaitement_services_constants.number_of_challenge_prediction_classes_per_day
            ).then((ImageClassificationChallengeModel challengeModel){

              addImageClassificationChallengeModelToStream(challengeModel);
            });
          }

        });

      }

    });

    addShowPredictionResultToStream(false);
    addShowPredictionOngoingProgressIndicatorToStream(false);

    getImageClassificationChallengeModelStream.listen((ImageClassificationChallengeModel imageClassificationChallengModel){
      setImageChallengeModel = imageClassificationChallengModel;
    });
  }



  Future<FirebaseUser> getFirebaseUser()async{
    return await FirebaseAuth.instance.currentUser();
  }


  void addIsChallengeCompleteToStream(bool isChallengeComplete){
    _getIsChallengeCompleteSink.add(isChallengeComplete);
  }

  void addImageClassificationChallengeModelToStream(ImageClassificationChallengeModel imageClassificationChallengeModel){
    _getImageClassificationChallengeModelSink.add(imageClassificationChallengeModel);
  }

  void addShowPredictionOngoingProgressIndicatorToStream(bool showPredictionOngoingProgressIndicator){
    _getShowPredictionOngoingProgressIndicatorSink.add(showPredictionOngoingProgressIndicator);
  }

  void addImagePredictionResultModelToStream(ImagePredictionResultModel imagePredictionResultModel){
    _getImagePredictionResultSink.add(imagePredictionResultModel);
  }

  void addShowPredictionResultToStream(bool showPredictionResult){
    _getShowPredictionResultSink.add(showPredictionResult);
  }

  void addUserSelectedImagePathToStream(String userSelectedImagePath){
    _getUserSelectedImagePathSink.add(userSelectedImagePath);
  }


  @override
  Future<ImagePredictionResultModel> predictImage({@required File sourceFile, @required String filename, @required String endpoint})async{

    return await _imageClassificationChallengeRepository.predictImage(sourceFile: sourceFile, filename: filename, endpoint: endpoint);
  }


  @override
  Future<ImageClassificationChallengeModel> getImageClassificationChallengeModel({@required String currentUserId})async{
    return await _imageClassificationChallengeRepository.getImageClassificationChallengeModel(currentUserId: currentUserId);
  }


  @override
  Future<ImageClassificationChallengeModel> initialiseImageClassificationChallengeState(
      {@required String currentUserId, @required int timestampInMilliseconds, @required List<
          String> classification_classes_full_list, @required int num_of_target_predictions})async {

    return await _imageClassificationChallengeRepository.initialiseImageClassificationChallengeState(
        currentUserId: currentUserId,
        timestampInMilliseconds: timestampInMilliseconds,
        classification_classes_full_list: classification_classes_full_list,
        num_of_target_predictions: num_of_target_predictions
    );
  }

  @override
  Future<ImageClassificationChallengeModel> updateChallengeState({@required String currentUserId, @required String targetPredictionClass})async {

    return await _imageClassificationChallengeRepository.updateChallengeState(
        currentUserId: currentUserId,
        targetPredictionClass: targetPredictionClass
    );
  }

  @override
  Future<bool> getIsChallengeComplete({@required String currentUserId})async {
    return await _imageClassificationChallengeRepository.getIsChallengeComplete(currentUserId: currentUserId);
  }



  bool shouldResetChallenge({@required int lastTimestampInMilliseconds}){

    DateTime dateTimeNow = DateTime.now();
    DateTime dateTimeLastSeen = DateTime.fromMillisecondsSinceEpoch(lastTimestampInMilliseconds);

    if (dateTimeNow.day == dateTimeLastSeen.day
        &&  dateTimeNow.month == dateTimeLastSeen.month
        && dateTimeNow.year == dateTimeLastSeen.year
    ){

      return false;
    }
    else if ((dateTimeNow.day  - dateTimeLastSeen.day) == 1
        &&  (dateTimeNow.month == dateTimeLastSeen.month
            || (dateTimeNow.month - dateTimeLastSeen.month) == 1
            || (dateTimeNow.month - dateTimeLastSeen.month) == -11
        )
        && dateTimeNow.year == dateTimeLastSeen.year
    ){
      return true;
    }
    else{
      return true;
    }
  }


  @override
  void dispose() {

    _userSelectedImagePathBehaviorSubject?.close();
    _showPredictionResultBehaviorSubject?.close();
    _imageClassificationChallengeModelBehaviorSubject?.close();
    _isChallengeCompleteBehaviorSubject?.close();
  }

}


