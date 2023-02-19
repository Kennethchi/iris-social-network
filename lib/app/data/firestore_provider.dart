import 'package:iris_social_network/services/models/post_model.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';


class FirestoreProvider{

  static Future<UserModel> getAllCurrentUserData({@required String currentUserId}) async{

    DocumentSnapshot documentSnapshot =  await Firestore.instance.collection(RootCollectionNames.users).document(currentUserId).get();

    if (documentSnapshot != null && documentSnapshot.exists){
      return UserModel.fromJson(documentSnapshot.data);
    }
    else{
      return null;
    }
  }


  static Future<void> updateUserDeviceToken({@required String currentUserId, @required String deviceToken}) async{

    await Firestore.instance.collection(RootCollectionNames.users).document(currentUserId).updateData({

      UsersDocumentFieldNames.device_token: deviceToken
    });

  }


  // checks whether user data is found in database to identify if its a new user or not
  static Future<bool> isNewUser({@required String userId}) async{

    bool userExistsInDatabase = (await Firestore.instance.collection(RootCollectionNames.users).document(userId).get()).exists;

    if (userExistsInDatabase){
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