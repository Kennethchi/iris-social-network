import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthProvider{


  static Future<FirebaseUser> getCurrentUser() async{
    return await FirebaseAuth.instance.currentUser();
  }


}