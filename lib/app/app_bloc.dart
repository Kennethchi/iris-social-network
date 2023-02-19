import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/app_dependency_injection.dart';
import 'data/app_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;



abstract class AppBlocBlueprint{

  void dispose();

  Future<UserModel> getAllCurrentUserData({@required String currentUserId});

  Future<void> setCurrentUserOnlineStatus({@required String currentUserId, @required int onlineStatus, bool executeOnDisconnect});

  Future<void> updateUserDeviceToken({@required String currentUserId, @required String deviceToken});

  Future<bool> isNewUser({@required String userId});

  Future<bool> deleteAllFilesInModelData({@required dynamic dynamicModel});

  Future<dynamic>  increaseUserPoints({@required String userId, @required dynamic points});

  Future<dynamic>  decreaseUserPoints({@required String userId, @required dynamic points});

  Future<bool> saveAppThemeColorValue({@required int colorValue});

  Future<int> getSavedAppThemeColorValue();

  Future<File> getCachedNetworkFile({@required String urlPath});

  Future<int> getTotalAchievedPoints({@required String userId});

  Future<PostModel> getSinglePostData({@required String postId, @required String postUserId});
}




class AppBloc implements AppBlocBlueprint{


  // stream background image
  BehaviorSubject<String> _backgroundImageBehaviorSubject =  BehaviorSubject<String>();
  Stream<String> get getBackgroundImageStream => _backgroundImageBehaviorSubject.stream;
  StreamSink<String> get _getBackgroundImageSink => _backgroundImageBehaviorSubject.sink;

  // stream background color value
  BehaviorSubject<int> _backgroundColorValueBehaviorSubject =  BehaviorSubject<int>();
  Stream<int> get getBackgroundColorValueStream => _backgroundColorValueBehaviorSubject.stream;
  StreamSink<int> get _getBackgroundColorValueSink => _backgroundColorValueBehaviorSubject.sink;


  void addBackgroundImageToStream(String backgroundImage){
    _getBackgroundImageSink.add(backgroundImage);
  }


  void addBackgroundColorValueToStream(int backgroundColorValue){
    _getBackgroundColorValueSink.add(backgroundColorValue);
  }




