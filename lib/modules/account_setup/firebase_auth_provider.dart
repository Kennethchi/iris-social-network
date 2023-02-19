import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/user_model.dart';

class FirebaseAuthProvider{

  static Future<UserModel> getCurrentFirebaseUserData() async{

    UserModel userModel = new UserModel();

    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    userModel.userId = firebaseUser.uid;
    userModel.username = firebaseUser.uid;
    userModel.profileName = firebaseUser.displayName;
    userModel.phoneNumber = firebaseUser.phoneNumber;
    userModel.deviceToken = (await firebaseUser.getIdToken()).token;
    userModel.profileImage = firebaseUser.photoUrl;
    userModel.profileThumb =  firebaseUser.photoUrl;

    return userModel;
  }

  static Future<FirebaseUser> getFirebaseUser() async{

    return await FirebaseAuth.instance.currentUser();
  }


}








