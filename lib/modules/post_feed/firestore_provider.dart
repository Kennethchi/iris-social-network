import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;




class FirestoreProvider{



  // Gets posts from firestore
  static Future<List<PostModel>> getPostsData({
    @required postType = null,
    @required app_constants.POST_QUERY_TYPE postQueryType = app_constants.POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  })async{


    QuerySnapshot querySnapshot;


    if (postQueryType == app_constants.POST_QUERY_TYPE.MOST_RECENT){

      if (postType == null){
        if (startAfterMap == null){

          querySnapshot = await Firestore.instance
              .collectionGroup(SubCollectionNames.user_posts)
              .orderBy(PostDocumentFieldName.timestamp, descending: true)
              .where(PostDocumentFieldName.post_audience, isEqualTo: app_constants.PostAudience.public)
              .limit(queryLimit)
              .getDocuments();
        }
        else{

          querySnapshot = await Firestore.instance
              .collectionGroup(SubCollectionNames.user_posts)
              .orderBy(PostDocumentFieldName.timestamp, descending: true)
              .where(PostDocumentFieldName.post_audience, isEqualTo: app_constants.PostAudience.public)
              .limit(queryLimit)
              .startAfter([startAfterMap[PostDocumentFieldName.timestamp]])
              .getDocuments();
        }
      }
      else{
        if (startAfterMap == null){

          querySnapshot = await Firestore.instance
              .collectionGroup(SubCollectionNames.user_posts)
              .orderBy(PostDocumentFieldName.timestamp, descending: true)
              .where(PostDocumentFieldName.post_type, isEqualTo: postType)
              .where(PostDocumentFieldName.post_audience, isEqualTo: app_constants.PostAudience.public)
              .limit(queryLimit)
              .getDocuments();
        }
        else{

          querySnapshot = await Firestore.instance
              .collectionGroup(SubCollectionNames.user_posts)
              .orderBy(PostDocumentFieldName.timestamp, descending: true)
              .where(PostDocumentFieldName.post_type, isEqualTo: postType)
              .where(PostDocumentFieldName.post_audience, isEqualTo: app_constants.PostAudience.public)
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











/*

  // Gets posts from firestore
  static Future<List<PostModel>> getPostsData({
    @required postType = null,
    @required app_constants.POST_QUERY_TYPE postQueryType = app_constants.POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap
  })async{


    QuerySnapshot querySnapshot;


    if (postQueryType == app_constants.POST_QUERY_TYPE.MOST_RECENT){

        if (postType == null){
            if (startAfterMap == null){

              querySnapshot = await Firestore.instance
                  .collection(RootCollectionNames.posts)
                  .orderBy(PostDocumentFieldName.timestamp, descending: true)
                  .where(PostDocumentFieldName.post_audience, isEqualTo: app_constants.PostAudience.public)
                  .limit(queryLimit)
                  .getDocuments();
            }
            else{

              querySnapshot = await Firestore.instance
                  .collection(RootCollectionNames.posts)
                  .orderBy(PostDocumentFieldName.timestamp, descending: true)
                  .where(PostDocumentFieldName.post_audience, isEqualTo: app_constants.PostAudience.public)
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
                  .where(PostDocumentFieldName.post_type, isEqualTo: postType)
                  .where(PostDocumentFieldName.post_audience, isEqualTo: app_constants.PostAudience.public)
                  .limit(queryLimit)
                  .getDocuments();
            }
            else{

              querySnapshot = await Firestore.instance
                  .collection(RootCollectionNames.posts)
                  .orderBy(PostDocumentFieldName.timestamp, descending: true)
                  .where(PostDocumentFieldName.post_type, isEqualTo: postType)
                  .where(PostDocumentFieldName.post_audience, isEqualTo: app_constants.PostAudience.public)
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


  */



}