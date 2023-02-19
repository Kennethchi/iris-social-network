import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthProvider{

  static Future<FirebaseUser> getFirebaseCurrentUser() async{
    return await FirebaseAuth.instance.currentUser();
  }

}