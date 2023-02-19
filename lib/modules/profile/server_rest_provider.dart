import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:iris_social_network/services/server_services/server_rest_api.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'dart:async';
import 'package:iris_social_network/services/server_services/server_rest_api.dart';




class ServerRestProvider{


  static Future<bool> deleteFile({@required String urlPath})async{

    return await ServerRestApi().deleteFile(urlPath: urlPath);
  }

}