import 'package:meta/meta.dart';

import '../constants.dart';




class ImagePredictionResultModel{

  String prediction_class;
  String prediction_score;

  ImagePredictionResultModel({
   @required this.prediction_class,
    @required this.prediction_score
});

  ImagePredictionResultModel.fromJson(Map<String, dynamic> json){

    this.prediction_class = json[ImagePredictionResultModelFieldKeys.prediction_class];
    this.prediction_score = json[ImagePredictionResultModelFieldKeys.prediction_score];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = Map<String, dynamic>();
    data[ImagePredictionResultModelFieldKeys.prediction_class] = this.prediction_class;
    data[ImagePredictionResultModelFieldKeys.prediction_score] = this.prediction_score;

    return data;
  }

}









