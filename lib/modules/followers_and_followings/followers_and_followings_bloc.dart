import 'dart:async';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'followers_and_followings_repository.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'followers_and_followings_dependency_injection.dart';
import 'package:rxdart/rxdart.dart';




abstract class FollowersAndFollowingsBlocBlueprint{

  Future<List<OptimisedFFModel>>  getProfileUserFollowers({@required String profileUserId, @required int queryLimit, @required String endAtKey});

  Future<List<OptimisedFFModel>>  getProfileUserFollowings({@required String profileUserId, @required int queryLimit, @required String endAtKey});

  Future<String> getFFProfileName({@required String userId});

  Future<String> getFFProfileThumb({@required String userId});

  Future<String> getFFUsername({@required String userId});

  Future<bool> getIsUserVerified({@required String userId});

  void dispose();
}


class FollowersAndFollowingsBloc implements FollowersAndFollowingsBlocBlueprint{


  String _profileUserId;
  String get getProfileUserId => _profileUserId;
  set setProfileUserId(String profileUserId) {
    _profileUserId = profileUserId;
  }


  int _ffQueryLimit;
  int get getFFQueryLimit => _ffQueryLimit;
  set setFFQueryLimit(int ffQueryLimit) {
    _ffQueryLimit = ffQueryLimit;
  }


  bool _isFollowersView;
  bool get getIsFollowersView => _isFollowersView;
  set setIsFollowersView(bool isFollowersView) {
    _isFollowersView = _isFollowersView;
  }
  


  String _queryEndAtKey;
  String get getQueryEndAtKey => _queryEndAtKey;
  set setQueryEndAtKey(String queryEndAtKey) {
    _queryEndAtKey = queryEndAtKey;
  }


  // List of videos
  List<OptimisedFFModel> _FFList;
  List<OptimisedFFModel> get getFFList => _FFList;
  set setFFList(List<OptimisedFFModel> commentsList) {
    _FFList = commentsList;
  }


  bool _hasMoreFF;
  bool get getHasMoreFF => _hasMoreFF;
  set setHasMoreFF(bool hasMoreFF) {
    _hasMoreFF = hasMoreFF;
  }



  // has loaded comments to avoid repetition of comments
  // bloc provider implements this
  bool _hasLoadedFF;
  bool get getHasLoadedFF => _hasLoadedFF;
  set setHasLoadedFF(bool hasLoadedFF) {
    _hasLoadedFF = hasLoadedFF;
  }



  BehaviorSubject<List<OptimisedFFModel>> _FFListBehaviorSubject = BehaviorSubject<List<OptimisedFFModel>>();
  Stream<List<OptimisedFFModel>> get getFFListStream => _FFListBehaviorSubject.stream;
  StreamSink<List<OptimisedFFModel>> get _getFFListSink => _FFListBehaviorSubject.sink;



  BehaviorSubject<bool> _hasMoreFFBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMoreFFStream => _hasMoreFFBehaviorSubject.stream;
  StreamSink<bool> get _getHasMoreFFSink => _hasMoreFFBehaviorSubject.sink;



  BehaviorSubject<bool> _isFollowersViewBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsFollowersViewStream => _isFollowersViewBehaviorSubject.stream;
  StreamSink<bool> get _getIsFollowersViewSink => _isFollowersViewBehaviorSubject.sink;
  




  // variable to hold dependency repository
  FollowersAndFollowingsRepository _followersAndFollowingsRepository;



  FollowersAndFollowingsBloc({@required String profileUserId, @required bool isFollowersView}){


    // get repository through dependency injection
    _followersAndFollowingsRepository = FollowersAndFollowingsDependencyInjector().getFollowersAndFollowingsRepository;


    // sets user id
    setProfileUserId = profileUserId;

    // sets if is user followers view or user followings view
    setIsFollowersView = isFollowersView;

    // Followers/Followings query limit
    setFFQueryLimit = DatabaseQueryLimits.FOLLOWERS_AND_FOLLOWINGS_QUERY_LIMIT;


    addIsFollowersView(isFollowersView: isFollowersView);


    setFFList = List<OptimisedFFModel>();
    setHasMoreFF = true;
    setHasLoadedFF= false;

    if (isFollowersView){
      loadFollowers();
    }else{
      loadFollowings();
    }
  }




  Future<List<OptimisedFFModel>> setUpFFData({@required List<OptimisedFFModel> ffList})async{

    List<OptimisedFFModel> processedList = List<OptimisedFFModel>();

    for (int index = 0; index < ffList.length; ++index){

      String userId = ffList[index].user_id;

      ffList[index].name = await this.getFFProfileName(userId: userId);
      ffList[index].thumb = await this.getFFProfileThumb(userId: userId);
      ffList[index].username = await this.getFFUsername(userId: userId);
      ffList[index].v_user =  await this.getIsUserVerified(userId: userId);

      processedList.add(ffList[index]);
    }

    return processedList;
  }



