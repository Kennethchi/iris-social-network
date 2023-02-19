import 'dart:io';

import 'package:iris_social_network/services/machine_learning_services/machine_learning_servers_api/machine_learning_servers_api.dart';
import 'package:iris_social_network/services/machine_learning_services/machine_learning_servers_api/models/image_prediction_result_model.dart';
import 'package:meta/meta.dart';


class ImageClassificationRestApiProvider{

  static Future<ImagePredictionResultModel> predictImage({@required File sourceFile, @required String filename, @required String endpoint})async{

    Map<String, dynamic> map = await ImageClassificationRestApi.predictImage(sourceFile: sourceFile, filename: filename, endpoint: endpoint);

    if (map != null){

      return ImagePredictionResultModel.fromJson(map);
    }
    else{
      return null;
    }

  }


}