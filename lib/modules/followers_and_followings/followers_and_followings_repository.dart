import 'dart:async';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';




abstract class FollowersAndFollowingsRepository{

  Future<List<OptimisedFFModel>>  getProfileUserFollowers({@required String profileUserId, @required int queryLimit, @required String endAtKey});

  Future<List<OptimisedFFModel>>  getProfileUserFollowings({@required String profileUserId, @required int queryLimit, @required String endAtKey});

  Future<String> getFFProfileName({@required String userId});

  Future<String> getFFProfileThumb({@required String userId});

  Future<String> getFFUsername({@required String userId});

  Future<bool> getIsUserVerified({@required String userId});
}