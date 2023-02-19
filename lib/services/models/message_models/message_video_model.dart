import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';


class MessageVideoModel{

  String videoImage;
  String videoThumb;
  String videoUrl;
  int duration;


  MessageVideoModel({
    @required this.videoImage,
    @required this.videoThumb,
    @required this.videoUrl,
    @required this.duration,
  });


  MessageVideoModel.fromJson(Map<dynamic, dynamic> json){

    this.videoImage = json[MessageVideoDocumentFieldNames.video_image];
    this.videoThumb = json[MessageVideoDocumentFieldNames.video_thumb];
    this.videoUrl = json[MessageVideoDocumentFieldNames.video_url];
    this.duration = json[MessageVideoDocumentFieldNames.duration];

  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[MessageVideoDocumentFieldNames.video_image] = this.videoImage;
    data[MessageVideoDocumentFieldNames.video_thumb] = this.videoThumb;
    data[MessageVideoDocumentFieldNames.video_url] = this.videoUrl;
    data[MessageVideoDocumentFieldNames.duration] = this.duration;

    return data;
  }


}
