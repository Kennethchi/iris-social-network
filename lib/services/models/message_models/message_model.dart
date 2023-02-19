import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';

class MessageModel{

  String message_id;

  String message_text;
  String message_type;
  String sender_id;
  String receiver_id;
  //String sender_name;
  //String sender_thumb;
  Timestamp timestamp;
  bool seen;
  Map<dynamic, dynamic> message_data;
  bool downloadable;

  Map<dynamic, dynamic> referred_message;



  MessageModel({
    @required this.message_text,
    @required this.message_type,
    @required this.sender_id,
    @required this.receiver_id,
    //this.sender_name,
    //this.sender_thumb,
    @required this.timestamp,
    @required this.seen = false,
    @required this.message_data,
    @required this.downloadable,
    this.referred_message = null
  });


  MessageModel.fromJson(Map<dynamic, dynamic> json){

    this.message_id = json[MessageDocumentFieldName.message_id];
    this.message_text = json[MessageDocumentFieldName.message_text];
    this.message_type = json[MessageDocumentFieldName.message_type];
    this.sender_id = json[MessageDocumentFieldName.sender_id];
    this.receiver_id = json[MessageDocumentFieldName.receiver_id];
    //this.sender_name = json[MessageDocumentFieldName.sender_name];
    //this.sender_thumb = json[MessageDocumentFieldName.sender_thumb];
    this.timestamp = json[MessageDocumentFieldName.timestamp];
    this.seen = json[MessageDocumentFieldName.seen];
    this.message_data = json[MessageDocumentFieldName.message_data];
    this.downloadable = json[MessageDocumentFieldName.downloadable];
    this.referred_message = json[MessageDocumentFieldName.referred_message];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[MessageDocumentFieldName.message_id] = this.message_id;
    data[MessageDocumentFieldName.message_text] = this.message_text;
    data[MessageDocumentFieldName.message_type] = this.message_type;
    data[MessageDocumentFieldName.sender_id] = this.sender_id;
    data[MessageDocumentFieldName.receiver_id] = this.receiver_id;
    //data[MessageDocumentFieldName.sender_name] = this.sender_name;
    //data[MessageDocumentFieldName.sender_thumb] = this.sender_thumb;
    data[MessageDocumentFieldName.timestamp] = this.timestamp;
    data[MessageDocumentFieldName.seen] = this.seen;
    data[MessageDocumentFieldName.message_data] = this.message_data;
    data[MessageDocumentFieldName.downloadable] = this.downloadable;
    data[MessageDocumentFieldName.referred_message] = this.referred_message;

    return data;
  }


}