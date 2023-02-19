import 'package:meta/meta.dart';

import '../constants.dart';



class TargetImagePredictionClassModel{

  String prediction_class;
  bool is_predicted;

  TargetImagePredictionClassModel({
    @required this.prediction_class,
    @required this.is_predicted = false
  });

  TargetImagePredictionClassModel.fromJson(Map<String, dynamic> json){

    this.prediction_class = json[TargetImagePredictionClassModelFieldKeys.prediction_class];
    this.is_predicted = json[TargetImagePredictionClassModelFieldKeys.is_predicted];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = Map<String, dynamic>();
    data[TargetImagePredictionClassModelFieldKeys.prediction_class] = this.prediction_class;
    data[TargetImagePredictionClassModelFieldKeys.is_predicted] = this.is_predicted;

    return data;
  }

}



class ImageClassificationChallengeModel{

  String user_id;
  bool is_completed;
  List<dynamic> target_predictions_map_list;
  int timestamp_in_milliseconds;

  ImageClassificationChallengeModel({
    @required this.user_id,
   @required this.is_completed = false,
    @required this.target_predictions_map_list,
    @required this.timestamp_in_milliseconds
});

  ImageClassificationChallengeModel.fromJson(Map<String, dynamic> json){

    this.user_id = json[ImageClassificationChallengeModelFieldKeys.user_id];
    this.is_completed = json[ImageClassificationChallengeModelFieldKeys.is_completed];
    this.target_predictions_map_list = json[ImageClassificationChallengeModelFieldKeys.target_predictions_map_list];
    this.timestamp_in_milliseconds = json[ImageClassificationChallengeModelFieldKeys.timestamp_in_milliseconds];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = Map<String, dynamic>();

    data[ImageClassificationChallengeModelFieldKeys.user_id] = this.user_id;
    data[ImageClassificationChallengeModelFieldKeys.is_completed] = this.is_completed;
    data[ImageClassificationChallengeModelFieldKeys.target_predictions_map_list] = this.target_predictions_map_list;
    data[ImageClassificationChallengeModelFieldKeys.timestamp_in_milliseconds] = this.timestamp_in_milliseconds;

    return data;
  }

  List<String> getAllTargetPredictionClasses(){

    List<String> classes = List<String>();

    for (int index = 0; index < this.target_predictions_map_list.length; ++index){

      TargetImagePredictionClassModel targetImagePredictionClassModel = TargetImagePredictionClassModel.fromJson(target_predictions_map_list[index]);

      classes.add(targetImagePredictionClassModel.prediction_class);
    }

    return classes;
  }


  List<String> getRemainingTargetPredictionClasses(){

    List<String> classes = List<String>();

    for (int index = 0; index < this.target_predictions_map_list.length; ++index){

      TargetImagePredictionClassModel targetImagePredictionClassModel = TargetImagePredictionClassModel.fromJson(target_predictions_map_list[index]);

      if (targetImagePredictionClassModel.is_predicted != true){
        classes.add(targetImagePredictionClassModel.prediction_class);
      }
    }

    return classes;
  }
}








