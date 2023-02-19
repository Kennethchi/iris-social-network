import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class PostModel{

  String postId;
  String postType;
  String postAudience;
  Map<dynamic, dynamic> postData;
  Timestamp timestamp;

  String userId;
  String userName;
  String userThumb;
  String userProfileName;

  String postCaption;

  bool verifiedUser;
  bool blockedPost;

  List<dynamic> friends;



  PostModel({
    this.postId,
    @required this.postType,
    @required this.postAudience,
    @required this.postData,
    @required this.postCaption,
    @required this.timestamp,

    @required this.userId,
    @required this.userName,
    @required this.userThumb,
    @required this.userProfileName,
    this.verifiedUser,
    List<dynamic> friendsIdsList
  }){

    if (this.friends == null){
      this.friends = List<dynamic>();
    }

    if (this.userId != null){
      // should be first element in the list
      this.friends.add(this.userId);
    }

    if (friendsIdsList != null){
      this.friends.addAll(friendsIdsList);
    }
  }


  PostModel.fromJson(Map<String, dynamic> json){

    this.postId = json[PostDocumentFieldName.post_id];
    this.userId = json[PostDocumentFieldName.user_id];
    this.postType = json[PostDocumentFieldName.post_type];
    this.postAudience = json[PostDocumentFieldName.post_audience];
    this.postData = json[PostDocumentFieldName.post_data];
    this.postCaption = json[PostDocumentFieldName.post_caption];
    this.timestamp = json[PostDocumentFieldName.timestamp];
    this.userName = json[PostDocumentFieldName.user_name];
    this.userThumb = json[PostDocumentFieldName.user_thumb];
    this.userProfileName = json[PostDocumentFieldName.user_profile_name];
    this.verifiedUser = json[PostDocumentFieldName.verified_user];
    this.blockedPost = json[PostDocumentFieldName.blocked_post];
    this.friends = json[PostDocumentFieldName.friends];
  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[PostDocumentFieldName.post_id] = this.postId;
    data[PostDocumentFieldName.user_id] = this.userId;
    data[PostDocumentFieldName.post_type] = this.postType;
    data[PostDocumentFieldName.post_audience] = this.postAudience;
    data[PostDocumentFieldName.post_data] = this.postData;
    data[PostDocumentFieldName.post_caption] = this.postCaption;
    data[PostDocumentFieldName.timestamp] = this.timestamp;
    data[PostDocumentFieldName.user_name] = this.userName;
    data[PostDocumentFieldName.user_thumb] = this.userThumb;
    data[PostDocumentFieldName.user_profile_name] = this.userProfileName;
    data[PostDocumentFieldName.verified_user] = this.verifiedUser;
    data[PostDocumentFieldName.blocked_post] = this.blockedPost;
    data[PostDocumentFieldName.friends] = this.friends;

    return data;
  }


}
