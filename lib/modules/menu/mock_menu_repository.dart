import 'dart:async';
import 'package:meta/meta.dart';
import 'menu_repository.dart';


class MockMenuRepository extends MenuRepository{


  @override
  Future<Function> sendFeedBack({@required String feedback}) {

  }

  @override
  Future<Function> sendBugReport({@required String bugReport}) {

  }
}