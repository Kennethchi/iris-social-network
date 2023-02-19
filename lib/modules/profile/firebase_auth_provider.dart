import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthProvider{

  static Future<FirebaseUser> getFirebaseUser() async{
    return await FirebaseAuth.instance.currentUser();
  }

}