import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';



class RealtimeDatabaseProvider{


  /*
  static Future<bool> getFollowerStreamEvent({@required String currentUserId, @required profileUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followers)
        .child(profileUserId)
        .child(currentUserId)
        .child(FFFieldNames.d).onValue;

    /*
    if(dataSnapshot.value == null){
      return false;
    }
    else{
      return true;
    }
    */

  }
*/



  static Stream<Event> checkCurrentUserIsAFollowerStreamEvent({@required String currentUserId, @required profileUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followers)
        .child(profileUserId)
        .child(currentUserId)
        .onValue;
  }


  static Stream<Event> checkProfileUserIsCurrentUserFollowerStreamEvent({@required String currentUserId, @required profileUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followers)
        .child(currentUserId)
        .child(profileUserId)
        .onValue;
  }



  static Future<void> addProfileUserFollower({@required OptimisedFFModel optimisedFFModel, @required String profileUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followers)
        .child(profileUserId)
        .child(optimisedFFModel.user_id)
        .set(optimisedFFModel.toJson()).then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.users)
          .child(profileUserId)
          .child(UsersFieldNamesOptimised.nFr);

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



  static Future<void> removeProfileUserFollower({@required String currentUserId, @required String profileUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followers)
        .child(profileUserId)
        .child(currentUserId)
        .remove().then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.users)
          .child(profileUserId)
          .child(UsersFieldNamesOptimised.nFr);

      ref.runTransaction((MutableData transactionData) async{
        //transactionData.value = (transactionData.value ?? 0) - 1;

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



  static Future<void> removeCurrentUserFollowing({@required String profileUserId, @required String currentUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.followings)
        .child(currentUserId)
        .child(profileUserId)
        .remove().then((_){

      DatabaseReference ref = FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.users)
          .child(currentUserId)
          .child(UsersFieldNamesOptimised.nFg);

      ref.runTransaction((MutableData transactionData) async{
        //transactionData.value = (transactionData.value ?? 0) - 1;

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




  static Future<int> getNumberFollowers({@required String profileUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.users)
        .child(profileUserId)
        .child(UsersFieldNamesOptimised.nFr)
        .once();

    return dataSnapshot.value;
  }



  static Future<int> getNumberFollowings({@required String profileUserId}) async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.users)
        .child(profileUserId)
        .child(UsersFieldNamesOptimised.nFg).once();

    return dataSnapshot.value;
  }



  static Stream<Event> getNumberOfPostsStreamEvent({@required String profileUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.users)
        .child(profileUserId)
        .child(UsersFieldNamesOptimised.nP)
        .onValue;
  }


  static Future<int> getNumberOfPosts({@required String profileUserId}) async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.users)
        .child(profileUserId)
        .child(UsersFieldNamesOptimised.nP).once();

    return dataSnapshot.value;
  }





  static Future<void> removeOptimisedPostData({@required String postId, @required String currentUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts)
        .child(currentUserId)
        .child(postId)
        .remove();
  }


  static Future<void> removePostComments({@required String postId, @required String postUserId,})async{

    await FirebaseDatabase.instance.reference().child(RootReferenceNames.posts_comments).child(postUserId).child(postId).remove();
  }


  static Future<void> removePostLikes({@required String postId, @required String postUserId})async{

    await FirebaseDatabase.instance.reference().child(RootReferenceNames.posts_likes).child(postUserId).child(postId).remove();
  }





  static Stream<Event> checkCurrentUserSentFriendRequestToProfileUserStreamEvent({@required String currentUserId, @required profileUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.friend_requests)
        .child(profileUserId)
        .child(currentUserId)
        .onValue;
  }


  static Stream<Event> checkProfileUserSentFriendRequestToCurrentUserStreamEvent({@required String currentUserId, @required profileUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.friend_requests)
        .child(currentUserId)
        .child(profileUserId)
        .onValue;
  }



  static Future<void> sendFriendRequest({@required String currentUserId, @required String profileUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.friend_requests)
        .child(profileUserId)
        .child(currentUserId)
        .set(true);
  }



  static Future<void> removeFriendRequest({@required String currentUserId, @required String profileUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.friend_requests)
        .child(profileUserId)
        .child(currentUserId)
        .remove();
  }

  static Future<bool> checkIfUserSentFriendRequestNotification({@required String currentUserId, @required String profileUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.friend_requests)
        .child(profileUserId)
        .child(currentUserId)
        .orderByChild(NotificationsFieldNamesOptimised.n_type)
        .equalTo(NotificationType.friend_req).once();

    if (dataSnapshot.value == null){
      return false;
    }
    else{
      return true;
    }

  }


  static Future<void> removeFriendRequestNotification({@required String currentUserId, @required String profileUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.notifications)
        .child(profileUserId)
        .orderByChild(NotificationsFieldNamesOptimised.from)
        .equalTo(currentUserId)
        .limitToLast(20).once();

    Map<dynamic, dynamic> dataMap = dataSnapshot.value;
    if(dataMap != null){
      dataMap.forEach((key, value){

        OptimisedNotificationModel optimisedNotificationModel = OptimisedNotificationModel.fromJson(value);

        if (optimisedNotificationModel.n_type == NotificationType.friend_req){
          FirebaseDatabase.instance.reference()
              .child(RootReferenceNames.notifications)
              .child(profileUserId)
              .child(key)
              .remove();
        }

      });
    }

  }


  static Future<void> sendFriendRequestNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.notifications)
        .child(profileUserId)
        .push()
        .set(optimisedNotificationModel.toJson());
  }



  static Future<void> sendFriendRequestAcceptedNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.notifications)
        .child(profileUserId)
        .push()
        .set(optimisedNotificationModel.toJson());
  }




  static Future<int> getTotalAchievedPoints({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users)
        .child(userId)
        .child(UsersFieldNamesOptimised.pts).once();

    if (dataSnapshot != null && dataSnapshot.value != null){

      if (dataSnapshot.value < 0){
        return 0;
      }
      else{
        return dataSnapshot.value;
      }
    }

    return null;
  }
}



