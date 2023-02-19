import 'dart:async';
import 'package:meta/meta.dart';
import 'followers_and_followings_repository.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';



class MockFollowersAndFollowingsRepository extends FollowersAndFollowingsRepository{

  @override
  Future<List<OptimisedFFModel>> getProfileUserFollowers(
      {@required String profileUserId, @required int queryLimit, @required String endAtKey}) {

  }

  @override
  Future<bool> getIsUserVerified({@required String userId}) {

  }

  @override
  Future<String> getFFUsername({@required String userId}) {

  }

  @override
  Future<String> getFFProfileThumb({@required String userId}) {

  }

  @override
  Future<String> getFFProfileName({@required String userId}) {

  }

  @override
  Future<List<OptimisedFFModel>> getProfileUserFollowings(
      {@required String profileUserId, @required int queryLimit, @required String endAtKey}) {

  }
}
