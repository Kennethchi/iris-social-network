import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'users_suggestion_repository.dart';



class UsersSuggestionMockRepository extends UsersSuggestionRepository{


  @override
  Future<List<UserModel>> getSuggestedUsersData({@required int queryLimit, @required Map<String, dynamic> startAfterMap}) {

  }
}