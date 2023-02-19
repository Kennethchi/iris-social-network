import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/services/models/post_model.dart';



class FirestoreProvider{


  static Future<String> addPostData({@required PostModel postModel, @required String currentUserId}) async{


    DocumentReference reference = await  Firestore.instance
        .collection(RootCollectionNames.users)
        .document(currentUserId)
        .collection(SubCollectionNames.user_posts)
        .document();


    await reference.setData(postModel.toJson());

    return reference.documentID;
  }



  /*
  static Future<String> addPostData({@required PostModel postModel, @required String currentUserId}) async{

    DocumentReference reference = await  Firestore.instance
        .collection(RootCollectionNames.posts)
        .document();

    await reference.setData(postModel.toJson());

    return reference.documentID;
  }
  */





}








