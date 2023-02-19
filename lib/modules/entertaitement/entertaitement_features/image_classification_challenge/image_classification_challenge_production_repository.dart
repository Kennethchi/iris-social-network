import 'dart:async';
import 'package:iris_social_network/services/entertaitement_services/models/image_classification_challenges_models.dart';
import 'package:meta/meta.dart';
import 'image_classification_challenge_repository.dart';

import 'dart:io';
import 'package:iris_social_network/services/machine_learning_services/machine_learning_servers_api/models/image_prediction_result_model.dart';
import 'image_classification_rest_api_provider.dart';
import 'shared_preferences_provider.dart';


class ImageClassificationChallengeProductionRepository extends ImageClassificationChallengeRepository{


  @override
  Future<ImagePredictionResultModel> predictImage({@required File sourceFile, @required String filename, @required String endpoint})async {
    return await ImageClassificationRestApiProvider.predictImage(sourceFile: sourceFile, filename: filename, endpoint: endpoint);
  }

  @override
  Future<bool> getIsChallengeComplete({@required String currentUserId})async {
    return await SharedPreferencesProvider.getIsChallengeComplete(currentUserId: currentUserId);
  }

  @override
  Future<ImageClassificationChallengeModel> updateChallengeState({@required String currentUserId, @required String targetPredictionClass})async {
    return await SharedPreferencesProvider.updateChallengeState(currentUserId: currentUserId, targetPredictionClass: targetPredictionClass);
  }

  @override
  Future<ImageClassificationChallengeModel> initialiseImageClassificationChallengeState({
    @required String currentUserId, @required int timestampInMilliseconds,
    @required List<String> classification_classes_full_list, @required int num_of_target_predictions})async {

    return await SharedPreferencesProvider.initialiseImageClassificationChallengeState(
        currentUserId: currentUserId,
        timestampInMilliseconds: timestampInMilliseconds,
        classification_classes_full_list: classification_classes_full_list,
        num_of_target_predictions: num_of_target_predictions
    );
  }

  @override
  Future<ImageClassificationChallengeModel> getImageClassificationChallengeModel({@required String currentUserId})async {

    return await SharedPreferencesProvider.getImageClassificationChallengeModel(currentUserId: currentUserId);
  }


}





