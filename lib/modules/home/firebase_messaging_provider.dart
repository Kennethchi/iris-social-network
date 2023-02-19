import 'package:firebase_messaging/firebase_messaging.dart';


class FirebaseMessagingProvider{

  static Future<String> getFCMToken()async{
    return await FirebaseMessaging().getToken();
  }

}