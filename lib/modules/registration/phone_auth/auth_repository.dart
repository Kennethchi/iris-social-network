import 'dart:async';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';


enum PHONE_VERIFICATION_STATE{
  NONE,
  COMPLETE,
  FAILED,
  SMSCODE_SENT,
  SMSCODE_SENT_AUTO_RETRIEVE_TIMEOUT
}


abstract class AuthRepository{


  static const String Verification_Id_Key = "verification_Id";
  static const String Verification_State = "verification_state";


  Future<void> verifyPhoneNumber({@required String phoneNumber, @required StreamSink<Map<String, dynamic>> verificationProcessSink});

  Future<FirebaseUser> signInWithPhoneNumber({@required String verificationId, @required String smsCode});

  Future<bool> isNewUser({@required String userId});

}



