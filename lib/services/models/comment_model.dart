import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';

class CommentModel{

   String userProfileName;
   String userProfileImage;
   String comment;
   String timestamp;


   CommentModel({
     this.userProfileName,
     this.userProfileImage,
     this.comment,
     this.timestamp
});


   CommentModel fromJson(Map<String, dynamic> json){

     this.userProfileName = json[CommentsDocumentFieldName.user_profile_name];
     this.userProfileImage = json[CommentsDocumentFieldName.user_profile_name];
     this.comment = json[CommentsDocumentFieldName.comment];
     this.timestamp = json[CommentsDocumentFieldName.timestamp];

   }


   Map<String, dynamic> toJson(){

     Map<String, dynamic> data = new Map<String, dynamic>();
     data[CommentsDocumentFieldName.user_profile_name] = this.userProfileName;
     data[CommentsDocumentFieldName.user_profile_image] = this.userProfileImage;
     data[CommentsDocumentFieldName.comment] = this.comment;
     data[CommentsDocumentFieldName.timestamp] = this.timestamp;

     return data;
   }


}