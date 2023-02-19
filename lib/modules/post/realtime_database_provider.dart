import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:iris_social_network/services/optimised_models/optimised_post_model.dart';





class RealtimeDatabaseProvider{

  static Future<void> addOptimisedPostData({@required OptimisedPostModel optimisedPostModel, @required String currentUserId, @required String postId})async{

    await FirebaseDatabase.instance.reference().child(
        RootReferenceNames.posts)
        .child(currentUserId)
        .child(postId)
        .set(optimisedPostModel.toJson());
  }



}