import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_dependency_injection.dart';
import 'auth_repository.dart';
import 'firebase_auth_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'auth_validators.dart';
import 'package:rxdart/rxdart.dart';



abstract class AuthBlocBlueprint{

  dispose();

  // Verifies phone number
  Future<void> verifyPhoneNumber({@required String fullPhoneNumber});

  // Sign in using the received smsCode
  Future<FirebaseUser> signInWithPhoneNumber({@required String smsCode});

  // Check if user is a new User
  // It checks whether user  has any data in firestore database using the user_id
  Future<bool> isNewUser({@required String userId});
}


class AuthBloc with AuthValidators implements AuthBlocBlueprint{




  static const String Iso_Code_Key = "iso_code";
  static const String Phone_Number_Key = "phone_number";


  // This is not being used. Some work needs to be done here
  String phoneNumber;
  String smsCode;



  // Streaming phone number
  BehaviorSubject<String> _phoneNumberBehaviorSubject = new BehaviorSubject<String>();
  Stream<String> get getPhoneNumberStream => _phoneNumberBehaviorSubject.stream.transform(phoneNumberValidator);
  StreamSink<String> get _addPhoneNumberSink => _phoneNumberBehaviorSubject.sink;



  // Streaming country iso code
  BehaviorSubject<String> _isoCodeBehaviorSubject = new BehaviorSubject<String>();
  Stream<String> get getIsoCodeStream => _isoCodeBehaviorSubject.stream;
  StreamSink<String> get _addIsoCodeSink => _isoCodeBehaviorSubject.sink;



  // Streaming valid phone number
  BehaviorSubject<Map<String, String>> _fullPhoneNumberBehaviorSubject = new BehaviorSubject<Map<String, String>>();
  Stream<Map<String, String>> get getFullPhoneNumberStream => _fullPhoneNumberBehaviorSubject.stream;
  StreamSink<Map<String, String>> get _addFullPhoneNumberSink => _fullPhoneNumberBehaviorSubject.sink;



  //Stream<bool> get submitCheck => Observable.combineLatest2(email, password, (e, p) => true);
  Stream<bool> get observePhoneNumberAndIsoCode => Observable.combineLatest2(getPhoneNumberStream, getIsoCodeStream, (String phoneNumber, String isoCode){
    Map<String, String> map = {
      Phone_Number_Key: phoneNumber,
      Iso_Code_Key: isoCode
    };
    addFullPhoneNumber(map);

    return true;
  });
  StreamSubscription<bool> _phoneNumberAndIsoCodeSubscription;




  BehaviorSubject<Map<String, dynamic>> _verificationProcessBehaviorSubject = new BehaviorSubject<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get getVerificationProcessStream => _verificationProcessBehaviorSubject.stream;
  Sink<Map<String, dynamic>> get _getVerificationProcessSink => _verificationProcessBehaviorSubject.sink;

  BehaviorSubject<String> _verificationIdStreamConroller = new BehaviorSubject<String>();
  Stream<String> get getVerificationIdStream => _verificationIdStreamConroller.stream;
  Sink<String> get _getVerificationIdSink => _verificationIdStreamConroller.sink;
  StreamSubscription<String> _verificationIdStreamSubscription;


  // Authentication Repository
  AuthRepository _authRepository;




  AuthBloc(){

    // Repository is initialised once in the app through the dependency injector
    _authRepository = AuthDependencyInjector().getAuthRepository;


    // listens to both isoCode and phone number
    _phoneNumberAndIsoCodeSubscription = observePhoneNumberAndIsoCode.listen((bool b){
      print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB:              ${b}");

    });


    // adds a default isoCode to the isoCode stream when bloc is initialised
    addIsoCode("ca");


    _verificationIdStreamSubscription = getVerificationIdStream.listen((String verificationId){
      this.setVerificationId = verificationId;
    });
  }



  void addPhoneNumber(String phoneNumber){
    _addPhoneNumberSink.add(phoneNumber);
  }


  void addIsoCode(String isoCode){
    _addIsoCodeSink.add(isoCode);
  }


  void addFullPhoneNumber(Map<String, String> fullPhoneNumberMap){
    _addFullPhoneNumberSink.add(fullPhoneNumberMap);
  }

 void addVerificationId(String verificationId){
    _getVerificationIdSink.add(verificationId);
  }






  @override
  Future<void> verifyPhoneNumber({@required String fullPhoneNumber}) async {
    await _authRepository.verifyPhoneNumber(phoneNumber: fullPhoneNumber, verificationProcessSink: _getVerificationProcessSink);
  }

  @override
  Future<FirebaseUser> signInWithPhoneNumber({@required String smsCode}) async {
    return await _authRepository.signInWithPhoneNumber(
        verificationId: this.getVerificationId,
        smsCode: smsCode
    );
  }


  @override
  Future<bool> isNewUser({@required String userId}) async {
    return await _authRepository.isNewUser(userId: userId);
  }

  @override
  dispose() {

    _phoneNumberAndIsoCodeSubscription?.cancel();
    _phoneNumberBehaviorSubject?.close();
    _isoCodeBehaviorSubject?.close();
    _fullPhoneNumberBehaviorSubject?.close();
    _verificationProcessBehaviorSubject?.close();
    _verificationIdStreamConroller?.close();

  }


  @override
  String _verificationId;

  String get getVerificationId => _verificationId;

  set setVerificationId(String verificationId) {
    _verificationId = verificationId;
  }


}





