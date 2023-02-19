import 'dart:async';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:meta/meta.dart';
import 'account_setup_dependency_injection.dart';
import 'account_setup_repository.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:path_provider/path_provider.dart';

import 'package:iris_social_network/utils/image_utils.dart';

import 'account_setup_validators.dart';

import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/optimised_models/optimised_user_model.dart';





abstract class AccountSetupBlocBlueprint{

  void dispose();

  Future<void> addUserProfileData({@required UserModel userModel, @required String userId});

  Future<String> uploadImage(@required String storagePath, @required File imageFile);

  Future<UserModel> getCurrentFirebaseUserData();

  Future<bool> checkUsernameIsTaken({@required String userNameTrial});

  Future<void> addOptimisedUserData({OptimisedUserModel optimisedUserModel, String userId});

  Future<FirebaseUser> getFirebaseUser();

  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink});

  Future<bool> checkIfUserDataExists({@required String userId});

  Future<void> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel});
}


class AccountSetupBloc extends AccountSetupBlocBlueprint with AccountSetupValidators{



  // progress byte
  BehaviorSubject<int> _progressTransferDataBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getProgressTransferDataStream => _progressTransferDataBehaviorSubject.stream;
  StreamSink<int> get getProgressTransferDataSink => _progressTransferDataBehaviorSubject.sink;

  void addProgressTransferDataToStream(int progressTransferData){
    getProgressTransferDataSink.add(progressTransferData);
  }

  // total byte
  BehaviorSubject<int> _totalTransferDataBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getTotalTransferDataStream => _totalTransferDataBehaviorSubject.stream;
  StreamSink<int> get getTotalTransferDataSink => _totalTransferDataBehaviorSubject.sink;

  void addTotalTransferDataToStream(int totalTransferData){
    getTotalTransferDataSink.add(totalTransferData);
  }

  // percent ratio progress stream
  BehaviorSubject<double> _percentRatioProgressBehaviorSubject = BehaviorSubject<double>();
  Stream<double> get getPercentRatioProgressStream => _percentRatioProgressBehaviorSubject.stream;
  Sink<double> get _getPercentRatioProgressSink => _percentRatioProgressBehaviorSubject.sink;

  void addPercentRatioProgress(double percentRatioProgress){
    _getPercentRatioProgressSink.add(percentRatioProgress);
  }

  // Stream subscription for observing latest combination of ongoing progress transfer and total transfer
  StreamSubscription<double> _observeCombineLatestProgressAndTotalTransfer;




  String _profileName;
  String get getProfileName => _profileName;
  set setProfileName(String profileName) {
    _profileName = profileName;
  }

  String _profileUsername;
  String get getProfileUsername => _profileUsername;
  set setProfileUsername(String profileUsername) {
    _profileUsername = profileUsername;
  }

  String _genderType;
  String get getGenderType => _genderType;
  set setGenderType(String genderType) {
    _genderType = genderType;
  }

  String _profileImagePath;
  String get getProfileImagePath => _profileImagePath;
  set setProfileImagePath(String profileImagePath) {
    _profileImagePath = profileImagePath;
  }





  // User data
  UserModel _userModel;
  UserModel get getUserModel => _userModel;
  set setUserModel(UserModel userModel) {
    _userModel = userModel;
  }






  // Streaming profile name
  BehaviorSubject<String> _profileNameBehaviorSubject = new BehaviorSubject<String>();
  Stream<String> get getProfileNameStream => _profileNameBehaviorSubject.stream.transform(profileNameTransformer);
  Sink<String> get _addProfileNameSink => _profileNameBehaviorSubject.sink;


  // Streaming username
  BehaviorSubject<String> _userNameBehaviorSubject = new BehaviorSubject<String>();
  Stream<String> get getUserNameStream => _userNameBehaviorSubject.stream.transform(userNameTransformer);
  Sink<String> get _addUserNameSink => _userNameBehaviorSubject.sink;


  // Streaming user name result
  BehaviorSubject<String> _userNameResultBehaviorSubject = new BehaviorSubject<String>();
  Stream<String> get getUserNameResultStream => _userNameResultBehaviorSubject.stream.transform(userNameTransformer);
  Sink<String> get _addUserNameResultSink => _userNameResultBehaviorSubject.sink;



  // Streaming account type
  BehaviorSubject<String> _accountTypeBehaviorSubject = new BehaviorSubject<String>();
  Stream<String> get getAccountTypeStream => _accountTypeBehaviorSubject.stream;
  Sink<String> get _addAccountTypeSink => _accountTypeBehaviorSubject;


  // Streaming gender type
  BehaviorSubject<String> _genderTypeBehaviorSubject = new BehaviorSubject<String>();
  Stream<String> get getGenderTypeStream => _genderTypeBehaviorSubject.stream;
  StreamSink<String> get _addGenderTypeStream => _genderTypeBehaviorSubject.sink;


  // Streaming profile image File
  BehaviorSubject<File> _profileImageFileBehaviorSubject = new BehaviorSubject<File>();
  Stream<File> get getProfileImageFileStream => _profileImageFileBehaviorSubject.stream;
  StreamSink<File> get _addProfileImageFileSink => _profileImageFileBehaviorSubject.sink;


