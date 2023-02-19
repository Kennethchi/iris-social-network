import 'package:iris_social_network/services/constants/constants.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';



class RealtimeDatabaseProvider{



  // Gets users notifications data from database with pagination
  static Future<List<OptimisedNotificationModel>> getUserNotifications({
    @required String currentUserId,
    @required String notificationType,
    @required int queryLimit,
    @required String endAtKey
  })async{


    DataSnapshot dataSnapshots;

    if (notificationType == null){
      if (endAtKey == null){

        await FirebaseDatabase.instance.reference()
            .child(RootReferenceNames.notifications)
            .child(currentUserId)
            .orderByChild(NotificationsFieldNamesOptimised.n_type)
            .limitToLast(queryLimit).keepSynced(true);

        dataSnapshots = await FirebaseDatabase.instance.reference()
            .child(RootReferenceNames.notifications)
            .child(currentUserId)
            .orderByChild(NotificationsFieldNamesOptimised.n_type)
            .limitToLast(queryLimit)
            .once();
      }
      else{

        dataSnapshots = await FirebaseDatabase.instance.reference()
            .child(RootReferenceNames.notifications)
            .child(currentUserId)
            .orderByChild(NotificationsFieldNamesOptimised.n_type)
            .limitToLast(queryLimit)
            .endAt(endAtKey)
            .once();
      }
    }
    else{
      if (endAtKey == null){

        dataSnapshots = await FirebaseDatabase.instance.reference()
            .child(RootReferenceNames.notifications)
            .child(currentUserId)
            .orderByChild(NotificationsFieldNamesOptimised.n_type)
            .limitToLast(queryLimit)
            .once();
      }
      else{

        dataSnapshots = await FirebaseDatabase.instance.reference()
            .child(RootReferenceNames.notifications)
            .child(currentUserId)
            .orderByChild(NotificationsFieldNamesOptimised.n_type)
            .limitToLast(queryLimit)
            .endAt(endAtKey)
            .once();
      }
    }



    Map<dynamic, dynamic> dataMap = dataSnapshots.value;

    List<OptimisedNotificationModel> notificationsList = new List<OptimisedNotificationModel>();


    if(dataMap != null){

      dataMap.forEach((key, value){

        Map<dynamic, dynamic> notificationMap = value;

        OptimisedNotificationModel optimisedNotificationModel = OptimisedNotificationModel.fromJson(notificationMap);
        optimisedNotificationModel.id = key;

        assert(optimisedNotificationModel.id != null, "User Notification key should not be null. Key is gotten after query data is retrieved from database");

        notificationsList.add(optimisedNotificationModel);
      });
    }


    // sorts disordered query data
    notificationsList.sort();

    return notificationsList;
  }





  static Future<String> getUserProfileName({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.name).once();

    return dataSnapshot.value;
  }

  static Future<String> getUserProfileThumb({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.thumb).once();

    return dataSnapshot.value;
  }

  static Future<String> getUserUsername({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.username).once();

    return dataSnapshot.value;
  }



  static Future<bool> getIsUserVerified({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.v_user).once();

    return dataSnapshot.value;
  }


  static Future<void> deleteNotification({@required String userId, @required String notificationId})async{

    await FirebaseDatabase.instance.reference().child(RootReferenceNames.notifications).child(userId).child(notificationId).remove();
  }




}



