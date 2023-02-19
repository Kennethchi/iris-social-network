import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';


class FirestoreProvider{


  // checks whether user data is found in database to identify if its a new user or not
  static Future<bool> isNewUser({@required String userId}) async{

    bool userExistsInDatabase = (await Firestore.instance.collection(RootCollectionNames.users).document(userId).get()).exists;

    if (userExistsInDatabase){
      return false;
    }

    return true;
  }



}