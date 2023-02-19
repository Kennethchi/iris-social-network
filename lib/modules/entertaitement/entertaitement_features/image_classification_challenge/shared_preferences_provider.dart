import 'package:iris_social_network/services/entertaitement_services/models/image_classification_challenges_models.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math' as math;





class SharedPreferencesProvider{


  static Future<ImageClassificationChallengeModel> getImageClassificationChallengeModel({@required String currentUserId})async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String challengeModelMapString = sharedPreferences.getString(
        SharedPrefsKeys.image_classification_challenge_model_string + currentUserId
    );


    if (challengeModelMapString != null){
      Map<String, dynamic> map = jsonDecode(challengeModelMapString);

      ImageClassificationChallengeModel imageClassificationChallengeModel = ImageClassificationChallengeModel.fromJson(map);

      if (imageClassificationChallengeModel.user_id == currentUserId){

        return imageClassificationChallengeModel;
      }
      else{
        return null;
      }
    }
    else{

      return null;
    }

  }



  static Future<ImageClassificationChallengeModel> initialiseImageClassificationChallengeState({
    @required String currentUserId,
    @required int timestampInMilliseconds,
    @required List<String> classification_classes_full_list,
    @required int num_of_target_predictions
  })async{

    List<Map<String, dynamic>> targetPredictionMaps = List<Map<String, dynamic>>(num_of_target_predictions);
    math.Random randomObj = math.Random.secure();


    List<int> usedNumbersList = List<int>();

    for (int index = 0; index < targetPredictionMaps.length; ++index){


      int randomNumIndex;
      do{
        // nextInt generates from 0, inclusive, to [max], exclusive
        randomNumIndex = randomObj
            .nextInt(classification_classes_full_list.length)
            .clamp(0, classification_classes_full_list.length - 1);
      }while(usedNumbersList.contains(randomNumIndex) == true);


      String randomTargetPredictionClass = classification_classes_full_list[randomNumIndex];

      TargetImagePredictionClassModel predictionClassModel = TargetImagePredictionClassModel(
          prediction_class: randomTargetPredictionClass,
          is_predicted: false
      );

      targetPredictionMaps[index] = predictionClassModel.toJson();

      usedNumbersList.add(randomNumIndex);
    }

    ImageClassificationChallengeModel imageClassificationChallengeModel = ImageClassificationChallengeModel(
        user_id: currentUserId,
        is_completed: false,
        target_predictions_map_list: targetPredictionMaps,

        timestamp_in_milliseconds: timestampInMilliseconds
    );

    Map<String, dynamic> challengeModelMap = imageClassificationChallengeModel.toJson();

    String encodedJsonString = jsonEncode(challengeModelMap);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool success = await sharedPreferences
        .setString(SharedPrefsKeys.image_classification_challenge_model_string + currentUserId, encodedJsonString
    );




    return imageClassificationChallengeModel;
  }



  static Future<ImageClassificationChallengeModel> updateChallengeState({
    @required String currentUserId,
    @required String targetPredictionClass
  })async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String encodedString =  sharedPreferences.getString(SharedPrefsKeys.image_classification_challenge_model_string + currentUserId);

    Map<String, dynamic> map = jsonDecode(encodedString);
    ImageClassificationChallengeModel imageClassificationChallengeModel = ImageClassificationChallengeModel.fromJson(map);


    List<Map<String, dynamic>> dummyList = List<Map<String, dynamic>>();

    for (int index = 0; index < imageClassificationChallengeModel.target_predictions_map_list.length; ++index){
      dummyList.add(imageClassificationChallengeModel.target_predictions_map_list[index]);
    }


    for (int index = 0; index < dummyList.length; ++index){

      Map<String, dynamic> targetClassMap = dummyList[index];
      TargetImagePredictionClassModel targetImagePredictionClassModel = TargetImagePredictionClassModel.fromJson(targetClassMap);
      if (targetImagePredictionClassModel.prediction_class == targetPredictionClass){
        targetImagePredictionClassModel.is_predicted = true;
        imageClassificationChallengeModel.target_predictions_map_list[index] = targetImagePredictionClassModel.toJson();
        break;
      }
    }


    await sharedPreferences.setString(SharedPrefsKeys.image_classification_challenge_model_string + currentUserId,
      jsonEncode(imageClassificationChallengeModel.toJson())
    );

    return imageClassificationChallengeModel;
  }


  static Future<bool> getIsChallengeComplete({@required String currentUserId})async{


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String encodedString =  sharedPreferences.getString(SharedPrefsKeys.image_classification_challenge_model_string + currentUserId);

    Map<String, dynamic> map = jsonDecode(encodedString);
    ImageClassificationChallengeModel imageClassificationChallengeModel = ImageClassificationChallengeModel.fromJson(map);


    int numOfSuccessFullPredictions = 0;

    for (int index = 0; index < imageClassificationChallengeModel.target_predictions_map_list.length; ++index){

      TargetImagePredictionClassModel targetImagePredictionClassModel = TargetImagePredictionClassModel.fromJson(
        imageClassificationChallengeModel.target_predictions_map_list[index]
      );

      if (targetImagePredictionClassModel.is_predicted){
        numOfSuccessFullPredictions += 1;
      }
    }

    if (numOfSuccessFullPredictions == imageClassificationChallengeModel.target_predictions_map_list.length){
      return true;
    }
    else{
      return false;
    }

  }



}






