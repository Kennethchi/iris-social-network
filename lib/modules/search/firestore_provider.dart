import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';




class FirestoreProvider{

  static Future<UserModel> getSearchUser({@required String searchUser})async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(RootCollectionNames.users)
        .where(UsersDocumentFieldNames.username, isEqualTo: searchUser.toLowerCase(),)
        .limit(1)
        .getDocuments();

    if (querySnapshot.documents.isEmpty){
      return null;
    }
    else{
      return UserModel.fromJson(querySnapshot.documents[0].data);
    }

  }



}