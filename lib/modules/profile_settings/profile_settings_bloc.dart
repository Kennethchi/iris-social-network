import 'dart:async';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'package:rxdart/rxdart.dart';
import 'profile_settings_repository.dart';
import 'profile_settings_dependency_injection.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'profile_settings_validator.dart';




abstract class ProfileSettingsBlocBlueprint{

  Future<UserModel> getProfileUserData({@required String profileUserId});

  Future<void> updateProfileSettings({@required String currentUserId, @required Map<String, dynamic> currentUserUpdateData});

  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink});

  Future<void> updateOptimisedUserData({@required String userId, @required Map<String, dynamic> updataDataMap});

  Future<bool> saveAppThemeColorValue({@required int colorValue});

  Future<int> getSavedAppThemeColorValue();

  void dispose();
}


class ProfileSettingsBloc with ProfileSettingsValidators implements ProfileSettingsBlocBlueprint{


  // progress data
  BehaviorSubject<int> _progressTransferDataBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getProgressTransferDataStream => _progressTransferDataBehaviorSubject.stream;
  StreamSink<int> get getProgressTransferDataSink => _progressTransferDataBehaviorSubject.sink;

  void addProgressTransferDataToStream(int progressTransferData){
    getProgressTransferDataSink.add(progressTransferData);
  }

  // total bytes to be transfered streaming
  BehaviorSubject<int> _totalTransferDataBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getTotalTransferDataStream => _totalTransferDataBehaviorSubject.stream;
  StreamSink<int> get getTotalTransferDataSink => _totalTransferDataBehaviorSubject.sink;

  void addTotalTransferDataToStream(int totalTransferData){
    getTotalTransferDataSink.add(totalTransferData);
  }






  // user data to uodate in firestore
  Map<String, dynamic> _currentUpdateDataMap;
  Map<String, dynamic> get getCurrentUpdateDataMap => _currentUpdateDataMap;
  set setCurrentUpdateDataMap(Map<String, dynamic> currentUpdateDataMap) {
    _currentUpdateDataMap = currentUpdateDataMap;
  }

