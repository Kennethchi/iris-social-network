import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';





class RealtimeDatabaseProvider{



  static Stream<Event> getIfUserLikedPostStream({@required String postId, @required String postUserId, @required String currentUserId}){

    return FirebaseDatabase.instance.reference().child(RootReferenceNames.posts_likes).child(postUserId).child(postId).child(currentUserId).onValue;
  }


  static Future<void> addPostLike({@required String postId, @required String postUserId, @required String currentUserId}) async{

    FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts_likes)
        .child(postUserId)
        .child(postId)
        .child(currentUserId)
        .set(true)
        .then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.posts)
          .child(postUserId)
          .child(postId)
          .child(PostFieldNamesOptimised.nL);


      ref.runTransaction((MutableData transactionData) async{
        //transactionData.value = (transactionData.value ?? 0) + 1;

        if (transactionData.value == null){
          transactionData.value = 1;
        }
        else if (transactionData.value < 0){
          transactionData.value = 1;
        }
        else{
          transactionData.value = transactionData.value + 1;
        }

        return await transactionData;
      });


    });


  }





  static Future<void> removePostLike({@required String postId, @required String postUserId, @required String currentUserId}) async{

    FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts_likes)
        .child(postUserId)
        .child(postId)
        .child(currentUserId)
        .remove()
        .then((_){


      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.posts)
          .child(postUserId)
          .child(postId)
          .child(PostFieldNamesOptimised.nL);

      ref.runTransaction((MutableData transactionData) async{

        if (transactionData.value == null){
          transactionData.value = 0;
        }
        else if (transactionData.value <= 0){
          transactionData.value = 0;
        }
        else{
          transactionData.value = transactionData.value - 1;
        }

        return await transactionData;
      });


    });


  }


  static Future<int> getNumberOfPostLikes({@required String postId, @required String postUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts)
        .child(postUserId)
        .child(postId)
        .child(PostFieldNamesOptimised.nL)
        .once();

    return dataSnapshot.value;
  }


  static Stream<Event> getNumberOfPostLikesStream({@required String postId, @required String postUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts)
        .child(postUserId)
        .child(postId)
        .child(PostFieldNamesOptimised.nL)
        .onValue;
  }


  static Future<int> getNumberOfPostComments({@required String postId, @required String postUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts)
        .child(postUserId)
        .child(postId)
        .child(PostFieldNamesOptimised.nC)
        .once();

    return dataSnapshot.value;
  }



  static Future<void> addPostVideoView({@required String postId, @required String postUserId}) async{

    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts)
        .child(postUserId)
        .child(postId)
        .child(PostFieldNamesOptimised.nV);


    ref.runTransaction((MutableData transactionData) async{
      //transactionData.value = (transactionData.value ?? 0) + 1;

      if (transactionData.value == null){
        transactionData.value = 1;
      }
      else if (transactionData.value < 0){
        transactionData.value = 1;
      }
      else{
        transactionData.value = transactionData.value + 1;
      }

      return await transactionData;
    });


  }



  static Future<int> getNumberOfPostVideoViews({@required String postId, @required String postUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts)
        .child(postUserId)
        .child(postId)
        .child(PostFieldNamesOptimised.nV)
        .once();

    return dataSnapshot.value;
  }



  static Future<void> addPostAudioListen({@required String postId, @required String postUserId}) async{

    DatabaseReference ref = FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts)
        .child(postUserId)
        .child(postId)
        .child(PostFieldNamesOptimised.nLis);


    ref.runTransaction((MutableData transactionData) async{
      //transactionData.value = (transactionData.value ?? 0) + 1;

      if (transactionData.value == null){
        transactionData.value = 1;
      }
      else if (transactionData.value < 0){
        transactionData.value = 1;
      }
      else{
        transactionData.value = transactionData.value + 1;
      }

      return await transactionData;
    });

  }



  static Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts)
        .child(postUserId)
        .child(postId)
        .child(PostFieldNamesOptimised.nLis)
        .once();

    return dataSnapshot.value;
  }



  static Stream<Event> checkIfCurrentUserFollowsPostUserStreamEvent({@required String currentUserId, @required postUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followers)
        .child(postUserId)
        .child(currentUserId)
        .onValue;
  }



  static Stream<Event> checkIfPostUserFollowsCurrentUserStreamEvent({@required String currentUserId, @required postUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followers)
        .child(currentUserId)
        .child(postUserId)
        .onValue;
  }



  static Future<void> addPostUserFollower({@required OptimisedFFModel optimisedFFModel, @required String postUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followers)
        .child(postUserId)
        .child(optimisedFFModel.user_id)
        .set(optimisedFFModel.toJson()).then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.users)
          .child(postUserId)
          .child(UsersFieldNamesOptimised.nFr);

      ref.runTransaction((MutableData transactionData) async{

        if (transactionData.value == null){
          transactionData.value = 1;
        }
        else if (transactionData.value < 0){
          transactionData.value = 1;
        }
        else{
          transactionData.value = transactionData.value + 1;
        }

        return await transactionData;
      });
    });

  }



  static Future<void> addCurrentUserFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followings)
        .child(currentUserId)
        .child(optimisedFFModel.user_id)
        .set(optimisedFFModel.toJson()).then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.users)
          .child(currentUserId)
          .child(UsersFieldNamesOptimised.nFg);

      ref.runTransaction((MutableData transactionData) async{

        if (transactionData.value == null){
          transactionData.value = 1;
        }
        else if (transactionData.value < 0){
          transactionData.value = 1;
        }
        else{
          transactionData.value = transactionData.value + 1;
        }

        return await transactionData;
      });
    });

  }



}