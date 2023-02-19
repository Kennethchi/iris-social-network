import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';


class MessageAudioModel{

  String audioImage;
  String audioThumb;
  String audioUrl;
  int duration;



  MessageAudioModel({
    @required this.audioImage,
    @required this.audioThumb,
    @required this.audioUrl,
    @required this.duration,
  });


  MessageAudioModel.fromJson(Map<dynamic, dynamic> json){

    this.audioImage = json[AudioDocumentFieldNames.audio_image];
    this.audioThumb = json[AudioDocumentFieldNames.audio_thumb];
    this.audioUrl = json[AudioDocumentFieldNames.audio_url];
    this.duration = json[AudioDocumentFieldNames.duration];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[MessageAudioDocumentFieldNames.audio_image] = this.audioImage;
    data[MessageAudioDocumentFieldNames.audio_thumb] = this.audioThumb;
    data[MessageAudioDocumentFieldNames.audio_url] = this.audioUrl;
    data[MessageAudioDocumentFieldNames.duration] = this.duration;

    return data;
  }


}
