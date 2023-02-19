import 'dart:async';
import 'package:meta/meta.dart';
import 'followers_and_followings_repository.dart';
import 'realtime_database_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';



class ProductionFollowersAndFollowingsRepository extends FollowersAndFollowingsRepository{


  @override
  Future<List<OptimisedFFModel>> getProfileUserFollowers({@required String profileUserId, @required int queryLimit, @required String endAtKey})async {

    return await RealtimeDatabaseProvider.getProfileUserFollowers(profileUserId: profileUserId, queryLimit: queryLimit, endAtKey: endAtKey);
  }

  @override
  Future<List<OptimisedFFModel>> getProfileUserFollowings({@required String profileUserId, @required int queryLimit, @required String endAtKey})async {

    return await RealtimeDatabaseProvider.getProfileUserFollowings(profileUserId: profileUserId, queryLimit: queryLimit, endAtKey: endAtKey);
  }

  @override
  Future<String> getFFProfileName({@required String userId})async{

    return await RealtimeDatabaseProvider.getFFProfileName(userId: userId);
  }

  @override
  Future<String> getFFProfileThumb({@required String userId})async {

    return await RealtimeDatabaseProvider.getFFProfileThumb(userId: userId);
  }

  @override
  Future<String> getFFUsername({@required String userId})async {

    return await RealtimeDatabaseProvider.getFFUsername(userId: userId);
  }

  @override
  Future<bool> getIsUserVerified({@required String userId})async {
    return await RealtimeDatabaseProvider.getIsUserVerified(userId: userId);
  }


}