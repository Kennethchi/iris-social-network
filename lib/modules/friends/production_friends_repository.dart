import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'friends_repository.dart';
import 'firestore_provider.dart';


class ProductionFriendsRepository extends FriendsRepository{


  @override
  Future<UserModel> getUserData({@required String userId})async {

    return await FirestoreProvider.getUserData(userId: userId);
  }
}



