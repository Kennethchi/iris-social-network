import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';

import 'home_repository.dart';
import 'package:meta/meta.dart';
import 'firestore_provider.dart';
import 'firebase_messaging_provider.dart';
import 'realtime_database_provider.dart';



class ProductionHomeRepository extends HomeRepository{


  @override
  Future<bool> isNewUser({@required String userId}) async {
    return await FirestoreProvider.isNewUser(userId: userId);
  }

  @override
  Future<String> getFCMToken()async {
    return await FirebaseMessagingProvider.getFCMToken();
  }

  @override
  Future<Function> updateUserFCMToken({@required String currentUserId, @required String fcmToken})async {
    await RealtimeDatabaseProvider.updateUserFCMToken(currentUserId: currentUserId, fcmToken: fcmToken);
  }

  @override
  Future<PostModel> getSinglePostData({@required String postId, @required String postUserId})async {

    return FirestoreProvider.getSinglePostData(postId: postId, postUserId: postUserId);
  }


}