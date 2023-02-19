import 'dart:async';
import 'package:meta/meta.dart';


abstract class MenuRepository{

  Future<void> sendFeedBack({@required String feedback});

  Future<void> sendBugReport({@required String bugReport});

}