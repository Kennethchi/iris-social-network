import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';


abstract class UsersSuggestionRepository{

  Future<List<UserModel>> getSuggestedUsersData({@required int queryLimit, @required Map<String, dynamic> startAfterMap});

}