import 'package:iris_social_network/services/optimised_models/optimised_comment_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:firebase_database/firebase_database.dart';





class RealtimeDatabaseProvider{


  /*
  static Future<List<OptimisedCommentModel>> getCommentsData({@required String videoid, @required int queryLimit})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.videos_comments)
        .child(videoid).orderByChild(CommentFieldNamesOptimised.t).limitToLast(queryLimit).once();

    Map<dynamic, dynamic> dataMap = dataSnapshot.value;


    List<OptimisedCommentModel> commentsList = List<OptimisedCommentModel>();


    for (int index = 0; index < dataMap.values.toList().length; ++index){

      Map<dynamic, dynamic> commentMap = dataMap.values.toList()[index];
      commentsList.add(OptimisedCommentModel.fromJson(commentMap));
    }


    return commentsList;
  }
  */



  // Gets all comments data from database with pagination
  static Future<List<OptimisedCommentModel>> getCommentsData({@required String postId, @required String postUserId, @required int queryLimit, @required int endAtValue})async{

    DataSnapshot dataSnapshots;


    if (endAtValue == null){

      // keeps the comments in synced
      // Note that if your billing is expensive for no reason, check this code and delete it
      await FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.posts_comments)
          .child(postUserId)
          .child(postId)
          .orderByChild(CommentFieldNamesOptimised.t)
          .limitToLast(queryLimit).keepSynced(true);

      dataSnapshots = await FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.posts_comments)
          .child(postUserId)
          .child(postId)
          .orderByChild(CommentFieldNamesOptimised.t)
          .limitToLast(queryLimit)
          .once();
    }
    else{

      dataSnapshots = await FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.posts_comments)
          .child(postUserId)
          .child(postId)
          .orderByChild(CommentFieldNamesOptimised.t)
          .limitToLast(queryLimit)
          .endAt(endAtValue)
          .once();
    }


    Map<dynamic, dynamic> dataMap = dataSnapshots.value;

    List<OptimisedCommentModel> commentsList = new List<OptimisedCommentModel>();

    if(dataMap != null){

      dataMap.forEach((key, value){

        Map<dynamic, dynamic> commentMap = dataMap[key];

        OptimisedCommentModel optimisedCommentModel = OptimisedCommentModel.fromJson(commentMap);
        optimisedCommentModel.id = key;

        commentsList.add(optimisedCommentModel);
      });

    }


    // sorts according to timestamp in optimised comment model
    commentsList.sort();


    return commentsList;
  }









  static Future<String>  addCommentData({@required OptimisedCommentModel optimisedCommentModel, @required String postUserId, @required String postId})async{

    DatabaseReference databaseReference = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts_comments)
        .child(postUserId)
        .child(postId)
        .push();


    await databaseReference.set(optimisedCommentModel.toJson()).then((_){

            DatabaseReference ref = FirebaseDatabase.instance.reference()
                .child(RootReferenceNames.posts)
                .child(postUserId)
                .child(postId)
                .child(PostFieldNamesOptimised.nC);


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


    return databaseReference.key;
  }


  static Future<void> deletePostComment({@required String postUserId, @required String postId, @required String commentId})async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts_comments)
        .child(postUserId)
        .child(postId)
        .child(commentId)
        .remove().then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.posts)
          .child(postUserId)
          .child(postId)
          .child(PostFieldNamesOptimised.nC);

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



  static Future<String> getCommentUserId({@required String postId, @required String postUserId,})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts).child(postUserId).child(postId).child(UsersFieldNamesOptimised.user_id).once();

    return dataSnapshot.value;
  }

  static Future<String> getCommentUserUserName({@required String commentUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(commentUserId).child(UsersFieldNamesOptimised.username).once();

    return dataSnapshot.value;
  }

  static Future<String> getCommentUserProfileName({@required String commentUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(commentUserId).child(UsersFieldNamesOptimised.name).once();

    return dataSnapshot.value;
  }

  static Future<String> getCommentUserProfileThumb({@required String commentUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(commentUserId).child(UsersFieldNamesOptimised.thumb).once();

    return dataSnapshot.value;
  }

  static Future<bool> getIsUserVerified({@required String commentUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(commentUserId).child(UsersFieldNamesOptimised.v_user).once();

    return dataSnapshot.value;
  }



}

















