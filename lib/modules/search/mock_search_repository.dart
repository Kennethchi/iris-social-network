import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'search_repository.dart';


class MockSearchRepository extends SearchRepository{


  @override
  Future<UserModel> getSearchUser({@required String searchUser}) {

  }
}