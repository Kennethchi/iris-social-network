import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/constants/constants.dart';

import 'friend_model.dart';


const List<String> Talent_Types = [
  
];


class UserModel{

    String userId;
    String username;
    String phoneNumber;
    String phoneCode;
    String profileName;
    String genderType;
    String profileStatus;
    String profileImage;
    String profileThumb;
    String deviceToken;
    int numFollowers;
    int numFollowings;
    int numPosts;
    Timestamp timestamp;
    GeoPoint userLocation;
    bool verifiedUser;
    String fcmToken;
    int irisPoints;

    List<dynamic> blockedUsers;
    List<dynamic> blockedPosts;
    GeoPoint geoPoint;
    List<dynamic> friends;
    Timestamp birthday;

    bool receiveFriendrequest;
    bool showPublicPosts;

    String profileAudio;


  //  String language = "language";
  //  String search_key = "search_key";
  //  String setupComplete = "setup_complete";

  UserModel({
    this.userId,
    this.username,
    this.phoneNumber,
    this.phoneCode,
    this.profileName,
    this.genderType,
    this.profileStatus = "Welcome to Iris",
    this.profileImage,
    this.profileThumb,
    this.profileAudio,
    this.deviceToken,
    this.numFollowers = 0,
    this.numFollowings = 0,
    this.numPosts = 0,
    this.timestamp,
    this.userLocation,
    this.verifiedUser,
    this.fcmToken,
    this.irisPoints = 0,

    this.blockedUsers,
    this.blockedPosts,
    this.geoPoint,
    this.friends,
    this.birthday,

    this.receiveFriendrequest,
    this.showPublicPosts
  });
  
  
  UserModel.fromJson(Map<String, dynamic> json){

    this.userId = json[UsersDocumentFieldNames.user_id];
    this.username = json[UsersDocumentFieldNames.username];
    this.phoneNumber = json[UsersDocumentFieldNames.phone_number];
    this.phoneCode = json[UsersDocumentFieldNames.phone_code];
    this.profileName = json[UsersDocumentFieldNames.profile_name];
    this.genderType = json[UsersDocumentFieldNames.gender_type];
    this.profileStatus = json[UsersDocumentFieldNames.profile_status];
    this.profileImage = json[UsersDocumentFieldNames.profile_image];
    this.profileThumb = json[UsersDocumentFieldNames.profile_thumb];
    this.profileAudio = json[UsersDocumentFieldNames.profile_audio];
    this.deviceToken = json[UsersDocumentFieldNames.device_token];
    this.numFollowers = json[UsersDocumentFieldNames.num_followers];
    this.numFollowings = json[UsersDocumentFieldNames.num_followings];
    this.numPosts = json[UsersDocumentFieldNames.num_posts];
    this.userLocation = json[UsersDocumentFieldNames.user_location];
    this.timestamp = json[UsersDocumentFieldNames.timestamp];
    this.verifiedUser = json[UsersDocumentFieldNames.verified_user];
    this.fcmToken = json[UsersDocumentFieldNames.fcm_token];
    this.irisPoints = json[UsersDocumentFieldNames.iris_points];

    this.blockedUsers = json[UsersDocumentFieldNames.blocked_users];
    this.blockedPosts = json[UsersDocumentFieldNames.blocked_posts];
    this.geoPoint = json[UsersDocumentFieldNames.geo_point];
    this.friends = json[UsersDocumentFieldNames.friends];
    this.birthday = json[UsersDocumentFieldNames.birthday];
    this.receiveFriendrequest = json[UsersDocumentFieldNames.receive_friendrequest];
    this.showPublicPosts = json[UsersDocumentFieldNames.show_public_posts];
  }

  Map<String, dynamic> toJson(){

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[UsersDocumentFieldNames.user_id] = this.userId;
    data[UsersDocumentFieldNames.username] = this.username;
    data[UsersDocumentFieldNames.phone_number] = this.phoneNumber;
    data[UsersDocumentFieldNames.phone_code] = this.phoneCode;
    data[UsersDocumentFieldNames.profile_name] = this.profileName;
    data[UsersDocumentFieldNames.gender_type] = this.genderType;
    data[UsersDocumentFieldNames.profile_status] = this.profileStatus;
    data[UsersDocumentFieldNames.profile_image] = this.profileImage;
    data[UsersDocumentFieldNames.profile_thumb] = this.profileThumb;
    data[UsersDocumentFieldNames.profile_audio] = this.profileAudio;
    data[UsersDocumentFieldNames.device_token] = this.deviceToken;
    data[UsersDocumentFieldNames.num_followers] = this.numFollowers;
    data[UsersDocumentFieldNames.num_followings] = this.numFollowings;
    data[UsersDocumentFieldNames.num_posts] = this.numPosts;
    data[UsersDocumentFieldNames.user_location] = this.userLocation;
    data[UsersDocumentFieldNames.timestamp] = this.timestamp;
    data[UsersDocumentFieldNames.verified_user] = this.verifiedUser;
    data[UsersDocumentFieldNames.fcm_token] = this.fcmToken;
    data[UsersDocumentFieldNames.iris_points] = this.irisPoints;

    data[UsersDocumentFieldNames.blocked_users] = this.blockedUsers;
    data[UsersDocumentFieldNames.blocked_posts] = this.blockedPosts;
    data[UsersDocumentFieldNames.geo_point] = this.geoPoint;
    data[UsersDocumentFieldNames.friends] = this.friends;
    data[UsersDocumentFieldNames.birthday] = this.birthday;
    data[UsersDocumentFieldNames.receive_friendrequest] = this.receiveFriendrequest;
    data[UsersDocumentFieldNames.show_public_posts] = this.showPublicPosts;

    return data;
  }




  List<String> getAllCurrentUserFriendsIdsList(){

    if (this.friends != null){

      List<String> friendsIdsList = List<String>();

      for (int index = 0; index < this.friends.length; ++index){

        Map<dynamic, dynamic> dataMap = this.friends[index];
        FriendModel friendModel = FriendModel.fromJson(dataMap);

        if (friendModel.userId != null){
          friendsIdsList.add(friendModel.userId);
        }
      }

      return friendsIdsList;
    }
    else{

      return List<String>();
    }

  }





    List<FriendModel> getAllCurrentUserFriendModel(){

      if (this.friends != null){

        List<FriendModel> friendsModelList = List<FriendModel>();

        for (int index = 0; index < this.friends.length; ++index){

          Map<dynamic, dynamic> dataMap = this.friends[index];
          FriendModel friendModel = FriendModel.fromJson(dataMap);

          if (friendModel.userId != null){
            friendsModelList.add(friendModel);
          }
        }

        return friendsModelList;
      }
      else{

        return List<FriendModel>();
      }

    }
}



