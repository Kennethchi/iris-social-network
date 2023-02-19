

const int number_of_challenge_prediction_classes_per_day = 3;


class TargetImagePredictionClassModelFieldKeys{

  static String prediction_class = "prediction_class";
  static String is_predicted = "is_predicted";
}





class ImageClassificationChallengeModelFieldKeys{

  static String user_id = "user_id";
  static String is_completed = "is_completed";
  static String target_predictions_map_list = "target_predictions_map_list";
  static String timestamp_in_milliseconds = "timestamp_in_milliseconds";
}
