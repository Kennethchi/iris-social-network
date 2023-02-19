import 'auth_repository.dart';
import 'firebase_auth_provider.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_provider.dart';

class ProductionAuthRepository implements AuthRepository{


  @override
  Future<void> verifyPhoneNumber({@required String phoneNumber, Sink<Map<String, dynamic>> verificationProcessSink}) async {

    return await FirebaseAuthProvider.verifyPhoneNumber(phoneNumber: phoneNumber, verificationProcessSink: verificationProcessSink);

  }



  @override
  Future<FirebaseUser> signInWithPhoneNumber({@required String verificationId, @required String smsCode}) async {

    return await FirebaseAuthProvider.signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode);

  }

  @override
  Future<bool> isNewUser({@required String userId}) async {
    return await FirestoreProvider.isNewUser(userId: userId);
  }


}





