import 'dart:async';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_provider.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';



abstract class BlocBlueprint{

  Future<FirebaseUser> signInWithGoogle();

  //Future<FacebookLoginResult> signInWithFacebook();

  void dispose();
}


class SplashBloc implements BlocBlueprint{



  SplashBloc(){


  }



  Future<FirebaseUser> signInWithGoogle()async{
    return await AuthenticationProvider.signInWithGoogle();
  }



  Future<FacebookLoginResult> signInWithFacebook()async{
    return await AuthenticationProvider.signInWithFacebook();
  }



  @override
  void dispose() {

  }
}