  // Streaming profile image Link
  BehaviorSubject<String> _profileImageLinkBehaviorSubject = new BehaviorSubject<String>();
  Stream<String> get getProfileImageLinkStream => _profileImageLinkBehaviorSubject.stream;
  StreamSink<String> get _addProfileImageLinkSink => _profileImageLinkBehaviorSubject.sink;


  Observable<bool> get accountSetupCompleteObeservable => Observable.combineLatest4(
      getProfileNameStream,
      getUserNameResultStream,
      getGenderTypeStream,
      getProfileImageFileStream, (String profileName, String userName, String genderType, File profileImageFile )
  {

        if (profileName != null && userName != null && genderType != null && profileImageFile != null){

          /*
          setProfileName = profileName;
          setProfileUsername = userName;
          setGenderType = genderType;
          */
          setProfileImagePath = profileImageFile.path;


          getUserModel.profileName = profileName;
          getUserModel.username = userName;
          getUserModel.genderType = genderType;

          return true;
        }
        else{
          return false;
        }

  });



  // Initial account setup repository
  AccountSetupRepository _accountSetupRepository;


  AccountSetupBloc(){
    // set account setup dependency using dependcy injector
    _accountSetupRepository = AccountSetupDependencyInjector().getAcccountSetupRepository;



    // Initialise user default data
    getCurrentFirebaseUserData().then((UserModel userModel){

      if (userModel != null){
        this.setUserModel = userModel;

        /*
        if (getUserModel.profileImage != null){
          addProfileImageLink(getUserModel.profileImage);

          print(getUserModel.profileImage);
        }
        */

        if (getUserModel.profileName != null){
          addProfileName(getUserModel.profileName);
        }
        if (getUserModel.username != null){
          addUserName(getUserModel.username);
        }
      }
    });





    // obserbing percentage ratio transfer
    _observeCombineLatestProgressAndTotalTransfer = Observable.combineLatest2(getProgressTransferDataStream, getTotalTransferDataStream, (int progressTransfer, int totalTransfer){

      print("Sent: $progressTransfer, total: $totalTransfer");

      return progressTransfer / totalTransfer;
    }).listen((double percentProgressRatio){
      addPercentRatioProgress(percentProgressRatio);
    });
  }



  void addProfileName(String profileName){
    this._addProfileNameSink.add(profileName);
  }

  void addUserName(String userName){
    this._addUserNameSink.add(userName);
  }

  void addUserNameResult(String userNameResult){
    this._addUserNameResultSink.add(userNameResult);
  }


  void addAccountType(String accountType){
    this._addAccountTypeSink.add(accountType);
  }

  void addGenderType(String genderType){
    this._addGenderTypeStream.add(genderType);
  }

  void addProfileImageFile(File profileImage){
    this._addProfileImageFileSink.add(profileImage);
  }

  void addProfileImageLink(String imageLink){
    this._addProfileImageLinkSink.add(imageLink);
  }





  @override
  Future<void> addUserProfileData({@required UserModel userModel, @required String userId}) async {
    await _accountSetupRepository.addUserProfileData(userModel: userModel, userId: userId);

    // Stores part if user data in realtume database that will be frequently accessed

  }



  @override
  Future<String> uploadImage(String storagePath, File imageFile) async {
    return await _accountSetupRepository.uploadImage(storagePath: storagePath, imageFile: imageFile);
  }


  @override
  Future<UserModel> getCurrentFirebaseUserData() async {
    return await _accountSetupRepository.getCurrentFirebaseUserData();
  }


  @override
  Future<bool> checkUsernameIsTaken({@required String userNameTrial}) async{
    return await _accountSetupRepository.checkUsernameIsTaken(userNameTrial: userNameTrial);
  }


  @override
  Future<Function> addOptimisedUserData({OptimisedUserModel optimisedUserModel, String userId})async {
    await _accountSetupRepository.addOptimisedUserData(optimisedUserModel: optimisedUserModel, userId: userId);
  }


  @override
  Future<FirebaseUser> getFirebaseUser()async {
    return await _accountSetupRepository.getFirebaseUser();
  }


  @override
  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {
    return await _accountSetupRepository.uploadFile(sourceFile: sourceFile, filename: filename, progressSink: progressSink, totalSink: totalSink);
  }


  @override
  Future<bool> checkIfUserDataExists({@required String userId})async {
    return await _accountSetupRepository.checkIfUserDataExists(userId: userId);
  }


  @override
  Future<Function> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel})async {
    _accountSetupRepository.addChatsData(chatUserChatterModel: chatUserChatterModel, currentUserChatterModel: currentUserChatterModel);
  }

  @override
  void dispose() {

    _progressTransferDataBehaviorSubject?.close();
    _totalTransferDataBehaviorSubject?.close();
    _percentRatioProgressBehaviorSubject?.close();
    _observeCombineLatestProgressAndTotalTransfer?.cancel();



    _profileNameBehaviorSubject?.close();
    _userNameBehaviorSubject?.close();
    _accountTypeBehaviorSubject?.close();
    _genderTypeBehaviorSubject?.close();
    _profileImageFileBehaviorSubject?.close();
  }





}






