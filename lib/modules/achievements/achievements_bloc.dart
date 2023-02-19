import 'dart:async';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'package:meta/meta.dart';
import 'achievements_dependency_injection.dart';
import 'achievements_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';



abstract class AchievementsBlocBlueprint{

  Future<int> getTotalAchievedPoints({@required String userId});

  void dispose();
}


class AchievementsBloc implements AchievementsBlocBlueprint{

  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }

  RewardPointsModel _userRewardPointsModel;
  RewardPointsModel get getUserRewardPointsModel => _userRewardPointsModel;
  set setUserRewardPointsModel(RewardPointsModel userRewardPointsModel) {
    _userRewardPointsModel = userRewardPointsModel;
  }
  

  BehaviorSubject<RewardPointsModel> _achievedRewardPointsModelBehaviorSubject = BehaviorSubject<RewardPointsModel>();
  Stream<RewardPointsModel> get getAchievedRewardPointsModelStream => _achievedRewardPointsModelBehaviorSubject.stream;
  StreamSink<RewardPointsModel> get _getAchievedRewardPointsModelSink => _achievedRewardPointsModelBehaviorSubject.sink;


  BehaviorSubject<int> _currentTappedAchievementsLevelIndexBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getCurrentTappedAchievementsLevelIndexStream => _currentTappedAchievementsLevelIndexBehaviorSubject.stream;
  StreamSink<int> get _getCurrentTappedAchievementsLevelIndexSink => _currentTappedAchievementsLevelIndexBehaviorSubject.sink;



  AchievementsRepository _achievementsRepository;


  AchievementsBloc(){
    _achievementsRepository = AchievementsDependencyInjector().getAchievementsRepository;

    getFirebaseUser().then((FirebaseUser firebaseUser){
      if (firebaseUser != null){
        setCurrentUserId = firebaseUser.uid;

        getTotalAchievedPoints(userId: firebaseUser.uid).then(((int achievedRewardPoints){

          RewardPointsModel rewardPointsModel = RewardPointsModel(points: achievedRewardPoints);
          setUserRewardPointsModel = rewardPointsModel;
          addAcheivedRewardPointsModelToStream(rewardPointsModel);
        }));

      }
    });

  }



  Future<FirebaseUser> getFirebaseUser()async{
    return await FirebaseAuth.instance.currentUser();
  }

  void addCurrentTappedAchievementsLevelIndexToStream(int currentTappedAchievementsLevelIndex){
    _getCurrentTappedAchievementsLevelIndexSink.add(currentTappedAchievementsLevelIndex);
  }

  void addAcheivedRewardPointsModelToStream(RewardPointsModel achievedRewardPointsModelToStream){
    _getAchievedRewardPointsModelSink.add(achievedRewardPointsModelToStream);
  }


  @override
  Future<int> getTotalAchievedPoints({@required String userId})async {
    return await _achievementsRepository.getTotalAchievedPoints(userId: userId);
  }


  @override
  void dispose() {

    _achievedRewardPointsModelBehaviorSubject?.close();
  }
}




