import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';


/*
class MessageModel{

   String message;
   String type;
   List<dynamic> images;
   List<dynamic> images_thumbs;
   String sender_id;
   String receiver_id;
   String sender_name;
   String sender_thumb;
   String video;
   Timestamp timestamp;
   bool seen;



   MessageModel({
     this.message,
     @required this.type,
     this.images,
     this.images_thumbs,
     @required this.sender_id,
     @required this.receiver_id,
     this.sender_name,
     this.sender_thumb,
     this.video,
     @required this.timestamp,
     @required this.seen = false
});

   MessageModel.fromJson(Map<String, dynamic> json){

     this.message = json[MessagesDocumentFieldName.message];
     this.type = json[MessagesDocumentFieldName.type];
     this.images = json[MessagesDocumentFieldName.images];
     this.images_thumbs = json[MessagesDocumentFieldName.image_thumbs];
     this.sender_id = json[MessagesDocumentFieldName.sender_id];
     this.receiver_id = json[MessagesDocumentFieldName.receiver_id];
     this.sender_name = json[MessagesDocumentFieldName.sender_name];
     this.sender_thumb = json[MessagesDocumentFieldName.sender_thumb];
     this.video = json[MessagesDocumentFieldName.video];
     this.timestamp = json[MessagesDocumentFieldName.timestamp];
     this.seen = json[MessagesDocumentFieldName.seen];

   }


   Map<String, dynamic> toJson(){

     Map<String, dynamic> data = new Map<String, dynamic>();

     data[MessagesDocumentFieldName.message] = this.message;
     data[MessagesDocumentFieldName.type] = this.type;
     data[MessagesDocumentFieldName.images] = this.images;
     data[MessagesDocumentFieldName.image_thumbs] = this.images_thumbs;
     data[MessagesDocumentFieldName.sender_id] = this.sender_id;
     data[MessagesDocumentFieldName.receiver_id] = this.receiver_id;
     data[MessagesDocumentFieldName.sender_name] = this.sender_name;
     data[MessagesDocumentFieldName.sender_thumb] = this.sender_thumb;
     data[MessagesDocumentFieldName.video] = this.video;
     data[MessagesDocumentFieldName.timestamp] = this.timestamp;
     data[MessagesDocumentFieldName.seen] = this.seen;

     return data;
   }

  
}

*/