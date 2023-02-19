import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';




class FirestoreProvider{

  static Future<void> addUserProfileData(UserModel userModel, String userId) async{

    await Firestore.instance.collection(RootCollectionNames.users).document(userId).setData(userModel.toJson());
  }

  static Future<bool> checkIfUserDataExists({@required String userId})async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(RootCollectionNames.users)
        .where(UsersDocumentFieldNames.user_id, isEqualTo: userId)
        .limit(1)
        .getDocuments();

    if (querySnapshot.documents.isEmpty){
      return false;
    }
    else{
      return true;
    }
  }


}


