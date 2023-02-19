import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'menu_validators.dart';
import 'menu_repository.dart';
import 'menu_dependency_injection.dart';


abstract class MenuBlocBlueprint{

  Future<void> sendFeedBack({@required String feedback});

  Future<void> sendBugReport({@required String bugReport});

  void dispose();
}


class MenuBloc with MenuValidators implements MenuBlocBlueprint{


  // message Text Stream Controller
  BehaviorSubject<String> _feedBackTextBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getFeedBackTextStream => _feedBackTextBehaviorSubject.stream.transform(textValidator);
  StreamSink<String> get _getFeedBackTextSink => _feedBackTextBehaviorSubject.sink;


  // message Text Stream Controller
  BehaviorSubject<String> _reportBugTextBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getReportBugTextStream => _reportBugTextBehaviorSubject.stream.transform(textValidator);
  StreamSink<String> get _getReportBugTextSink => _reportBugTextBehaviorSubject.sink;


  BehaviorSubject<bool> _appHasNewVersionUpdateBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getAppHasNewVersionUpdateStream => _appHasNewVersionUpdateBehaviorSubject.stream;
  StreamSink<bool> get _getAppHasNewVersionUpdateSink => _appHasNewVersionUpdateBehaviorSubject.sink;


  BehaviorSubject<String> _appVersionBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getAppVersionStream => _appVersionBehaviorSubject.stream;
  StreamSink<String> get _getAppVersionSink => _appVersionBehaviorSubject.sink;






  MenuRepository _menuRepository;

  MenuBloc(){

    _menuRepository = MenuDependencyInjector().getMenuRepository;
  }


  void addAppVersionToStream(String appVersion){
    _getAppVersionSink.add(appVersion);
  }

  void addAppHasNewVersionUpdateToStream(bool appHasNewVersionUpdate){
    _getAppHasNewVersionUpdateSink.add(appHasNewVersionUpdate);
  }

  void addFeedBackTextToStream({@required String feedBackText}) {
    _getFeedBackTextSink.add(feedBackText);
  }

  void addReportBugTextToStream({@required String reportBugText}) {
    _getReportBugTextSink.add(reportBugText);
  }


  @override
  Future<Function> sendFeedBack({@required String feedback})async {
    await _menuRepository.sendFeedBack(feedback: feedback);
  }

  @override
  Future<Function> sendBugReport({@required String bugReport})async{
    await _menuRepository.sendBugReport(bugReport: bugReport);
  }

  @override
  void dispose() {

    _feedBackTextBehaviorSubject?.close();
    _reportBugTextBehaviorSubject?.close();
    _appHasNewVersionUpdateBehaviorSubject?.close();
  }

}


