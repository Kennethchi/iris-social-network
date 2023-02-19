import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';

import 'friends_repository.dart';
import 'friends_dependency_injection.dart';
import 'package:rxdart/rxdart.dart';



abstract class FriendsBlocBlueprint{

  Future<UserModel> getUserData({@required String userId});

  void dispose();
}



class FriendsBloc implements FriendsBlocBlueprint{


  List<FriendModel> _allFriendsList;
  List<FriendModel> get getAllFriendsList => _allFriendsList;
  set setAllFriendsList(List<FriendModel> allFriendsList) {
    _allFriendsList = allFriendsList;
  }


  int _startAtIndex;
  int get getStartAtIndex => _startAtIndex;
  set setStartAtIndex(int startAtIndex) {
    _startAtIndex = startAtIndex;
  }

  int _endBeforeIndex;
  int get getEndBeforeIndex => _endBeforeIndex;
  set setEndBeforeIndex(int endBeforeIndex) {
    _endBeforeIndex = endBeforeIndex;
  }


  bool _hasMoreFriends;
  bool get getHasMoreFriends => _hasMoreFriends;
  set setHasMoreFriends(bool hasMoreFriends) {
    _hasMoreFriends = hasMoreFriends;
  }

  bool _hasLoadedFriends;
  bool get getHasLoadedFriends => _hasLoadedFriends;
  set setHasLoadedFriends(bool hasLoadedFriends) {
    _hasLoadedFriends = hasLoadedFriends;
  }

  int _queryLimit;
  int get getQueryLimit => _queryLimit;
  set setQueryLimit(int queryLimit) {
    _queryLimit = queryLimit;
  }

  int _queryMaxLimit;
  int get getQueryMaxLimit => _queryMaxLimit;
  set setQueryMaxLimit(int queryMaxLimit) {
    _queryMaxLimit = queryMaxLimit;
  }



  List<FriendModel> _friendsList;
  List<FriendModel> get getFriendsList => _friendsList;
  set setFriendsList(List<FriendModel> friendsList) {
    _friendsList = friendsList;
  }


  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }



  BehaviorSubject<List<FriendModel>> _friendsListBehaviorSubject = BehaviorSubject<List<FriendModel>>();
  Stream<List<FriendModel>> get getFriendsListStream => _friendsListBehaviorSubject.stream;
  StreamSink<List<FriendModel>> get _getFriendsListSink => _friendsListBehaviorSubject.sink;


  BehaviorSubject<int> _numberOfFriendsBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getNumberOfFriendsStream => _numberOfFriendsBehaviorSubject.stream;
  StreamSink<int> get _getNumberOfFriendsSink => _numberOfFriendsBehaviorSubject.sink;


  FriendsRepository _friendsRepository;

  FriendsBloc({@required String currentUserId}){

    _friendsRepository = FriendsDependencyInjector().getFriendsRepository;


    if (currentUserId != null){

      loadFriends(currentUserId: currentUserId);
    }
    else{
      getFirebaseUser().then((FirebaseUser firebaseUser){

        if (firebaseUser != null){
          loadFriends(currentUserId: firebaseUser.uid);
        }
      });
    }



  }




  Future<void> loadFriends({@required String currentUserId})async{

    setFriendsList = List<FriendModel>();
    setHasMoreFriends = false;
    setHasLoadedFriends = false;

    UserModel currentUserModel = await getUserData(userId: currentUserId);

    setQueryMaxLimit = AppFeaturesMaxLimits.MAX_NUMBER_OF_FRIENDS;
    setQueryLimit = DatabaseQueryLimits.FRIENDS_QUERY_LIMITS;

    setStartAtIndex = 0;
    setEndBeforeIndex = getQueryLimit;
    setAllFriendsList = currentUserModel != null? currentUserModel.getAllCurrentUserFriendModel(): List<FriendModel>();
    this.getAllFriendsList.sort();



    if (currentUserModel != null && currentUserModel.friends != null && currentUserModel.friends.length > 0){

      setCurrentUserModel = currentUserModel;

      addNumberOfFriendsToStream(currentUserModel.friends.length);

      for (int index = 0; (index < this.getEndBeforeIndex) && (this.getEndBeforeIndex < this.getQueryMaxLimit); ++index){

        UserModel userModel = await getUserData(userId: this.getAllFriendsList[index].userId);
        if (userModel == null){
          continue;
        }
        else{
          FriendModel friendModel = this.getAllFriendsList[index];
          friendModel.userModel = userModel;
          this.getFriendsList.add(friendModel);

          addFriendsListToStream(this.getFriendsList);
        }
      }

      if (this.getFriendsList.length < getQueryLimit){
        setHasMoreFriends = false;
      }
      else{
        setHasMoreFriends = true;
      }


      setStartAtIndex = this.getStartAtIndex + getQueryLimit;
      setEndBeforeIndex = this.getEndBeforeIndex + getQueryLimit;

      //addFriendsListToStream(this.getFriendsList);
    }
    else{

      print("No Friends Data");
      // add empty friends list to stream
      setHasMoreFriends = false;
      addFriendsListToStream(List<FriendModel>());
      addNumberOfFriendsToStream(0);
    }

  }





  Future<void> loadMoreFriends()async{

    if (this.getFriendsList.length < this.getQueryMaxLimit && getHasMoreFriends){


      for (int index = this.getStartAtIndex; index < this.getEndBeforeIndex && this.getEndBeforeIndex < this.getAllFriendsList.length ; ++index){

        UserModel userModel = await getUserData(userId: this.getAllFriendsList[index].userId);

        if (userModel == null){

          continue;
        }
        else{
          FriendModel friendModel = this.getAllFriendsList[index];
          friendModel.userModel = userModel;
          this.getFriendsList.add(friendModel);

          addFriendsListToStream(this.getFriendsList);

        }

        //addFriendsListToStream(this.getFriendsList);

      }

      this.setStartAtIndex = this.getStartAtIndex + this.getQueryLimit;
      this.setEndBeforeIndex = this.getEndBeforeIndex + this.getQueryLimit;

    }
    else{
      setHasMoreFriends = false;
    }





  }






  void addNumberOfFriendsToStream(int numberOfFriends){
    _getNumberOfFriendsSink.add(numberOfFriends);
  }

  void addFriendsListToStream(List<FriendModel> friendsList){
    _getFriendsListSink.add(friendsList);
  }


  Future<FirebaseUser> getFirebaseUser()async{
    return await FirebaseAuth.instance.currentUser();
  }

  @override
  Future<UserModel> getUserData({@required String userId})async {
    return await _friendsRepository.getUserData(userId: userId);
  }

  @override
  void dispose() {

    _friendsListBehaviorSubject?.close();
  }
}


