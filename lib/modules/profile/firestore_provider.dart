import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';



class FirestoreProvider{




  static Future<UserModel> getProfileUserData({@required String profileUserId}) async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(RootCollectionNames.users).document(profileUserId).get();

    if (documentSnapshot.data != null){
      return UserModel.fromJson(documentSnapshot.data);
    }
    else{
      return null;
    }
  }

  /*

  static Future<Map<String, dynamic>> getProfileUserData({@required String profileUserId}) async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(RootCollectionNames.users).document(profileUserId).get();

    return documentSnapshot.data;
  }
  */



  // Gets posts from firestore
  static Future<List<PostModel>> getProfileUserPostsData({
    @required String profileUserId,
    @required postType = null,
    @required String postAudience,
    @required POST_QUERY_TYPE postQueryType = POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  })async{


    QuerySnapshot querySnapshot;




    if (postQueryType == POST_QUERY_TYPE.MOST_RECENT){

      if (postAudience == PostAudience.private){

        if (postType == null){

          if (startAfterMap == null){

            querySnapshot = await Firestore.instance
                .collection(RootCollectionNames.users)
                .document(profileUserId)
                .collection(SubCollectionNames.user_posts)
                .orderBy(PostDocumentFieldName.timestamp, descending: true)
                .limit(queryLimit)
                .getDocuments();
          }
          else{

            querySnapshot = await Firestore.instance
                .collection(RootCollectionNames.users)
                .document(profileUserId)
                .collection(SubCollectionNames.user_posts)
                .orderBy(PostDocumentFieldName.timestamp, descending: true)
                .limit(queryLimit)
                .startAfter([startAfterMap[PostDocumentFieldName.timestamp]])
                .getDocuments();
          }
        }
        else{
          if (startAfterMap == null){

            querySnapshot = await Firestore.instance
                .collection(RootCollectionNames.users)
                .document(profileUserId)
                .collection(SubCollectionNames.user_posts)
                .orderBy(PostDocumentFieldName.timestamp, descending: true)
                .where(PostDocumentFieldName.post_type, isEqualTo: postType)
                .limit(queryLimit)
                .getDocuments();
          }
          else{

            querySnapshot = await Firestore.instance
                .collection(RootCollectionNames.users)
                .document(profileUserId)
                .collection(SubCollectionNames.user_posts)
                .orderBy(PostDocumentFieldName.timestamp, descending: true)
                .where(PostDocumentFieldName.post_type, isEqualTo: postType)
                .limit(queryLimit)
                .startAfter([startAfterMap[PostDocumentFieldName.timestamp]])
                .getDocuments();
          }
        }

      }
      else{

        if (postType == null){

          if (startAfterMap == null){

            querySnapshot = await Firestore.instance
                .collection(RootCollectionNames.users)
                .document(profileUserId)
                .collection(SubCollectionNames.user_posts)
                .orderBy(PostDocumentFieldName.timestamp, descending: true)
                .where(PostDocumentFieldName.post_audience, isEqualTo: PostAudience.public)
                .limit(queryLimit)
                .getDocuments();
          }
          else{

            querySnapshot = await Firestore.instance
                .collection(RootCollectionNames.users)
                .document(profileUserId)
                .collection(SubCollectionNames.user_posts)
                .orderBy(PostDocumentFieldName.timestamp, descending: true)
                .where(PostDocumentFieldName.post_audience, isEqualTo: PostAudience.public)
                .limit(queryLimit)
                .startAfter([startAfterMap[PostDocumentFieldName.timestamp]])
                .getDocuments();
          }
        }
        else{
          if (startAfterMap == null){

            querySnapshot = await Firestore.instance
                .collection(RootCollectionNames.users)
                .document(profileUserId)
                .collection(SubCollectionNames.user_posts)
                .orderBy(PostDocumentFieldName.timestamp, descending: true)
                .where(PostDocumentFieldName.post_audience, isEqualTo: PostAudience.public)
                .where(PostDocumentFieldName.post_type, isEqualTo: postType)
                .limit(queryLimit)
                .getDocuments();
          }
          else{

            querySnapshot = await Firestore.instance
                .collection(RootCollectionNames.users)
                .document(profileUserId)
                .collection(SubCollectionNames.user_posts)
                .orderBy(PostDocumentFieldName.timestamp, descending: true)
                .where(PostDocumentFieldName.post_audience, isEqualTo: PostAudience.public)
                .where(PostDocumentFieldName.post_type, isEqualTo: postType)
                .limit(queryLimit)
                .startAfter([startAfterMap[PostDocumentFieldName.timestamp]])
                .getDocuments();
          }
        }

      }

    }
    else{
      return List<PostModel>();
    }


    List<PostModel> postsList = new List<PostModel>();

    if(querySnapshot != null && querySnapshot.documents != null){

      for (int index = 0; index < querySnapshot.documents.length; ++index){

        Map<String, dynamic> postMap = querySnapshot.documents[index].data;
        PostModel postModel = PostModel.fromJson(postMap);

        postModel.postId = querySnapshot.documents[index].reference.documentID;


        assert(postModel.postId != null, "Post Id from provider is showing null");

        postsList.add(postModel);

      }

    }


    return postsList;
  }







  /**

  // Gets posts from firestore
  static Future<List<PostModel>> getProfileUserPostsData({


    @required String profileUserId,
    @required postType = null,
    @required POST_QUERY_TYPE postQueryType = POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  })async{


    QuerySnapshot querySnapshot;


    if (postQueryType == POST_QUERY_TYPE.MOST_RECENT){


      if (postType == null){

        if (startAfterMap == null){

          querySnapshot = await Firestore.instance
              .collection(RootCollectionNames.posts)
              .orderBy(PostDocumentFieldName.timestamp, descending: true)
              .where(PostDocumentFieldName.user_id, isEqualTo: profileUserId)
              .limit(queryLimit)
              .getDocuments();
        }
        else{

          querySnapshot = await Firestore.instance
              .collection(RootCollectionNames.posts)
              .orderBy(PostDocumentFieldName.timestamp, descending: true)
              .where(PostDocumentFieldName.user_id, isEqualTo: profileUserId)
              .limit(queryLimit)
              .startAfter([startAfterMap[PostDocumentFieldName.timestamp]])
              .getDocuments();
        }
      }
      else{
        if (startAfterMap == null){

          querySnapshot = await Firestore.instance
              .collection(RootCollectionNames.posts)
              .orderBy(PostDocumentFieldName.timestamp, descending: true)
              .where(PostDocumentFieldName.user_id, isEqualTo: profileUserId)
              .where(PostDocumentFieldName.post_type, isEqualTo: postType)
              .limit(queryLimit)
              .getDocuments();
        }
        else{

          querySnapshot = await Firestore.instance
              .collection(RootCollectionNames.posts)
              .orderBy(PostDocumentFieldName.timestamp, descending: true)
              .where(PostDocumentFieldName.user_id, isEqualTo: profileUserId)
              .where(PostDocumentFieldName.post_type, isEqualTo: postType)
              .limit(queryLimit)
              .startAfter([startAfterMap[PostDocumentFieldName.timestamp]])
              .getDocuments();
        }
      }

    }
    else{
      return List<PostModel>();
    }


    List<PostModel> postsList = new List<PostModel>();

    if(querySnapshot != null && querySnapshot.documents != null){

      for (int index = 0; index < querySnapshot.documents.length; ++index){

        Map<String, dynamic> postMap = querySnapshot.documents[index].data;
        PostModel postModel = PostModel.fromJson(postMap);

        postModel.postId = querySnapshot.documents[index].reference.documentID;


        assert(postModel.postId != null, "Post Id from provider is showing null");

        postsList.add(postModel);

      }

    }


    return postsList;
  }
  **/


  static Future<void> removePostData({@required String postId, @required String currentUserId}) async{

    await Firestore.instance.collection(RootCollectionNames.users).document(currentUserId).collection(SubCollectionNames.user_posts).document(postId).delete();
  }



  static Future<void> addFriendToUserFriendList({@required FriendModel friendModel, @required String userId})async{

    DocumentReference documentReference = Firestore.instance.collection(RootCollectionNames.users).document(userId);


    documentReference.firestore.runTransaction((Transaction transaction)async{

      await transaction.update(documentReference, {UsersDocumentFieldNames.friends: FieldValue.arrayUnion([friendModel.toJson()])});
    });
  }

}








