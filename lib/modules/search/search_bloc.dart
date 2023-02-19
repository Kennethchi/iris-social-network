import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'search_dependency_injection.dart';
import 'search_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'search_validators.dart';



abstract class SearchBlocBlueprint{

  Future<UserModel> getSearchUser({@required String searchUser});

  void dispose();
}




class SearchBloc with SearchValidators implements SearchBlocBlueprint{


  BehaviorSubject<UserModel> _searchUserModelBehaviorSubject = BehaviorSubject<UserModel>();
  Stream<UserModel> get getSearchUserModelStream => _searchUserModelBehaviorSubject.stream;
  StreamSink<UserModel> get _getSearchUserModelSink => _searchUserModelBehaviorSubject.sink;


  BehaviorSubject<String> _searchTextBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getSearchTextStream => _searchTextBehaviorSubject.stream.transform(textValidator);
  StreamSink<String> get _getSearchTextSink => _searchTextBehaviorSubject.sink;


  BehaviorSubject<bool> _isSearchSuccessfullBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsSearchSuccessfullStream => _isSearchSuccessfullBehaviorSubject.stream;
  StreamSink<bool> get _getIsSearchSuccessfullSink => _isSearchSuccessfullBehaviorSubject.sink;





  // variable to hold the repository
  SearchRepository _searchRepository;

  SearchBloc(){

    // Initialise repository using dependency ijection
    _searchRepository = SearchDependencyInjector().getSearchRepository;
  }

  void addIsSearchSuccessfull(bool isSearchSuccessfull){
    _getIsSearchSuccessfullSink.add(isSearchSuccessfull);
  }


  void addSearchUserModelToStream(UserModel searchUserModel){
    _getSearchUserModelSink.add(searchUserModel);
  }

  void addSearchTextToStream({@required String searchText}) {
    _getSearchTextSink.add(searchText);
  }




  @override
  Future<UserModel> getSearchUser({@required String searchUser})async {

    return await _searchRepository.getSearchUser(searchUser: searchUser);
  }

  @override
  void dispose() {

    _searchUserModelBehaviorSubject?.close();
    _searchTextBehaviorSubject?.close();
    _isSearchSuccessfullBehaviorSubject?.close();
  }
}


