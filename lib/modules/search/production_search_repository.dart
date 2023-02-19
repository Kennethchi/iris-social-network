import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'search_repository.dart';
import 'firestore_provider.dart';


class ProductionSearchRepository extends SearchRepository{


  @override
  Future<UserModel> getSearchUser({@required String searchUser})async {

    return await FirestoreProvider.getSearchUser(searchUser: searchUser);
  }
}