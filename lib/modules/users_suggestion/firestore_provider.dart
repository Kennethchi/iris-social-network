import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:iris_social_network/services/models/user_model.dart';




class FirestoreProvider{



  // Gets posts from firestore
  static Future<List<UserModel>> getSuggestedUsersData({
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  })async{


    QuerySnapshot querySnapshot;

    if (startAfterMap == null){

      querySnapshot = await Firestore.instance
          .collection(RootCollectionNames.users)
          .orderBy(UsersDocumentFieldNames.timestamp, descending: true)
          .limit(queryLimit)
          .getDocuments();
    }
    else{

      querySnapshot = await Firestore.instance
          .collection(RootCollectionNames.users)
          .orderBy(UsersDocumentFieldNames.timestamp, descending: true)
          .limit(queryLimit)
          .startAfter([startAfterMap[UsersDocumentFieldNames.timestamp]])
          .getDocuments();
    }


    List<UserModel> usersList = new List<UserModel>();

    if(querySnapshot != null && querySnapshot.documents != null){

      for (int index = 0; index < querySnapshot.documents.length; ++index){

        Map<String, dynamic> userMap = querySnapshot.documents[index].data;
        UserModel userModel = UserModel.fromJson(userMap);

        userModel.userId = querySnapshot.documents[index].reference.documentID;

        assert(userModel.userId != null, "Post Id from provider is showing null");


        // SKips hidden users
        if (app_constants.HiddenUsers.getHiddenUsersUsernamesList().contains(userModel.username)){
          continue;
        }

        usersList.add(userModel);
      }

    }

    return usersList;
  }




}