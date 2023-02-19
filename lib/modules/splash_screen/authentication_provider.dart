import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';



class AuthenticationProvider{



  static Future<FacebookLoginResult> signInWithFacebook()async{

    FacebookLogin _facebookLogin = FacebookLogin();

    return await _facebookLogin.logInWithReadPermissions(["public_profile", "email"]);
  }







  static Future<FirebaseUser> signInWithGoogle() async{

    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

    AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );

    return (await FirebaseAuth.instance.signInWithCredential(authCredential)).user;
  }



}