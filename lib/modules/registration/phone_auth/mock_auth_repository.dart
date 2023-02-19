import 'auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';



class MockAuthRepository implements AuthRepository{


  @override
  Future<FirebaseUser> signInWithPhoneNumber({@required String verificationId, @required String smsCode}) {

  }

  @override
  Future<Map<String, dynamic>> verifyPhoneNumber(
      {@required String phoneNumber, @required StreamSink<
          Map<String, dynamic>> verificationProcessSink}) {

  }

  @override
  Future<bool> isNewUser({@required String userId}) {

  }


}
