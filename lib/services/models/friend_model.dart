import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/constants/constants.dart';

import 'user_model.dart';



class FriendModel implements Comparable<FriendModel>{

  UserModel userModel;


  String userId;
  int timestamp;

  FriendModel({

    @required this.userId,
    @required this.timestamp
  });


  FriendModel.fromJson(Map<dynamic, dynamic> json){

    this.userId = json[FriendMapFieldNames.user_id];
    this.timestamp = json[FriendMapFieldNames.timestamp];

  }

  Map<dynamic, dynamic> toJson(){

    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data[FriendMapFieldNames.user_id] = this.userId;
    data[FriendMapFieldNames.timestamp] = this.timestamp;

    return data;
  }




  @override
  int compareTo(FriendModel other) {
    // TODO: implement compareTo


    // sorts in descending order
    if (this.timestamp < other.timestamp){
      return 1;
    }
    else if (this.timestamp > other.timestamp){
      return -1;
    }
    else{
      return 0;
    }

  }



}



