import 'dart:async';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'users_suggestion_repository.dart';
import 'users_suggestion_dependency_injection.dart';


abstract class UsersSuggestionBlocBlueprint{

  Future<List<UserModel>> getSuggestedUsersData({@required int queryLimit, @required Map<String, dynamic> startAfterMap});

  void dispose();
}


class UsersSuggestionBloc implements UsersSuggestionBlocBlueprint{




  // user query limits
  int _usersQueryLimit;
  int get getUsersQueryLimit => _usersQueryLimit;
  set setUsersQueryLimit(int usersQueryLimit) {
    _usersQueryLimit = usersQueryLimit;
  }


  // startMap for checkpoint for get users
  Map<String, dynamic> _queryStartAfterMap;
  Map<String, dynamic> get getQueryStartAfterMap => _queryStartAfterMap;
  set setQueryStartAfterMap(Map<String, dynamic> queryStartAfterMap) {
    _queryStartAfterMap = queryStartAfterMap;
  }


  // List of users
  List<UserModel> _usersList;
  List<UserModel> get getUsersList => _usersList;
  set setUsersList(List<UserModel> usersList) {
    _usersList = usersList;
  }

  // has more users to loaded
  bool _hasMoreUsers;
  bool get getHasMoreUsers => _hasMoreUsers;
  set setHasMoreUsers(bool hasMoreUsers) {
    _hasMoreUsers = hasMoreUsers;
  }


  // has loaded users to avoid repetition of users
  // bloc provider implements this
  bool _hasLoadedUsers;
  bool get getHasLoadedUsers => _hasLoadedUsers;
  set setHasLoadedUsers(bool hasLoadedUsers) {
    _hasLoadedUsers = hasLoadedUsers;
  }



  // stream userList
  BehaviorSubject<List<UserModel>> _usersListBehaviorSubject = BehaviorSubject<List<UserModel>>();
  Stream<List<UserModel>> get getUsersListStream => _usersListBehaviorSubject.stream;
  StreamSink<List<UserModel>> get _getUsersListSink => _usersListBehaviorSubject.sink;

  // stream has more users
  BehaviorSubject<bool> _hasMoreUsersBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMoreUsersStream => _hasMoreUsersBehaviorSubject.stream;
  StreamSink<bool> get _getHasMoreUsersSink => _hasMoreUsersBehaviorSubject.sink;





  UsersSuggestionRepository _usersSuggestionRepository;


  UsersSuggestionBloc(){
    _usersSuggestionRepository = UsersSuggestionDependencyInjector().getRepository;

    this.setUsersList = List<UserModel>();
    // sets users query limit
    setUsersQueryLimit = DatabaseQueryLimits.SUGGESTED_USERS_QUERY_LIMIT;

    loadUsers(userQueryLimit: this.getUsersQueryLimit);
  }

  @override
  Future<List<UserModel>> getSuggestedUsersData({@required int queryLimit, @required Map<String, dynamic> startAfterMap})async {
    return await _usersSuggestionRepository.getSuggestedUsersData(queryLimit: queryLimit, startAfterMap: startAfterMap);
  }



  Future<void> loadUsers({@required int userQueryLimit})async{

    this.setUsersList = List<UserModel>();
    this.setHasMoreUsers = false;
    this.setHasLoadedUsers = false;

    addHasMoreUsersToStream(true);


    getSuggestedUsersData(queryLimit: userQueryLimit, startAfterMap: null).then((usersList)async{

      this.getUsersList.clear();

      if (usersList.length < userQueryLimit){

        getUsersList.addAll(usersList);

        addUsersListToStream(this.getUsersList);

        addHasMoreUsersToStream(false);
        this.setHasMoreUsers = false;
        return;
      }
      else{

        setQueryStartAfterMap = usersList.last.toJson();


        getUsersList.addAll(usersList);

        addUsersListToStream(this.getUsersList);

        addHasMoreUsersToStream(true);
        this.setHasMoreUsers = true;
      }

    });
  }




  Future<void> loadMoreUsers({@required int userQueryLimit})async{

    addHasMoreUsersToStream(true);

    if (getHasMoreUsers){

      List<UserModel> usersList = await getSuggestedUsersData(queryLimit: userQueryLimit, startAfterMap: this.getQueryStartAfterMap);


      if (usersList.length < userQueryLimit){


        getUsersList.addAll(usersList);

        addUsersListToStream(this.getUsersList);

        setHasMoreUsers = false;
        addHasMoreUsersToStream(false);
      }
      else{

        setQueryStartAfterMap = usersList.last.toJson();

        getUsersList.addAll(usersList);

        addUsersListToStream(this.getUsersList);

        setHasMoreUsers = true;
        addHasMoreUsersToStream(true);
      }
    }
    else{
      addHasMoreUsersToStream(false);
      setHasMoreUsers = false;
    }

  }


  void addHasMoreUsersToStream(bool hasMoreUsers){

    _getHasMoreUsersSink.add(hasMoreUsers);
  }

  void addUsersListToStream(List<UserModel> usersList){
    _getUsersListSink.add(usersList);
  }



  @override
  void dispose() {

    _hasMoreUsersBehaviorSubject?.close();
    _usersListBehaviorSubject?.close();
  }

}


