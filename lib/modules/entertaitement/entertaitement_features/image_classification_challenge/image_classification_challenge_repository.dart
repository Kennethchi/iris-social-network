import 'dart:async';
import 'dart:io';
import 'package:iris_social_network/services/entertaitement_services/models/image_classification_challenges_models.dart';
import 'package:iris_social_network/services/machine_learning_services/machine_learning_servers_api/models/image_prediction_result_model.dart';
import 'package:meta/meta.dart';


abstract class ImageClassificationChallengeRepository{

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
}