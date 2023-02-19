import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';




class FirestoreProvider{


  static Future<UserModel> getProfileUserData({@required String profileUserId}) async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(RootCollectionNames.users).document(profileUserId).get();

    return UserModel.fromJson(documentSnapshot.data);
  }


  static Future<void> updateProfileSettings({@required String currentUserId, @required Map<String, dynamic> currentUserUpdateData})async{

    await Firestore.instance.collection(RootCollectionNames.users).document(currentUserId).updateData(currentUserUpdateData);
  }




}









