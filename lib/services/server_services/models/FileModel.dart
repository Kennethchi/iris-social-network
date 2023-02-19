import 'dart:async';
import 'package:meta/meta.dart';



class FileModel{

  String upload_initiated;
  String upload_completed;
  //Map<String, dynamic> fileMap;
  String fileUrl;


  FileModel({
    @required this.upload_initiated,
    @required this.upload_completed,
    //@required this.fileMap
    @required this.fileUrl
});


  FileModel.fromJson(Map<String, dynamic> data){

    this.upload_initiated = data["upload_initiated"];
    this.upload_completed = data["upload_completed"];
    this.fileUrl = data["file"];
  }

  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data["upload_initiated"] = this.upload_initiated;
    data["upload_completed"] = this.upload_completed;
    data["file"] = this.fileUrl;

    return data;
  }


}


