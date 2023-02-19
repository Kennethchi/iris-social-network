import 'dart:async';
import 'dart:io';

import 'package:iris_social_network/services/server_services/server_rest_api.dart';
import 'package:meta/meta.dart';



class ServerRestApiProvider{

  static Future<File> downLoadFile({@required String urlPath, @required String savePath, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async{

    return await ServerRestApi().downLoadFile(urlPath: urlPath, savePath: savePath, progressSink: progressSink, totalSink: totalSink);
  }
}