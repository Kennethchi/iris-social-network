import 'package:meta/meta.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';


class RealtimeDatabaseProvider{

  static Future<void> setCurrentUserOnlineStatus({@required String currentUserId, @required int onlineStatus, bool executeOnDisconnect = false})async{


    if (executeOnDisconnect == null || executeOnDisconnect == false){
      await FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.users)
          .child(currentUserId)
          .child(UsersFieldNamesOptimised.o)
          .set(onlineStatus);

      return;
    }

    else if (executeOnDisconnect){
      await FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.users)
          .child(currentUserId)
          .child(UsersFieldNamesOptimised.o)
          .onDisconnect()
          .set(onlineStatus);

      return;
    }


    /*
    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.users)
        .child(currentUserId)
        .child(UsersFieldNamesOptimised.o)
        .set(onlineStatus);
        */

  }





  static Future<dynamic> increaseUserPoints({@required String userId, @required dynamic points})async{

    DatabaseReference databaseReference = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.users)
        .child(userId)
        .child(UsersFieldNamesOptimised.pts);

    TransactionResult transactionResult = await databaseReference.runTransaction((MutableData transactionData) async{

      if (transactionData.value == null){
        transactionData.value = points;
      }
      else if (transactionData.value < 0){
        transactionData.value = points;
      }
      else{
        transactionData.value = transactionData.value + points;
      }

      return transactionData;
    });

    return transactionResult.dataSnapshot.value;
  }




  static Future<dynamic>  decreaseUserPoints({@required String userId, @required dynamic points})async{

    DatabaseReference databaseReference = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.users)
        .child(userId)
        .child(UsersFieldNamesOptimised.pts);

    TransactionResult transactionResult = await databaseReference.runTransaction((MutableData transactionData) async{
      if (transactionData.value == null){
        transactionData.value = points;
      }
      else if (transactionData.value <= 0){
        transactionData.value = points;
      }
      else{
        transactionData.value = transactionData.value - points;
      }

      return transactionData;
    });

    return transactionResult.dataSnapshot.value;
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