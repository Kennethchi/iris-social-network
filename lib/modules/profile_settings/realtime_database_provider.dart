import 'dart:async';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';



class RealtimeDatabaseProvider{


  static Future<void> updateOptimisedUserData({@required String userId, @required Map<String, dynamic> updataDataMap})async{

    await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).update(updataDataMap);
  }


}