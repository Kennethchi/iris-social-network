import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:iris_social_network/services/server_services/server_rest_api.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'dart:async';




class ServerRestProvider{


  static Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async{

    return await FileModel.fromJson(await ServerRestApi().uploadFile(sourceFile: sourceFile, filename: filename, progressSink: progressSink, totalSink: totalSink));
  }

}