import 'dart:async';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';



abstract class SettingsBlocBlueprint{

  void dispose();
}


class SettingsBloc implements SettingsBlocBlueprint{


  final int _TAP_VALUE = 1;
  final int MAX_TAP_VALUE = 50;


  BehaviorSubject<bool> _isPhoneAuthBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsPhoneAuthStream => _isPhoneAuthBehaviorSubject.stream;
  StreamSink<bool> get _getIsPhoneAuthSink => _isPhoneAuthBehaviorSubject.sink;

  BehaviorSubject<int> _monitoredTapCountBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getMonitoredTapCountStream => _monitoredTapCountBehaviorSubject.stream;
  StreamSink<int> get _getMonitoredTapCountPhoneAuthSink => _monitoredTapCountBehaviorSubject.sink;

  int _tapCount;
  int get getTapCount => _tapCount;
  set setTapCount(int tapCount) {
    _tapCount = tapCount;
  }


  SettingsBloc(){

    setTapCount = 0;

    getFirebaseUser().then((FirebaseUser fireBaseUser){

      if (fireBaseUser.phoneNumber.isNotEmpty){
        addIsPhoneAuthToStream(true);
        getMonitoredTapCountStream.listen((int tapCount){

          if (tapCount >= MAX_TAP_VALUE){
            addIsPhoneAuthToStream(false);
          }
        });
      }
      else{
        addIsPhoneAuthToStream(false);
      }
    });



  }

  void addMonitoredTapCountToStream(){

    setTapCount = getTapCount + _TAP_VALUE;

    _getMonitoredTapCountPhoneAuthSink.add(getTapCount);
  }

  void addIsPhoneAuthToStream(bool isPhoneAuth){
    _getIsPhoneAuthSink.add(isPhoneAuth);
  }

  Future<FirebaseUser> getFirebaseUser()async{
    return await FirebaseAuth.instance.currentUser();
  }


  @override
  void dispose() {

    _isPhoneAuthBehaviorSubject?.close();
    _monitoredTapCountBehaviorSubject?.close();
  }
}


