import 'dart:async';
import 'package:meta/meta.dart';


abstract class AchievementsRepository{

  Future<int> getTotalAchievedPoints({@required String userId});
}