  UserModel _currentUserData;
  UserModel get getCurrentUserData => _currentUserData;
  set setCurrentUserData(UserModel currentUserData) {
    _currentUserData = currentUserData;
  }


  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }


  bool _userConnectivity;
  bool get getUserConnectivity => _userConnectivity;
  set _setUserConnectivity(bool userConnectivity) {
    _userConnectivity = userConnectivity;
  }

  // Connectivity stream
  Stream<ConnectivityResult> get getConnectivityResultStream => Connectivity().onConnectivityChanged;
  StreamSubscription<ConnectivityResult>  _getConnectivityResultStreamSubscription;

  BehaviorSubject<bool> _hasInternetConnectionBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasInternetConnectionStream => _hasInternetConnectionBehaviorSubject.stream;
  StreamSink<bool> get _getHasInternetConnectionSink => _hasInternetConnectionBehaviorSubject.sink;

  StreamSubscription<DataConnectionStatus> _hasInternetConnectionStreamSubscription;


  BehaviorSubject<int> _appThemeColorValueBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getAppThemeColorValueStream => _appThemeColorValueBehaviorSubject.stream;
  StreamSink<int> get _getAppThemeColorValueSink => _appThemeColorValueBehaviorSubject.sink;


  BehaviorSubject<RewardPointsModel> _achievedRewardPointsModelBehaviorSubject = BehaviorSubject<RewardPointsModel>();
  Stream<RewardPointsModel> get getAchievedRewardPointsModelStream => _achievedRewardPointsModelBehaviorSubject.stream;
  StreamSink<RewardPointsModel> get _getAchievedRewardPointsModelSink => _achievedRewardPointsModelBehaviorSubject.sink;


  BehaviorSubject<bool> _isChristmasPeriodBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsChristmasPeriodStream => _isChristmasPeriodBehaviorSubject.stream;
  StreamSink<bool> get _getIsChristmasPeriodSink => _isChristmasPeriodBehaviorSubject.sink;


  // app dependency
  AppRepository _appRepository;

  AppBloc(){


    _appRepository = AppDependencyInjector().getAppRepository;

    // get user model from user firebase data
    getFirebaseUser().then((FirebaseUser user)async{

      if (user != null){

        
        /*********/
        /***** The below 3 lines of code will be null when user
         ***** is not logged in and can cause erros in the app
         ***** during the first loggin untill app has restarted *****/
        setCurrentUserId = user.uid;
        setCurrentUserData = await getAllCurrentUserData(currentUserId: user.uid);

        if (getCurrentUserData != null){
          addBackgroundImageToStream(getCurrentUserData.profileThumb);
        }


        setCurrentUserOnlineStatus(currentUserId: user.uid, onlineStatus: DateTime.now().millisecondsSinceEpoch, executeOnDisconnect: true);

        _getConnectivityResultStreamSubscription = getConnectivityResultStream.listen((ConnectivityResult connectivityResult){


          switch(connectivityResult){


            case ConnectivityResult.mobile:
              _setUserConnectivity = true;
              setCurrentUserOnlineStatus(currentUserId: user.uid, onlineStatus: 1);
              setCurrentUserOnlineStatus(currentUserId: user.uid, onlineStatus: DateTime.now().millisecondsSinceEpoch, executeOnDisconnect: true);

              print("Conectivity State: Mobile");

              break;

            case ConnectivityResult.wifi:
              _setUserConnectivity = true;
              setCurrentUserOnlineStatus(currentUserId: user.uid, onlineStatus: 1);
              setCurrentUserOnlineStatus(currentUserId: user.uid, onlineStatus: DateTime.now().millisecondsSinceEpoch, executeOnDisconnect: true);
              print("Conectivity State: Wifi");
              break;

            case ConnectivityResult.none:
              _setUserConnectivity = false;
              setCurrentUserOnlineStatus(currentUserId: user.uid, onlineStatus: DateTime.now().millisecondsSinceEpoch, executeOnDisconnect: true);
              print("Conectivity State: None");

              addHasInternetConnectionToStream(false);
              break;
          }
        });


        _hasInternetConnectionStreamSubscription = DataConnectionChecker()?.onStatusChange.listen((DataConnectionStatus status){


          switch (status) {
            case DataConnectionStatus.connected:
              print("Data Connection State: CONNECTED");
              addHasInternetConnectionToStream(true);


              setCurrentUserOnlineStatus(
                  currentUserId: user.uid, onlineStatus: 1);
              setCurrentUserOnlineStatus(
                  currentUserId: user.uid, onlineStatus: DateTime
                  .now()
                  .millisecondsSinceEpoch, executeOnDisconnect: true);


              break;

            case DataConnectionStatus.disconnected:
              print("Data Connection state: DISCONNECTED");
              addHasInternetConnectionToStream(false);


              setCurrentUserOnlineStatus(
                  currentUserId: user.uid,
                  onlineStatus: DateTime.now().millisecondsSinceEpoch
              );
              break;
          }

        });

      }


    });


  }





  bool getHasNewDayElapsed({@required int lastTimestampInMilliseconds}){

    DateTime dateTimeNow = DateTime.now();
    DateTime dateTimeLastSeen = DateTime.fromMillisecondsSinceEpoch(lastTimestampInMilliseconds);

    if (dateTimeNow.day == dateTimeLastSeen.day
        &&  dateTimeNow.month == dateTimeLastSeen.month
        && dateTimeNow.year == dateTimeLastSeen.year
    ){

      return false;
    }
    else if ((dateTimeNow.day  - dateTimeLastSeen.day) == 1
        &&  (dateTimeNow.month == dateTimeLastSeen.month
            || (dateTimeNow.month - dateTimeLastSeen.month) == 1
            || (dateTimeNow.month - dateTimeLastSeen.month) == -11
        )
        && dateTimeNow.year == dateTimeLastSeen.year
    ){
      return true;
    }
    else{
      return true;
    }
  }


  Future<void> setNewDayTimestampInMilliseconds()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(
        app_constants.SharedPrefsKeys.new_day_timestamp_in_milliseconds,
        DateTime.now().millisecondsSinceEpoch
    );
  }


  Future<int> getNewDayTimestampInMilliseconds()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getInt(app_constants.SharedPrefsKeys.new_day_timestamp_in_milliseconds,);
  }


  void addIschristmasPeriodToStream(bool isChristmasPeriod){
    _getIsChristmasPeriodSink.add(isChristmasPeriod);
  }

  void addAcheivedRewardPointsModelToStream(RewardPointsModel achievedRewardPointsModelToStream){
    _getAchievedRewardPointsModelSink.add(achievedRewardPointsModelToStream);
  }

  void addAppThemeColorValueToStream(int appThemeColorValue){
    _getAppThemeColorValueSink.add(appThemeColorValue);
  }

  void addHasInternetConnectionToStream(bool hasInternetConnection) {
    _getHasInternetConnectionSink.add(hasInternetConnection);
  }

  Future<FirebaseUser> getFirebaseUser() async{
    return await FirebaseAuth.instance.currentUser();
  }

  @override
  Future<UserModel> getAllCurrentUserData({@required String currentUserId})async {
    return await _appRepository.getAllCurrentUserData(currentUserId: currentUserId);
  }


  @override
  Future<void> setCurrentUserOnlineStatus({@required String currentUserId, @required int onlineStatus, bool executeOnDisconnect = false})async {
    await _appRepository.setCurrentUserOnlineStatus(currentUserId: currentUserId, onlineStatus: onlineStatus, executeOnDisconnect: executeOnDisconnect);
  }


  @override
  Future<Function> updateUserDeviceToken({@required String currentUserId, @required String deviceToken})async{
    await _appRepository.updateUserDeviceToken(currentUserId: currentUserId, deviceToken: deviceToken);
  }


  @override
  Future<bool> isNewUser({@required String userId})async {
    return await _appRepository.isNewUser(userId: userId);
  }


  @override
  Future<bool> deleteAllFilesInModelData({@required dynamic dynamicModel})async {
    return await _appRepository.deleteAllFilesInModelData(dynamicModel: dynamicModel);
  }


  @override
  Future<dynamic> increaseUserPoints({@required String userId, @required dynamic points})async {
    return await _appRepository.increaseUserPoints(userId: userId, points: points);
  }


  @override
  Future<dynamic> decreaseUserPoints({@required String userId, @required dynamic points})async{
    return await _appRepository.decreaseUserPoints(userId: userId, points: points);
  }

  @override
  Future<bool> saveAppThemeColorValue({@required int colorValue})async{
    return await _appRepository.saveAppThemeColorValue(colorValue: colorValue);
  }

  @override
  Future<int> getSavedAppThemeColorValue()async {
    return await _appRepository.getSavedAppThemeColorValue();
  }


  @override
  Future<File> getCachedNetworkFile({@required String urlPath})async {
    return await _appRepository.getCachedNetworkFile(urlPath: urlPath);
  }


  @override
  Future<int> getTotalAchievedPoints({@required String userId})async {
    return await _appRepository.getTotalAchievedPoints(userId: userId);
  }


  @override
  Future<PostModel> getSinglePostData({@required String postId, @required String postUserId})async {
    return await _appRepository.getSinglePostData(postId: postId, postUserId: postUserId);
  }

  @override
  void dispose() {

    _getConnectivityResultStreamSubscription?.cancel();
    _hasInternetConnectionStreamSubscription?.cancel();

    _hasInternetConnectionBehaviorSubject?.close();
  }



}