  void loadFollowers(){


    setFFList = List<OptimisedFFModel>();
    setHasMoreFF = true;
    setHasLoadedFF= false;

    getProfileUserFollowers(profileUserId: getProfileUserId, queryLimit: getFFQueryLimit, endAtKey: null).then((List<OptimisedFFModel> ffList){


      this.getFFList.clear();

      if (ffList.length < getFFQueryLimit){

        setHasMoreFF = false;
        addHasMoreFFToStream(false);
      }
      else{
        setQueryEndAtKey = ffList.removeLast().id;
      }


      this.setUpFFData(ffList: ffList).then((List<OptimisedFFModel> processedFFModel){

        getFFList.addAll(processedFFModel);
        addFFListToStream(this.getFFList);
      });

    });
  }



  Future<void> loadMoreFollowers()async{


    if (getHasMoreFF){

      List<OptimisedFFModel> ffList = await getProfileUserFollowers(profileUserId: getProfileUserId, queryLimit: getFFQueryLimit, endAtKey: getQueryEndAtKey);

      if (ffList.length < getFFQueryLimit){

        setHasMoreFF = false;
        addHasMoreFFToStream(false);
      }
      else{

        setQueryEndAtKey = ffList.removeLast().id;
      }


      this.setUpFFData(ffList: ffList).then((List<OptimisedFFModel> processedFFLists){
        getFFList.addAll(processedFFLists);

        addFFListToStream(this.getFFList);
      });

    }
    else{
      addHasMoreFFToStream(false);
      setHasMoreFF = false;
    }

  }






  void loadFollowings(){

    getProfileUserFollowings(profileUserId: this.getProfileUserId, queryLimit: getFFQueryLimit, endAtKey: null).then((ffList){


      if (ffList.length < getFFQueryLimit){

        setHasMoreFF = false;
        addHasMoreFFToStream(false);
      }
      else{
        setQueryEndAtKey = ffList.removeLast().id;
      }


      this.setUpFFData(ffList: ffList).then((List<OptimisedFFModel> processedFFLists){
        getFFList.addAll(processedFFLists);

        addFFListToStream(this.getFFList);
      });


    });
  }



  Future<void> loadMoreFollowings()async{


    if (getHasMoreFF){

      List<OptimisedFFModel> ffList = await getProfileUserFollowings(profileUserId: getProfileUserId, queryLimit: getFFQueryLimit, endAtKey: getQueryEndAtKey);

      if (ffList.length < getFFQueryLimit){

        setHasMoreFF = false;
        addHasMoreFFToStream(false);
      }
      else{

        setQueryEndAtKey = ffList.removeLast().id;
      }



      this.setUpFFData(ffList: ffList).then((List<OptimisedFFModel> processedFFLists){

        getFFList.addAll(processedFFLists);

        addFFListToStream(this.getFFList);
      });


    }
    else{
      addHasMoreFFToStream(false);
      setHasMoreFF = false;
    }

  }






  void addHasMoreFFToStream(bool hasMoreFF){
    _getHasMoreFFSink.add(hasMoreFF);
  }

  void addFFListToStream(List<OptimisedFFModel> optimisedFFList){
    _getFFListSink.add(optimisedFFList);
  }






  // adds is user followers view
  void addIsFollowersView({@required bool isFollowersView}){
    _getIsFollowersViewSink.add(isFollowersView);
  }

  @override
  Future<List<OptimisedFFModel>> getProfileUserFollowers({@required String profileUserId, @required int queryLimit, @required String endAtKey})async {
    return await _followersAndFollowingsRepository.getProfileUserFollowers(profileUserId: profileUserId, queryLimit: queryLimit, endAtKey: endAtKey);
  }

  @override
  Future<List<OptimisedFFModel>> getProfileUserFollowings({@required String profileUserId, @required int queryLimit, @required String endAtKey})async {
    return await _followersAndFollowingsRepository.getProfileUserFollowings(profileUserId: profileUserId, queryLimit: queryLimit, endAtKey: endAtKey);
  }


  @override
  Future<String> getFFProfileName({@required String userId})async {

    return await _followersAndFollowingsRepository.getFFProfileName(userId: userId);
  }

  @override
  Future<String> getFFProfileThumb({@required String userId})async {

    return await _followersAndFollowingsRepository.getFFProfileThumb(userId: userId);
  }


  @override
  Future<bool> getIsUserVerified({@required String userId})async {
    return await _followersAndFollowingsRepository.getIsUserVerified(userId: userId);
  }

  @override
  Future<String> getFFUsername({@required String userId})async {

    return await _followersAndFollowingsRepository.getFFUsername(userId: userId);
  }

  @override
  void dispose() {

    _isFollowersViewBehaviorSubject?.close();
    _FFListBehaviorSubject.close();
    _hasMoreFFBehaviorSubject.close();
    _FFListBehaviorSubject.close();


  }



}


