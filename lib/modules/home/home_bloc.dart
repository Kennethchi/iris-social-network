import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_repository.dart';
import 'home_dependency_injection.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';




abstract class HomeBlocBlueprint{

  Future<bool> isNewUser({@required String userId});

  Future<String> getFCMToken();

  Future<void> updateUserFCMToken({@required String currentUserId, @required String fcmToken});

  Future<PostModel> getSinglePostData({@required String postId, @required String postUserId});

  void dispose();
}


class HomeBloc extends HomeBlocBlueprint{





  String _userId;
  String get getUserId => _userId;
  set setUserId(String userId) {
    _userId = userId;
  }




  // Streaming avatar position
  BehaviorSubject<Point<double>> _avatarPositionBehaviorSubject = BehaviorSubject<Point<double>>();
  Stream<Point<double>> get getAvatarPositionStream => _avatarPositionBehaviorSubject.stream;
  StreamSink<Point<double>> get _getAvatarPositionSink => _avatarPositionBehaviorSubject.sink;


  // Streaming avatar position
  BehaviorSubject<int> _pageViewIndexBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getPageViewIndexStream => _pageViewIndexBehaviorSubject.stream;
  StreamSink<int> get _getPageViewIndexSink => _pageViewIndexBehaviorSubject.sink;



  // Streaming avatar position
  BehaviorSubject<bool> _showPageIndicatorBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getShowPageIndicatorStream => _showPageIndicatorBehaviorSubject.stream;
  StreamSink<bool> get _getShowPageIndicatorSink => _showPageIndicatorBehaviorSubject.sink;


  // receive friend request
  BehaviorSubject<bool> _showPublicPostFeedsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getShowPublicPostFeedsStream => _showPublicPostFeedsBehaviorSubject.stream;
  Sink<bool> get _getShowPublicPostFeedsSink => _showPublicPostFeedsBehaviorSubject.sink;





  // repository dependency
  HomeRepository _homeRepository;


  HomeBloc(){

    _homeRepository = HomeDependencyInjector().getHomeRepository;


    getFirebaseUser().then((FirebaseUser user)async{
      if(user != null){
        setUserId = user.uid;

        getFCMToken().then((String fcmToken){

          if(fcmToken != null){
            updateUserFCMToken(currentUserId: user.uid, fcmToken: fcmToken);
          }
        });
      }

    });

  }


  void addShowPublicPostFeedToStream(bool showPublicPostFeed){
    _getShowPublicPostFeedsSink.add(showPublicPostFeed);
  }

  void addShowPageIndicatorToStream(bool showPageIndicator){
    _getShowPageIndicatorSink.add(showPageIndicator);
  }

  void addPageViewIndexToStream(int pageViewIndex){
    _getPageViewIndexSink.add(pageViewIndex);
  }

  void addAvatarPositionToStream(Point<double> avatarPosition){
    _getAvatarPositionSink.add(avatarPosition);
  }


  Future<FirebaseUser> getFirebaseUser()async {
    return await FirebaseAuth.instance.currentUser();
  }



  @override
  Future<bool> isNewUser({@required String userId})async {
    return await _homeRepository.isNewUser(userId: userId);
  }


  @override
  Future<String> getFCMToken()async {
    return await _homeRepository.getFCMToken();
  }

  @override
  Future<Function> updateUserFCMToken({@required String currentUserId, @required String fcmToken})async {
    await _homeRepository.updateUserFCMToken(currentUserId: currentUserId, fcmToken: fcmToken);
  }


  @override
  Future<PostModel> getSinglePostData({@required String postId, @required String postUserId})async {
    return await _homeRepository.getSinglePostData(postId: postId, postUserId: postUserId);
  }

  @override
  void dispose() {

    _avatarPositionBehaviorSubject?.close();
    _pageViewIndexBehaviorSubject?.close();
    _showPageIndicatorBehaviorSubject?.close();
    _showPublicPostFeedsBehaviorSubject?.close();
  }

}



