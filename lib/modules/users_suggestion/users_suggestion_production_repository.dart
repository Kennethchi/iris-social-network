import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'users_suggestion_repository.dart';
import 'firestore_provider.dart';


class UsersSuggestionProductionRepository extends UsersSuggestionRepository{


  @override
  Future<List<UserModel>> getSuggestedUsersData({@required int queryLimit, @required Map<String, dynamic> startAfterMap})async {

    return await FirestoreProvider.getSuggestedUsersData(queryLimit: queryLimit, startAfterMap: startAfterMap);
  }
}




