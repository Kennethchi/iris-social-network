import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';

class ChatModel{
  
   String chat_user_id;
   String name;
  // String profile_image = "profile_image";
   String thumb;
   String phone_num;
   String sender_id;
   Timestamp timestamp;
   bool images;
   bool video;
   String message;
   bool seen;
   String type;

  


   ChatModel({
     @required this.chat_user_id,
     this.name,
     this.thumb,
     this.phone_num,
     @required this.sender_id,
     @required this.timestamp,
     this.images,
     this.video,
     this.message,
     @required this.type,
     @required this.seen
});


  ChatModel.fromJson(Map<String, dynamic> json){

     this.chat_user_id = json[ChatsDocumentFieldName.chat_user_id];
     this.name = json[ChatsDocumentFieldName.name];
     this.thumb = json[ChatsDocumentFieldName.thumb];
     this.phone_num = json[ChatsDocumentFieldName.phone_num];
     this.sender_id = json[ChatsDocumentFieldName.sender_id];
     this.timestamp = json[ChatsDocumentFieldName.timestamp];
     this.images = json[ChatsDocumentFieldName.images];
     this.video = json[ChatsDocumentFieldName.video];
     this.message = json[ChatsDocumentFieldName.message];
     this.type = json[ChatsDocumentFieldName.m_type];
     this.seen =  json[ChatsDocumentFieldName.seen];

  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[ChatsDocumentFieldName.chat_user_id] = this.chat_user_id;
    data[ChatsDocumentFieldName.name] = this.name;
    data[ChatsDocumentFieldName.thumb] = this.thumb;
    data[ChatsDocumentFieldName.phone_num] = this.phone_num;
    data[ChatsDocumentFieldName.sender_id] = this.sender_id;
    data[ChatsDocumentFieldName.timestamp] = this.timestamp;
    data[ChatsDocumentFieldName.images] = this.images;
    data[ChatsDocumentFieldName.video] = this.video;
    data[ChatsDocumentFieldName.message] = this.message;
    data[ChatsDocumentFieldName.m_type] = this.type;
    data[ChatsDocumentFieldName.seen] = this.seen;

    return data;
  }



}