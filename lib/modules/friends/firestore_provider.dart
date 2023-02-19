import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/user_model.dart';


class FirestoreProvider{



  static Future<UserModel> getUserData({@required String userId}) async{

    DocumentSnapshot documentSnapshot =  await Firestore.instance.collection(RootCollectionNames.users).document(userId).get();

    if(documentSnapshot.exists){
      return UserModel.fromJson(documentSnapshot.data);
    }
    else{
      return null;
    }
  }


}