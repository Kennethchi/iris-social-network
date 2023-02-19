import 'package:dio/dio.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'dart:io';
import 'dart:async';
import 'package:meta/meta.dart';
import 'constants.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';




class ImageClassificationRestApi{


  static Future<Map<String, dynamic>> predictImage({@required File sourceFile, @required String filename, @required String endpoint})async {

    Dio _dio = Dio(new BaseOptions(
        baseUrl: endpoint,
        connectTimeout: 10000,
        receiveTimeout: 60000,
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        }
    ));

    FormData formData = new FormData.from({
      "file": new UploadFileInfo(sourceFile, filename),
    });

    Response response = await _dio.post("", data: formData,);

    if (response.statusCode == 200){
      return response.data;
    }
    else{
      return null;
    }

  }


}


