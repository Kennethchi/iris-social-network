import 'package:meta/meta.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';



class DownloadProvider{

  Future<void> downloadImageFile({@required String urlPath, @required String destinationPath, VoidCallback onDownloadProgress(int received, int total)}) async{

    Directory appDirectory = await getApplicationDocumentsDirectory();
    Dio dio = Dio();

    await dio.download(
        urlPath,
        appDirectory.path + destinationPath + "${DateTime.now().millisecondsSinceEpoch}" + StorageFileExtensions.jpg ,
        onReceiveProgress: onDownloadProgress
    );

  }







}


