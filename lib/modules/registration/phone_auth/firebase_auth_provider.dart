import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'auth_repository.dart';
import 'dart:async';



class FirebaseAuthProvider{

  static const String Verification_Id_Key = "verification_Id";
  static const String Verification_State_Key = "verification_state";
  static const String Verification_Exception_Key = "verification_exception";
  static const String Authenticated_Credential_Key = "authenticated_credential";


  // keys
  /*
  static String PhoneNumber_Map_Key = "phone_nnumber";
  static String VerificationId_Map_Key = "verification_id";
  static String SmsCode_Map_Key = "sms_code";
  static String VerificationState_Map_Key = "verification_state";
  */




  // Streams verification Id and Verification State
  static Future<void> verifyPhoneNumber({
    @required String phoneNumber,
    @required StreamSink<Map<String, dynamic>> verificationProcessSink,
  }) async {


    await FirebaseAuth.instance.verifyPhoneNumber(

      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),

      verificationCompleted: (AuthCredential authenticatedCredentials){

        verificationProcessSink.add({
          Verification_State_Key: PHONE_VERIFICATION_STATE.COMPLETE,
          Authenticated_Credential_Key: authenticatedCredentials
        });

      },

      verificationFailed: (AuthException exception){
        verificationProcessSink.add({
          Verification_State_Key: PHONE_VERIFICATION_STATE.FAILED,
          Verification_Exception_Key: exception.message
        });
      },

      codeSent: (String verificationId, [int forceResendCode]){
          verificationProcessSink.add({
            Verification_Id_Key: verificationId,
            Verification_State_Key : PHONE_VERIFICATION_STATE.SMSCODE_SENT
          });
        },

      codeAutoRetrievalTimeout: (String verificationId){

        // Auto retrieve has time out

        verificationProcessSink.add({
          Verification_Id_Key: verificationId,
          Verification_State_Key : PHONE_VERIFICATION_STATE.SMSCODE_SENT_AUTO_RETRIEVE_TIMEOUT
        });
      }
    ).then((_){

    }).catchError((error){

    });


  }


  static Future<FirebaseUser> signInWithPhoneNumber({@required String verificationId, @required String smsCode}) async{


    AuthCredential phoneSignInCredential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);

    return (await FirebaseAuth.instance.signInWithCredential(phoneSignInCredential)).user;

  }




}