import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'phone_auth/phone_auth.dart';


class SignUp extends StatefulWidget{

  _SignUpState createState() => new _SignUpState();

}

class _SignUpState extends State<SignUp>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PhoneAuth();
  }

}



