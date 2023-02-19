import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'dart:io';
import 'dart:async';
import 'package:meta/meta.dart';
import 'constants.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'models/FileModel.dart';



abstract class ServerRestApiBlueprint{

  uploadFile({@required File sourceFile, @required String filename});

  deleteFile({@required String urlPath});

  downLoadFile({@required String urlPath});
}



class ServerRestApi implements ServerRestApiBlueprint{
  
  Dio _dio;
  
  ServerRestApi(){

    _dio = Dio(new BaseOptions(
        baseUrl: ServerConstants.server_url + ServerConstants.server_fileupload_path,
        connectTimeout: 10000,
        receiveTimeout: 60000,
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        }
    ));

  }


  @override
  Future<Map<String, dynamic>> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {

    String uploadInitialised = Timestamp.now().toString();

    StorageReference storageReference = FirebaseStorage.instance.ref().child("users/" + filename);
    StorageUploadTask uploadTask = storageReference.putFile(sourceFile);


    uploadTask.events.listen((StorageTaskEvent event){
      progressSink.add(event.snapshot.bytesTransferred);
      totalSink.add(event.snapshot.totalByteCount);
    });

    StorageTaskSnapshot storageTaskSnapshot =await uploadTask.onComplete;

    String fileUrl = await storageReference.getDownloadURL();

    return {
      "file": fileUrl,
      "upload_initialised": Timestamp.now().toString(),
      "upload_completed": uploadInitialised,
    };
  }
  
/*
  @override
  Future<Map<String, dynamic>> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {

    FormData formData = new FormData.from({
      "file": new UploadFileInfo(sourceFile, filename),
    });


    Response response = await this._dio.post(
      "",
      data: formData,
      onSendProgress: (int sent, int total){

        progressSink.add(sent);
        totalSink.add(total);
      },
    );

    // According to server
    response.data["file"] = ServerConstants.server_url + response.data["file"];

    return response.data;
  }
*/


  @override
  Future<bool> deleteFile({@required String urlPath})async {

    FirebaseStorage firebaseStorage = FirebaseStorage();
    StorageReference storageReference = await firebaseStorage.getReferenceFromUrl(urlPath);

    await firebaseStorage.ref().child(storageReference.path).delete();

    //await FirebaseDatabase.instance.reference().child(RootReferenceNames.deleted_files_path).push().set(urlPath);

    return true;
  }


  @override
  Future<File> downLoadFile({@required String urlPath, @required String savePath, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {

    //Directory directory = await getApplicationDocumentsDirectory();

    //savePath = directory.path + "/" + savePath;

    Response<dynamic> response = await this._dio.download(urlPath, savePath, onReceiveProgress: (int received, int total){

      progressSink.add(received);
      totalSink.add(total);
    });

    if (response.statusCode == HttpStatus.ok){
      return File(savePath);
    }
    else{
      return null;
    }

  }


}





