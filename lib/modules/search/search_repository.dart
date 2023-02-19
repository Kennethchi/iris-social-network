import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';


abstract class SearchRepository{

  Future<UserModel> getSearchUser({@required String searchUser});

}