import 'dart:async';

import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreProvider{


  // checks whether user data exists in database and returns whether its a new user or nor
  static Future<bool> isNewUser({@required String userId}) async{

    bool userExitsInDatabase = (await Firestore.instance.collection(RootCollectionNames.users).document(userId).get()).exists;

    if (userExitsInDatabase){
      return false;
    }

    return true;
  }


  static Future<PostModel> getSinglePostData({@required String postId, @required String postUserId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection(RootCollectionNames.users)
        .document(postUserId)
        .collection(SubCollectionNames.user_posts)
        .document(postId).get();

    if (documentSnapshot.exists){
      PostModel postModel = PostModel.fromJson(documentSnapshot.data);
      postModel.postId = documentSnapshot.documentID;
      return postModel;
    }

    return null;
  }

}