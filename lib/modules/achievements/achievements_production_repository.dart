import 'dart:async';
import 'package:meta/meta.dart';
import 'achievements_repository.dart';
import 'realtime_database_provider.dart';


class AchievementsProductionRepository extends AchievementsRepository{


  @override
  Future<int> getTotalAchievedPoints({@required String userId})async {

    return await RealtimeDatabaseProvider.getTotalAchievedPoints(userId: userId);
  }
}