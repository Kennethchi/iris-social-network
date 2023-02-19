import 'package:iris_social_network/services/optimised_models/optimised_post_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:firebase_database/firebase_database.dart';





class RealtimeDatabaseProvider{

  static Future<String> getPostUserUserName({@required String postUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(postUserId).child(UsersFieldNamesOptimised.username).once();

    return dataSnapshot.value;
  }

  static Future<String> getPostUserProfileName({@required String postUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(postUserId).child(UsersFieldNamesOptimised.name).once();

    return dataSnapshot.value;
  }

  static Future<String> getPostUserProfileThumb({@required String postUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(postUserId).child(UsersFieldNamesOptimised.thumb).once();

    return dataSnapshot.value;
  }


  static Future<bool> getIsPostUserVerified({@required String postUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(postUserId).child(UsersFieldNamesOptimised.v_user).once();

    return dataSnapshot.value;
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


  static Future<int> getNumberOfPostAudioListens({@required String postId, @required String postUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.posts)
        .child(postUserId)
        .child(postId)
        .child(PostFieldNamesOptimised.nLis)
        .once();

    return dataSnapshot.value;
  }



}

















