import 'package:meta/meta.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';



class RealtimeDatabaseProvider{


  // Gets users followers data from database with pagination
  static Future<List<OptimisedFFModel>> getProfileUserFollowers({@required String profileUserId, @required int queryLimit, @required String endAtKey})async{


    DataSnapshot dataSnapshots;

    if (endAtKey == null){

      dataSnapshots = await FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.followers)
          .child(profileUserId)
          .orderByKey()
          .limitToLast(queryLimit)
          .once();
    }
    else{

      dataSnapshots = await FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.followers)
          .child(profileUserId)
          .orderByKey()
          .limitToLast(queryLimit)
          .endAt(endAtKey)
          .once();
    }

    Map<dynamic, dynamic> dataMap = dataSnapshots.value;

    List<OptimisedFFModel> followersList = new List<OptimisedFFModel>();


    if(dataMap != null){

      dataMap.forEach((key, value){

        Map<dynamic, dynamic> followerMap = value;

        OptimisedFFModel optimisedFFModel = OptimisedFFModel.fromJson(followerMap);
        optimisedFFModel.id = key;

        assert(optimisedFFModel.id != null, "User Followers key should not be null. Key is gotten after query data is retrieved from database");

        followersList.add(optimisedFFModel);
      });
    }


    // sorts disordered query data
    followersList.sort();

    return followersList;
  }






  // Gets users followings data from database with pagination
  static Future<List<OptimisedFFModel>> getProfileUserFollowings({@required String profileUserId, @required int queryLimit, @required String endAtKey})async{


    DataSnapshot dataSnapshots;

    if (endAtKey == null){

      dataSnapshots = await FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.followings)
          .child(profileUserId)
          .orderByKey()
          .limitToLast(queryLimit)
          .once();
    }
    else{

      dataSnapshots = await FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.followings)
          .child(profileUserId)
          .orderByKey()
          .limitToLast(queryLimit)
          .endAt(endAtKey)
          .once();
    }



    Map<dynamic, dynamic> dataMap = dataSnapshots.value;


    List<OptimisedFFModel> followingsList = new List<OptimisedFFModel>();

    if(dataMap != null){

      dataMap.forEach((key, value){

        Map<dynamic, dynamic> followingsMap = value;

        OptimisedFFModel optimisedFFModel = OptimisedFFModel.fromJson(followingsMap);
        optimisedFFModel.id = key;

        assert(optimisedFFModel.id != null, "User Followings key should not be null. Key is gotten after query data is retrieved from database");

        followingsList.add(optimisedFFModel);
      });

    }


    // sorts disordered data
    followingsList.sort();


    return followingsList;
  }



  static Future<String> getFFProfileName({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.name).once();

    return dataSnapshot.value;
  }

  static Future<String> getFFProfileThumb({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.thumb).once();

    return dataSnapshot.value;
  }

  static Future<String> getFFUsername({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.username).once();

    return dataSnapshot.value;
  }



  static Future<bool> getIsUserVerified({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.v_user).once();

    return dataSnapshot.value;
  }







}