  // user data to update in realtime database
  Map<String, dynamic> _optimisedUserDataMap;
  Map<String, dynamic> get getOptimisedUserDataMap => _optimisedUserDataMap;
  set setOptimisedUserDataMap(Map<String, dynamic> optimisedUserDataMap) {
    _optimisedUserDataMap = optimisedUserDataMap;
  }

  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }


  int _appThemeColorValue;
  int get getAppThemeColorValue => _appThemeColorValue;
  set setAppThemeColorValue(int appThemeColorValue) {
    _appThemeColorValue = appThemeColorValue;
  }


  BehaviorSubject<UserModel> _userModelBehaviorSubject = BehaviorSubject<UserModel>();
  Stream<UserModel> get getUserModelStream => _userModelBehaviorSubject.stream;
  Sink<UserModel> get _getUserModelSink => _userModelBehaviorSubject.sink;
  StreamSubscription<UserModel> getUserModelStreamSubscription;


  // profile image
  BehaviorSubject<String> _profileImageBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getProfileImageStream => _profileImageBehaviorSubject.stream;
  Sink<String> get _getProfileImageSink => _profileImageBehaviorSubject.sink;

  // profile name
  BehaviorSubject<String> _profileNameBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getProfileNameStream => _profileNameBehaviorSubject.stream;
  Sink<String> get _getProfileNameSink => _profileNameBehaviorSubject.sink;


  // username
  BehaviorSubject<String> _userNameBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getUserNameStream => _userNameBehaviorSubject.stream;
  Sink<String> get _getUserNameSink => _userNameBehaviorSubject.sink;


  // profile status
  BehaviorSubject<String> _profileStatusBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getProfileStatusStream => _profileStatusBehaviorSubject.stream;
  Sink<String> get _getProfileStatusSink => _profileStatusBehaviorSubject.sink;


  // gender type
  BehaviorSubject<String> _genderTypeBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getGenderTypeStream => _genderTypeBehaviorSubject.stream;
  Sink<String> get _getGenderTypeSink => _genderTypeBehaviorSubject.sink;

  // receive friend request
  BehaviorSubject<bool> _receiveFriendRequestBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getReceiveFriendRequestStream => _receiveFriendRequestBehaviorSubject.stream;
  Sink<bool> get _getReceiveFriendRequestSink => _receiveFriendRequestBehaviorSubject.sink;



  // receive friend request
  BehaviorSubject<bool> _showPublicPostsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getShowPublicPostsStream => _showPublicPostsBehaviorSubject.stream;
  Sink<bool> get _getShowPublicPostsSink => _showPublicPostsBehaviorSubject.sink;



  // settings modified
  BehaviorSubject<bool> _profileSettingsChangedBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getProfileSettingsChangedStream => _profileSettingsChangedBehaviorSubject.stream;
  StreamSink<bool> get _getProfileSettingsChangedSink => _profileSettingsChangedBehaviorSubject.sink;

  // settings modified
  BehaviorSubject<String> _profileImageChangedBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getProfileImageChangedStream => _profileImageChangedBehaviorSubject.stream;
  StreamSink<String> get _getProfileImageChangedSink => _profileImageChangedBehaviorSubject.sink;


  // percent ratio progress stream
  BehaviorSubject<double> _percentRatioProgressBehaviorSubject = BehaviorSubject<double>();
  Stream<double> get getPercentRatioProgressStream => _percentRatioProgressBehaviorSubject.stream;
  StreamSink<double> get _getPercentRatioProgressSink => _percentRatioProgressBehaviorSubject.sink;



  // profile name text input stream
  BehaviorSubject<String> _profileNameTextBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getProfileNameTextStream => _profileNameTextBehaviorSubject.stream.transform(textValidator);
  Sink<String> get _getProfileNameTextSink => _profileNameTextBehaviorSubject.sink;


  // profile status text input stream
  BehaviorSubject<String> _profileStatusTextBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getProfileStatusTextStream => _profileStatusTextBehaviorSubject.stream.transform(textValidator);
  Sink<String> get _getProfileStatusTextSink => _profileStatusTextBehaviorSubject.sink;


  BehaviorSubject<int> _appThemeColorValueBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getAppThemeColorValueStream => _appThemeColorValueBehaviorSubject.stream;
  StreamSink<int> get _getAppThemeColorValueSink => _appThemeColorValueBehaviorSubject.sink;


  // profile image
  BehaviorSubject<String> _profileAudioBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getProfileAudioStream => _profileAudioBehaviorSubject.stream;
  Sink<String> get _getProfileAudioSink => _profileAudioBehaviorSubject.sink;


  // Stream subscription for observing latest combination of ongoing progress transfer and total transfer
  StreamSubscription<double> _observeCombineLatestProgressAndTotalTransfer;


  BehaviorSubject<RewardPointsModel> _achievedRewardPointsModelBehaviorSubject = BehaviorSubject<RewardPointsModel>();
  Stream<RewardPointsModel> get getAchievedRewardPointsModelStream => _achievedRewardPointsModelBehaviorSubject.stream;
  StreamSink<RewardPointsModel> get _getAchievedRewardPointsModelSink => _achievedRewardPointsModelBehaviorSubject.sink;




  ProfileSettingsRepository _profileSettingsRepository;


  ProfileSettingsBloc({@required currentUserId}){

    _profileSettingsRepository = ProfileSettingsDependencyInjector().getProfileSettingsRepository;


    getProfileUserData(profileUserId: currentUserId).then((UserModel userModel){

      if (userModel != null){

        setCurrentUserModel = userModel;

        addProfileImageToStream(userModel.profileImage);
        addProfileNameToStream(userModel.profileName);
        addUsernameToStream(userModel.username);
        addProfileStatusToStream(userModel.profileStatus);
        addGenderTypeToStream(userModel.genderType);
        addReceiveFriendRequestToStream(userModel.receiveFriendrequest);
        addShowPublicPostsToStream(userModel.showPublicPosts);
        //addProfileAudioToStream(userModel.profileAudio);
      }
    });

    addProfileSettingsChangedToStream(false);




    // initialises update data map for firestore
    setCurrentUpdateDataMap = Map<String, dynamic>();
    // initialises update data map for realtime database
    setOptimisedUserDataMap = Map<String, dynamic>();



    // Listens to Profile Name stream and adds to update data map
    getProfileNameStream.listen((String profileName){
      setupProfileNameUpdateData(profileName);
    });
    // Listens to Profile Status stream and adds to update data map
    getProfileStatusStream.listen((String profileStatus){
      setupProfileStatusUpdateData(profileStatus);
    });
    // Listens to GenderType stream and adds to update data map
    getGenderTypeStream.listen((String genderType){
      setupGenderTypeUpdateData(genderType);
    });
    // Listens to Profile Image stream and adds to update data map
    getProfileImageChangedStream.listen((String profileImage){
      setupProfileImageUpdateData(profileImage);
      addProfileSettingsChangedToStream(true);
    });
    getReceiveFriendRequestStream.listen((bool receiveFriendrequest){
      setupReceiveFriendRequestUpdateData(receiveFriendrequest);
    });
    getShowPublicPostsStream.listen((bool showPublicPosts){
      setupShowPublicPostsUpdateData(showPublicPosts);
    });



    _observeCombineLatestProgressAndTotalTransfer = Observable.combineLatest2(getProgressTransferDataStream, getTotalTransferDataStream, (int progressTransfer, int totalTransfer){

      print("Sent: $progressTransfer, total: $totalTransfer");

      return progressTransfer / totalTransfer;
    }).listen((double percentProgressRatio){
      addPercentRatioProgress(percentProgressRatio);
    });


    getSavedAppThemeColorValue().then((int colorValue){
      addAppThemeColorValueToStream(colorValue);
    });
  }




  void addAcheivedRewardPointsModelToStream(RewardPointsModel achievedRewardPointsModelToStream){
    _getAchievedRewardPointsModelSink.add(achievedRewardPointsModelToStream);
  }


  void addProfileNameTextToStream(String profileNameText){
    _getProfileNameTextSink.add(profileNameText);
  }

  void addProfileStatusTextToStream(String profileStatusText){
    _getProfileStatusTextSink.add(profileStatusText);
  }


  void setupProfileAudioUpdateData(String profileAudio){
    this.getCurrentUpdateDataMap[UsersDocumentFieldNames.profile_audio] = profileAudio;
  }

  void setupReceiveFriendRequestUpdateData(bool receiveFriendRequest){
    this.getCurrentUpdateDataMap[UsersDocumentFieldNames.receive_friendrequest] = receiveFriendRequest;
    this.getOptimisedUserDataMap[UsersFieldNamesOptimised.receive_friendreq] = receiveFriendRequest;
  }


  void setupShowPublicPostsUpdateData(bool showPublicPosts){
    this.getCurrentUpdateDataMap[UsersDocumentFieldNames.show_public_posts] = showPublicPosts;
  }


  void setupProfileNameUpdateData(String profileName){

    this.getCurrentUpdateDataMap[UsersDocumentFieldNames.profile_name] = profileName;

    // this value here in the realtime database can be used in cloud functions without having unessesary reads in firestore
    this.getOptimisedUserDataMap[UsersFieldNamesOptimised.name] = profileName;
  }
  void setupProfileStatusUpdateData(String profileStatus){

    this.getCurrentUpdateDataMap[UsersDocumentFieldNames.profile_status] = profileStatus;
  }
  void setupGenderTypeUpdateData(String genderType){

    this.getCurrentUpdateDataMap[UsersDocumentFieldNames.gender_type] = genderType;
  }
  void setupProfileImageUpdateData(String profileImage){

    this.getCurrentUpdateDataMap[UsersDocumentFieldNames.profile_image] = profileImage;
  }
  void setupProfileThumbUpdateData(String profileThumb){

    this.getCurrentUpdateDataMap[UsersDocumentFieldNames.profile_thumb] = profileThumb;

    // this value here in the realtime database can be used in cloud functions without having unessesary reads in firestore
    this.getOptimisedUserDataMap[UsersFieldNamesOptimised.thumb] = profileThumb;
  }




  void addProfileAudioToStream(String profileAudio){
    _getProfileAudioSink.add(profileAudio);
  }

  void addAppThemeColorValueToStream(int appThemeColorValue){
    _getAppThemeColorValueSink.add(appThemeColorValue);
  }

  void addShowPublicPostsToStream(bool showPublicPosts){
    _getShowPublicPostsSink.add(showPublicPosts);
  }

  void addReceiveFriendRequestToStream(bool receiveFriendRequest){
    _getReceiveFriendRequestSink.add(receiveFriendRequest);
  }

  void addPercentRatioProgress(double percentRatioProgress){
    _getPercentRatioProgressSink.add(percentRatioProgress);
  }

  void addProfileImageChangedToStream(String profileImageChanged){

    _getProfileImageChangedSink.add(profileImageChanged);
  }

  void addProfileSettingsChangedToStream(bool profileSettingsChanged){

    _getProfileSettingsChangedSink.add(profileSettingsChanged);
  }

  void addUserModelToStream(UserModel userModel){
    _getUserModelSink.add(userModel);
  }

  void addProfileImageToStream(String profileImage){
    _getProfileImageSink.add(profileImage);
  }

  void addProfileNameToStream(String profileName){
    _getProfileNameSink.add(profileName);
  }

  void addUsernameToStream(String username){
    _getUserNameSink.add(username);
  }

  void addProfileStatusToStream(String profileStatus){
    _getProfileStatusSink.add(profileStatus);
  }

  void addGenderTypeToStream(String genderType){
    _getGenderTypeSink.add(genderType);
  }



  @override
  Future<UserModel> getProfileUserData({@required String profileUserId}) async {
    return _profileSettingsRepository.getProfileUserData(profileUserId: profileUserId);
  }


  @override
  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {
    return await _profileSettingsRepository.uploadFile(sourceFile: sourceFile, filename: filename, progressSink: progressSink, totalSink: totalSink);
  }


  // Updates user data in firestore
  @override
  Future<Function> updateProfileSettings({@required String currentUserId, @required Map<String, dynamic> currentUserUpdateData})async {
    await _profileSettingsRepository.updateProfileSettings(currentUserId: currentUserId, currentUserUpdateData: currentUserUpdateData);
  }


  // updates user data in realtime database
  @override
  Future<Function> updateOptimisedUserData({@required String userId, @required Map<String, dynamic> updataDataMap})async {
    await _profileSettingsRepository.updateOptimisedUserData(userId: userId, updataDataMap: updataDataMap);
  }


  @override
  Future<bool> saveAppThemeColorValue({@required int colorValue})async{
    return await _profileSettingsRepository.saveAppThemeColorValue(colorValue: colorValue);
  }


  @override
  Future<int> getSavedAppThemeColorValue()async{
    return await _profileSettingsRepository.getSavedAppThemeColorValue();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _profileImageBehaviorSubject?.close();
    _profileNameBehaviorSubject?.close();
    _userNameBehaviorSubject?.close();
    _genderTypeBehaviorSubject?.close();
    _percentRatioProgressBehaviorSubject?.close();

    _progressTransferDataBehaviorSubject?.close();
    _totalTransferDataBehaviorSubject?.close();
    _receiveFriendRequestBehaviorSubject?.close();
    _showPublicPostsBehaviorSubject?.close();

    _observeCombineLatestProgressAndTotalTransfer?.cancel();

    _appThemeColorValueBehaviorSubject?.close();

    _profileAudioBehaviorSubject?.close();
  }


}











