import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';


class AudioModel{

  String audioId;
  String audioImage;
  String audioThumb;
  String audioUrl;
  int timestamp;
  int numLikes;
  int numComments;
  int numShares;
  int numListens;
  int duration;



  AudioModel({
    this.audioId,
    @required this.audioImage,
    @required this.audioThumb,
    @required this.audioUrl,
    @required this.timestamp,
    this.numLikes = 0,
    this.numComments = 0,
    this.numShares = 0,
    this.numListens = 0,
    @required this.duration,
  });


  AudioModel.fromJson(Map<dynamic, dynamic> json){

    this.audioId = json[AudioDocumentFieldNames.audio_id];
    this.audioImage = json[AudioDocumentFieldNames.audio_image];
    this.audioThumb = json[AudioDocumentFieldNames.audio_thumb];
    this.audioUrl = json[AudioDocumentFieldNames.audio_url];
    this.timestamp = json[AudioDocumentFieldNames.timestamp];
    this.numLikes = json[AudioDocumentFieldNames.num_likes];
    this.numComments = json[AudioDocumentFieldNames.num_comments];
    this.numShares = json[AudioDocumentFieldNames.num_shares];
    this.numListens = json[AudioDocumentFieldNames.num_listens];
    this.duration = json[AudioDocumentFieldNames.duration];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[AudioDocumentFieldNames.audio_id] = this.audioId;
    data[AudioDocumentFieldNames.audio_image] = this.audioImage;
    data[AudioDocumentFieldNames.audio_thumb] = this.audioThumb;
    data[AudioDocumentFieldNames.audio_url] = this.audioUrl;
    data[AudioDocumentFieldNames.timestamp] = this.timestamp;
    data[AudioDocumentFieldNames.num_likes] = this.numLikes;
    data[AudioDocumentFieldNames.num_comments] = this.numComments;
    data[AudioDocumentFieldNames.num_shares] = this.numShares;
    data[AudioDocumentFieldNames.num_listens] = this.numListens;
    data[AudioDocumentFieldNames.duration] = this.duration;

    return data;
  }


}
