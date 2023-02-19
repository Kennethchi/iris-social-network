import 'dart:async';
import 'package:meta/meta.dart';
import 'menu_repository.dart';
import 'realtime_database_provider.dart';


class ProductionMenuRepository extends MenuRepository{


  @override
  Future<Function> sendFeedBack({@required String feedback})async {
    await RealtimeDatabaseProvider.sendFeedBack(feedback: feedback);
  }

  @override
  Future<Function> sendBugReport({@required String bugReport})async {
    await RealtimeDatabaseProvider.sendBugReport(bugReport: bugReport);
  }
}