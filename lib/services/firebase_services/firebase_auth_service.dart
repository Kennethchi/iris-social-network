import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  static bool isUserSignedIn() {

    if (FirebaseAuth.instance.currentUser() != null){
      return true;
    }
    else
      return false;

  }

  /*
  static String getUserUid() {

    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      return user.uid;
    }).catchError((error){

      print(error);
      return null;
    });

  }

  static String getUserToken(){
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){

      user.getIdToken(
          refresh: true
      ).then((String token){

        return token;

      }).catchError((error){
        print(error);

        return null;
      });


    }).catchError((error){
      print(error);

      return null;
    });

  }

  static String getUserPhoneNumber(){

    FirebaseAuth.instance.currentUser().then((FirebaseUser user){

      return user.phoneNumber;

    }).catchError((error){
      print(error);

      return null;
    });

  }

  */




}