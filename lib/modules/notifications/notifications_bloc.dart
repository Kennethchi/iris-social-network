import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'notifications_repository.dart';
import 'notifications_dependency_injection.dart';





abstract class NotificationsBlocBlueprint{


  Future<List<OptimisedNotificationModel>> getUserNotifications({
    @required String currentUserId, @required String notificationType, @required int queryLimit, @required String endAtKey
  });

  Future<String> getUserProfileName({@required String userId});

  Future<String> getUserProfileThumb({@required String userId});

  Future<String> getUserUsername({@required String userId});

  Future<bool> getIsUserVerified({@required String userId});

  Future<void> deleteNotification({@required String userId, @required String notificationId});

  void dispose();
}


class NotificationsBloc implements NotificationsBlocBlueprint{

  
  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }

  int _NotificationsQueryLimit;
  int get getNotificationsQueryLimit => _NotificationsQueryLimit;
  set setNotificationsQueryLimit(int NotificationsQueryLimit) {
    _NotificationsQueryLimit = NotificationsQueryLimit;
  }


  String _queryEndAtKey;
  String get getQueryEndAtKey => _queryEndAtKey;
  set setQueryEndAtKey(String queryEndAtKey) {
    _queryEndAtKey = queryEndAtKey;
  }


  // List of videos
  List<OptimisedNotificationModel> _NotificationsList;
  List<OptimisedNotificationModel> get getNotificationsList => _NotificationsList;
  set setNotificationsList(List<OptimisedNotificationModel> commentsList) {
    _NotificationsList = commentsList;
  }


  bool _hasMoreNotifications;
  bool get getHasMoreNotifications => _hasMoreNotifications;
  set setHasMoreNotifications(bool hasMoreNotifications) {
    _hasMoreNotifications = hasMoreNotifications;
  }



  // has loaded comments to avoid repetition of comments
  // bloc provider implements this
  bool _hasLoadedNotifications;
  bool get getHasLoadedNotifications => _hasLoadedNotifications;
  set setHasLoadedNotifications(bool hasLoadedNotifications) {
    _hasLoadedNotifications = hasLoadedNotifications;
  }


  String _notificationType;
  String get getNotificationType => _notificationType;
  set setNotificationType(String notificationType) {
    _notificationType = notificationType;
  }



  BehaviorSubject<List<OptimisedNotificationModel>> _NotificationsListBehaviorSubject = BehaviorSubject<List<OptimisedNotificationModel>>();
  Stream<List<OptimisedNotificationModel>> get getNotificationsListStream => _NotificationsListBehaviorSubject.stream;
  StreamSink<List<OptimisedNotificationModel>> get _getNotificationsListSink => _NotificationsListBehaviorSubject.sink;



  BehaviorSubject<bool> _hasMoreNotificationsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMoreNotificationsStream => _hasMoreNotificationsBehaviorSubject.stream;
  StreamSink<bool> get _getHasMoreNotificationsSink => _hasMoreNotificationsBehaviorSubject.sink;



  BehaviorSubject<bool> _isFollowersViewBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsFollowersViewStream => _isFollowersViewBehaviorSubject.stream;
  StreamSink<bool> get _getIsFollowersViewSink => _isFollowersViewBehaviorSubject.sink;





  NotificationsRepository _notificationsRepository;


  NotificationsBloc({@required String currentUserId}){
    _notificationsRepository = NotificationsDependencyInjector().getNotificationsRepository;

    setNotificationsQueryLimit = DatabaseQueryLimits.NOTIFICATIONS_QUERY_LIMIT;
    setNotificationsList = List<OptimisedNotificationModel>();
    setHasMoreNotifications = true;
    setHasLoadedNotifications= false;
    setNotificationType = null;


    if (currentUserId != null){

      setCurrentUserId = currentUserId;

      loadNotifications(
          currentUserId: currentUserId,
          queryLimit: getNotificationsQueryLimit,
          endAtKey: null,
          notificationType: getNotificationType
      );
      
    }else{
      getFirebaseCurrentUser().then((FirebaseUser firebaseUser){
        
        if (firebaseUser != null){

          setCurrentUserId = firebaseUser.uid;

          loadNotifications(
              currentUserId: firebaseUser.uid,
              queryLimit: getNotificationsQueryLimit,
              endAtKey: null,
              notificationType: getNotificationType
          );
        }
      });
    }
    
  }





  Future<void> setUpNotificationsData({@required List<OptimisedNotificationModel> notificationsList})async{


    for (int index = 0; index < notificationsList.length; ++index){

      String userfromId = notificationsList[index].from;

      notificationsList[index].userFromUserName = await this.getUserUsername(userId: userfromId);
      //notificationsList[index].userFromName = await this.getUserProfileName(userId: userfromId);
      //notificationsList[index].userFromIsVerified = await this.getIsUserVerified(userId: userfromId);


      this.getNotificationsList.add(notificationsList[index]);
      addNotificationsListToStream(this.getNotificationsList);
    }

  }



  void loadNotifications({@required currentUserId, @required int queryLimit, @required String endAtKey, @required String notificationType}){
    
    setNotificationsList = List<OptimisedNotificationModel>();
    setHasMoreNotifications = true;
    setHasLoadedNotifications= false;

    getUserNotifications(
        currentUserId: currentUserId, queryLimit: queryLimit, endAtKey: endAtKey, notificationType: notificationType
    ).then((List<OptimisedNotificationModel> NotificationsList){


      this.getNotificationsList.clear();

      if (NotificationsList.length < getNotificationsQueryLimit){

        setHasMoreNotifications = false;
        addHasMoreNotificationsToStream(false);
      }
      else{
        setQueryEndAtKey = NotificationsList.removeLast().id;
      }


      this.setUpNotificationsData(notificationsList: NotificationsList).then((_){

        addNotificationsListToStream(this.getNotificationsList);
      });

    });
  }



  Future<void> loadMoreNotifications({@required currentUserId, @required int queryLimit, @required String endAtKey, @required String notificationType})async{

    if (getHasMoreNotifications){

      List<OptimisedNotificationModel> NotificationsList = await getUserNotifications(
          currentUserId: currentUserId,
          queryLimit: queryLimit,
          endAtKey: endAtKey,
        notificationType: notificationType
      );

      if (NotificationsList.length < getNotificationsQueryLimit){

        setHasMoreNotifications = false;
        addHasMoreNotificationsToStream(false);
      }
      else{

        setQueryEndAtKey = NotificationsList.removeLast().id;
      }


      this.setUpNotificationsData(notificationsList: NotificationsList).then((_){

        addNotificationsListToStream(this.getNotificationsList);
      });

    }
    else{
      addHasMoreNotificationsToStream(false);
      setHasMoreNotifications = false;
    }

  }




  void addHasMoreNotificationsToStream(bool hasMoreNotifications){
    _getHasMoreNotificationsSink.add(hasMoreNotifications);
  }

  void addNotificationsListToStream(List<OptimisedNotificationModel> optimisedNotificationsList){
    _getNotificationsListSink.add(optimisedNotificationsList);
  }





  Future<FirebaseUser> getFirebaseCurrentUser() async{
    return await FirebaseAuth.instance.currentUser();
  }


  @override
  Future<List<OptimisedNotificationModel>> getUserNotifications(
      {@required String currentUserId, @required String notificationType, @required int queryLimit, @required String endAtKey})async {
    return await _notificationsRepository.getUserNotifications(currentUserId: currentUserId, notificationType: notificationType, queryLimit: queryLimit, endAtKey: endAtKey);
  }

  @override
  Future<String> getUserProfileName({@required String userId})async{
    return await _notificationsRepository.getUserProfileName(userId: userId);
  }

  @override
  Future<String> getUserProfileThumb({@required String userId})async {
    return await _notificationsRepository.getUserProfileThumb(userId: userId);
  }

  @override
  Future<String> getUserUsername({@required String userId})async{
    return await _notificationsRepository.getUserUsername(userId: userId);
  }

  @override
  Future<bool> getIsUserVerified({@required String userId})async {
    return await _notificationsRepository.getIsUserVerified(userId: userId);
  }


  @override
  Future<Function> deleteNotification({@required String userId, @required String notificationId})async {
    await _notificationsRepository.deleteNotification(userId: userId, notificationId: notificationId);
  }

  @override
  void dispose() {

    _hasMoreNotificationsBehaviorSubject?.close();
    _isFollowersViewBehaviorSubject?.close();
    _NotificationsListBehaviorSubject?.close();
  }




}


