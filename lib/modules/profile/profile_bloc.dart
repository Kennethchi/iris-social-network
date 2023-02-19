import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'profile_repository.dart';
import 'profile_dependency_injection.dart';
import 'dart:async';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:rxdart/rxdart.dart';


import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/post_model.dart';



abstract class ProfileBlocBlueprint{

  Future<UserModel> getProfileUserData({@required String profileUserId});

  Stream<Event> checkCurrentUserIsAFollowerStreamEvent({@required String currentUserId, @required profileUserId});

  Stream<Event> checkProfileUserIsCurrentUserFollowerStreamEvent({@required String currentUserId, @required profileUserId});

  Future<Function> addProfileUserFollower({@required OptimisedFFModel optimisedFFModel, @required String profileUserId});

  Future<void> addCurrentUserFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId});


  Future<Function> removeProfileUserFollower({@required String currentUserId, @required String profileUserId});

  Future<void> removeCurrentUserFollowing({@required String profileUserId, @required String currentUserId});


  Future<FirebaseUser> getFirebaseUser();


  Future<int> getNumberFollowers({@required String profileUserId});

  Future<int> getNumberFollowings({@required String profileUserId});

  Future<int> getNumberOfPosts({@required String profileUserId});

  Stream<Event> getNumberOfPostsStreamEvent({@required String profileUserId});

  Future<String> uploadFile({@required storagePath, @required File file});

  Future<bool> removeFile({@required String urlPath});


  Future<List<PostModel>> getProfileUserPostsData({
    @required String profileUserId,
    @required postType = null,
    @required String postAudience,
    @required POST_QUERY_TYPE postQueryType = POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap});

  Future<void> removePostData({@required String postId, @required String currentUserId});

  Future<bool> deleteFile({@required String urlPath});

  Future<void> removePostComments({@required String postId, @required String postUserId});

  Future<void> removePostLikes({@required String postId, @required String postUserId});

  Future<void> removeOptimisedPostData({@required String postId, @required String currentUserId});


  Stream<Event> checkCurrentUserSentFriendRequestToProfileUserStreamEvent({@required String currentUserId, @required profileUserId});

  Stream<Event> checkProfileUserSentFriendRequestToCurrentUserStreamEvent({@required String currentUserId, @required profileUserId});

  Future<void> sendFriendRequest({@required String currentUserId, @required String profileUserId});

  Future<void> removeFriendRequest({@required String currentUserId, @required String profileUserId});

  Future<void> sendFriendRequestNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId});

  Future<void> addFriendToUserFriendList({@required FriendModel friendModel, @required String userId});

  Future<void> sendFriendRequestAcceptedNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId});

  Future<bool> checkIfUserSentFriendRequestNotification({@required String currentUserId, @required String profileUserId});

  Future<void> removeFriendRequestNotification({@required String currentUserId, @required String profileUserId});

  Future<int> getTotalAchievedPoints({@required String userId});

  Future<File> getCachedNetworkFile({@required String urlPath});

  void dispose();
}


class ProfileBloc extends ProfileBlocBlueprint{


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



  // Profile User Model data
  UserModel _profileUserModel;
  UserModel get getProfileUserModel => _profileUserModel;
  set setProfileUserModel(UserModel profileUserModel) {
    _profileUserModel = profileUserModel;
  }

  // Current User Model data
  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }



  // Current user Id
  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }

  // Profile user Id
  String _profileUserId;
  String get getProfileUserId => _profileUserId;
  set setProfileUserId(String profileUserId) {
    _profileUserId = profileUserId;
  }







  // post query limits
  int _postsQueryLimit;
  int get getPostsQueryLimit => _postsQueryLimit;
  set setPostsQueryLimit(int postsQueryLimit) {
    _postsQueryLimit = postsQueryLimit;
  }


  // startMap for checkpoint for get posts
  Map<String, dynamic> _queryStartAfterMap;
  Map<String, dynamic> get getQueryStartAfterMap => _queryStartAfterMap;
  set setQueryStartAfterMap(Map<String, dynamic> queryStartAfterMap) {
    _queryStartAfterMap = queryStartAfterMap;
  }


  // List of posts
  List<PostModel> _postsList;
  List<PostModel> get getPostsList => _postsList;
  set setPostsList(List<PostModel> postsList) {
    _postsList = postsList;
  }

  // has more posts to loaded
  bool _hasMorePosts;
  bool get getHasMorePosts => _hasMorePosts;
  set setHasMorePosts(bool hasMorePosts) {
    _hasMorePosts = hasMorePosts;
  }


  // has loaded posts to avoid repetition of posts
  // bloc provider implements this
  bool _hasLoadedPosts;
  bool get getHasLoadedPosts => _hasLoadedPosts;
  set setHasLoadedPosts(bool hasLoadedPosts) {
    _hasLoadedPosts = hasLoadedPosts;
  }


  // stores post typee e.g image, video, audio etc
  String _postType;
  String get getPostType => _postType;
  set setPostType(String postType) {
    _postType = postType;
  }

  String _postAudience;
  String get getPostAudience => _postAudience;
  set setPostAudience(String postAudience) {
    _postAudience = postAudience;
  }

  bool _isCurrentUserAFriend;
  bool get getIsCurrentUserAFriend => _isCurrentUserAFriend;
  set setIsCurrentUserAFriend(bool isCurrentUserAFriend) {
    _isCurrentUserAFriend = isCurrentUserAFriend;
  }


  // Stream post type
  BehaviorSubject<String> _postTypeBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getPostTypeStream => _postTypeBehaviorSubject.stream;
  StreamSink<String> get _getPostTypeSink => _postTypeBehaviorSubject.sink;
  StreamSubscription<String> getPostTypeStreamSubscription;

  // stream postList
  BehaviorSubject<List<PostModel>> _postsListBehaviorSubject = BehaviorSubject<List<PostModel>>();
  Stream<List<PostModel>> get getPostsListStream => _postsListBehaviorSubject.stream;
  StreamSink<List<PostModel>> get _getPostsListSink => _postsListBehaviorSubject.sink;

  // stream has more posts
  BehaviorSubject<bool> _hasMorePostsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMorePostsStream => _hasMorePostsBehaviorSubject.stream;
  StreamSink<bool> get _getHasMorePostsSink => _hasMorePostsBehaviorSubject.sink;





  // Streaming user profile data
  BehaviorSubject<UserModel> _profileUserModelBehaviorSubject = BehaviorSubject<UserModel>();
  Stream<UserModel> get getProfileUserModelStream => _profileUserModelBehaviorSubject.stream;
  StreamSink<UserModel> get _getProfileUserModelSink => _profileUserModelBehaviorSubject.sink;


  // Streaming user profile data
  BehaviorSubject<UserModel> _currentUserModelBehaviorSubject = BehaviorSubject<UserModel>();
  Stream<UserModel> get getCurrentUserModelStream => _currentUserModelBehaviorSubject.stream;
  StreamSink<UserModel> get _getCurrentUserModelSink => _currentUserModelBehaviorSubject.sink;


  // Streaming user profile state
  BehaviorSubject<String> _profileStateBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getProfileStateStream => _profileStateBehaviorSubject.stream;
  StreamSink<String> get _getProfileStateSink => _profileStateBehaviorSubject.sink;


  // Streaming number of Followers
  BehaviorSubject<int> _numberOfFollowersBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getNumberOfFollowersStream => _numberOfFollowersBehaviorSubject.stream;
  StreamSink<int> get _getNumberOfFollowersSink => _numberOfFollowersBehaviorSubject.sink;


  int _numberOfFollowers;
  int get getNumberOfFollowers => _numberOfFollowers;
  set setNumberOfFollowers(int numberOfFollowers) {
    _numberOfFollowers = numberOfFollowers;
  }



  // number of Followings stream
  BehaviorSubject<int> _numberOfFollowingsBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getNumberOfFollowingsStream => _numberOfFollowingsBehaviorSubject.stream;
  StreamSink<int> get _getNumberOfFollowingsSink => _numberOfFollowingsBehaviorSubject.sink;


  // number of posts stream
  BehaviorSubject<int> _numberOfPostsBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getNumberOfPostsStream => _numberOfPostsBehaviorSubject.stream;
  StreamSink<int> get _getNumberOfPostsSink => _numberOfPostsBehaviorSubject.sink;


  // Streaming number of Followers
  BehaviorSubject<bool> _isCurrentUserProfileBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsCurrentUserProfileStream => _isCurrentUserProfileBehaviorSubject.stream;
  StreamSink<bool> get _getIsCurrentUserProfileSink => _isCurrentUserProfileBehaviorSubject.sink;



  // Stream if current user and profile users are friends
  BehaviorSubject<bool> _isProfileUserAndCurrentUserFriendsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsProfileUserAndCurrentUserFriendsStream => _isProfileUserAndCurrentUserFriendsBehaviorSubject.stream;
  StreamSink<bool> get _getIsProfileUserAndCurrentUserFriendsSink => _isProfileUserAndCurrentUserFriendsBehaviorSubject.sink;



  // Streaming number of Followers
  BehaviorSubject<int> _numberOfFriendsBehaviorSubject = BehaviorSubject<int>();
  Stream<int> get getNumberOfFriendsStream => _numberOfFriendsBehaviorSubject.stream;
  StreamSink<int> get _getNumberOfFriendsSink => _numberOfFriendsBehaviorSubject.sink;


  BehaviorSubject<RewardPointsModel> _achievedRewardPointsModelBehaviorSubject = BehaviorSubject<RewardPointsModel>();
  Stream<RewardPointsModel> get getAchievedRewardPointsModelStream => _achievedRewardPointsModelBehaviorSubject.stream;
  StreamSink<RewardPointsModel> get _getAchievedRewardPointsModelSink => _achievedRewardPointsModelBehaviorSubject.sink;

  BehaviorSubject<bool> _isProfileAudioInitialisedBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsProfileAudioInitialisedStream => _isProfileAudioInitialisedBehaviorSubject.stream;
  StreamSink<bool> get _getIsProfileAudioInitialisedSink => _isProfileAudioInitialisedBehaviorSubject.sink;


  // Variable to store profile repository
  ProfileRepository _profileRepository;


  // Constructor
  ProfileBloc({@required profileUserId}){

    // get profile repository through dependency injection
    _profileRepository = ProfileDependencyInjector().getProfileRepository;


    /*
    // gets profile user data and sends it to a stream
    getProfileUserData(profileUserId: profileUserId).then((Map<String, dynamic> jsonData){
      setProfileUserModel = UserModel.fromJson(jsonData);
      addProfileUserModelToStream(profileUserModel: getProfileUserModel);
    });
    */


    initialiseProfileState(profileUserId: profileUserId);

    getTotalAchievedPoints(userId: profileUserId).then((int achievedPoints){

      RewardPointsModel rewardPointsModel = RewardPointsModel(points: achievedPoints);
      addAcheivedRewardPointsModelToStream(rewardPointsModel);
    });
  }


  List<PostModel> setProfilePostsData({@required List<PostModel> postsList, @required UserModel profileUserModel}){

    List<PostModel> processedList = List<PostModel>();

    for (int index = 0; index < postsList.length; ++index){

      //String postId = postsList[index].postId;

      postsList[index].userName = profileUserModel.username;
      postsList[index].userProfileName = profileUserModel.profileName;
      postsList[index].verifiedUser = profileUserModel.verifiedUser;
      postsList[index].userThumb = profileUserModel.profileThumb;

      processedList.add(postsList[index]);
    }

    return postsList;
  }



  // Initialises profile
  // Checks if current User is profile user and setups up profile accordingly
  Future<void> initialiseProfileState({@required profileUserId})async{

    // sets video query limit
    setPostsQueryLimit = DatabaseQueryLimits.POSTS_QUERY_LIMIT;


    setProfileUserId = profileUserId;
    FirebaseUser firebaseCurrentUser = await getFirebaseUser();
    setCurrentUserId = firebaseCurrentUser.uid;

    if (getCurrentUserId == getProfileUserId){

      addProfileStateToStream(profileState: ProfileState.admin);
      addIsCurrentUserProfile(true);
    }
    else{
      addIsCurrentUserProfile(false);
    }



    // Gets Profile user data and adds it to stream
    UserModel profileUserModel = await getProfileUserData(profileUserId: profileUserId);
    setProfileUserModel = profileUserModel;
    addProfileUserModelToStream(profileUserModel: getProfileUserModel);
    addBackgroundImageToStream(this.getProfileUserModel.profileThumb);


    // add number of friends of profile user to stream
    if (this.getProfileUserModel.friends != null){
      addNumberOfFriendsToStream(this.getProfileUserModel.friends?.length);
    }


    if (getCurrentUserId != getProfileUserId){
      UserModel currentUserModel = await getProfileUserData(profileUserId: getCurrentUserId);
      setCurrentUserModel = currentUserModel;
      addCurrentUserModelToStream(currentUserModel: currentUserModel);

      if(currentUserModel.friends != null && getProfileUserModel.friends != null){

        bool usersAreFriends = false;

        // checking if profileUserId is found in current user Friend List
        for (int index = 0; index < currentUserModel.friends.length; ++index){


          FriendModel friendModelOfCurrentUser = FriendModel.fromJson(currentUserModel.friends[index]);

          if (friendModelOfCurrentUser.userId == profileUserId){

            // checking if current user is found in profile user friend list
            for (int position = 0; position < getProfileUserModel.friends.length; ++position){

              FriendModel friendModelOfProfileUser = FriendModel.fromJson(getProfileUserModel.friends[position]);

              if (friendModelOfProfileUser.userId == getCurrentUserId){
                addIsProfileUserAndCurrentUserFriends(true);

                usersAreFriends = true;
                break;
              }
            }

          }
        }


        if (usersAreFriends == false || usersAreFriends == null){
          addIsProfileUserAndCurrentUserFriends(false);
        }

      }
      else{
        addIsProfileUserAndCurrentUserFriends(false);
      }
    }





    if (getCurrentUserId == getProfileUserId){
      setPostAudience = PostAudience.private;
      loadPosts(
          profileUserId: profileUserId,
          postType: getPostType,
          postQueryType: POST_QUERY_TYPE.MOST_RECENT,
          postQueryLimit: getPostsQueryLimit
      );
    }
    else if (getIsCurrentUserAFriend == true){
      // loads first set of posts
      setPostAudience = PostAudience.private;
      loadPosts(
          profileUserId: profileUserId,
          postType: getPostType,
          postQueryType: POST_QUERY_TYPE.MOST_RECENT,
          postQueryLimit: getPostsQueryLimit
      );
    }
    else{
      setPostAudience = PostAudience.public;
      loadPosts(
          profileUserId: profileUserId,
          postType: getPostType,
          postQueryType: POST_QUERY_TYPE.MOST_RECENT,
          postQueryLimit: getPostsQueryLimit
      );
    }







    // adds background image to stream
    //addBackgroundImageToStream(getProfileUserModel.profileThumb);

    getNumberFollowers(profileUserId: getProfileUserId).then((int numFollowers){
      addNumberOfFollowersToStream(numFollowers);
      setNumberOfFollowers = numFollowers;
    });
    getNumberFollowings(profileUserId: getProfileUserId).then((int numFollowings){
      addNumberOfFollowingsToStream(numFollowings);
    });
    getNumberOfPosts(profileUserId: getProfileUserId).then((int numPosts){
      addNumberOfPostsToStream(numPosts);
    });
  }


  void loadPosts({@required String profileUserId, @required String postType = null, @required POST_QUERY_TYPE postQueryType, @required int postQueryLimit, }){

    this.setPostsList = List<PostModel>();
    this.setHasMorePosts = false;
    setHasLoadedPosts = false;

    addHasMorePostsToStream(true);

    addPostTypeToStream(postType);


    getProfileUserPostsData(
        profileUserId: profileUserId,
        postType: postType,
        postQueryType: postQueryType,
        postAudience: this.getPostAudience,
        queryLimit: postQueryLimit,
        startAfterMap: null
    ).then((postsList){

      this.getPostsList.clear();

      if (postsList.length < postQueryLimit){

        List<PostModel> postsListRefined = setProfilePostsData(postsList: postsList, profileUserModel: getProfileUserModel);
        getPostsList.addAll(postsListRefined);

        addPostsListToStream(this.getPostsList);

        this.setHasMorePosts = false;
        addHasMorePostsToStream(false);
        return;
      }
      else{


        setQueryStartAfterMap = postsList.last.toJson();

        List<PostModel> postsListRefined = setProfilePostsData(postsList: postsList, profileUserModel: getProfileUserModel);
        getPostsList.addAll(postsListRefined);

        addPostsListToStream(this.getPostsList);

        this.setHasMorePosts = true;
        addHasMorePostsToStream(true);
      }

    });
  }




  Future<void> loadMorePosts({@required profileUserId, @required String postType = null,  @required POST_QUERY_TYPE postQueryType, @required int postQueryLimit})async{


    addHasMorePostsToStream(true);

    if (getHasMorePosts){


      List<PostModel> postsList = await getProfileUserPostsData(
        profileUserId: profileUserId,
          postType: postType,
          postAudience: this.getPostAudience,
          postQueryType: postQueryType,
          queryLimit: postQueryLimit,
          startAfterMap: getQueryStartAfterMap
      );


      if (postsList.length < postQueryLimit){

        List<PostModel> postsListRefined = setProfilePostsData(postsList: postsList, profileUserModel: getProfileUserModel);
        getPostsList.addAll(postsListRefined);
        addPostsListToStream(this.getPostsList);


        setHasMorePosts = false;
        addHasMorePostsToStream(false);
      }
      else{

        setQueryStartAfterMap = postsList.last.toJson();

        List<PostModel> postsListRefined = setProfilePostsData(postsList: postsList, profileUserModel: getProfileUserModel);
        getPostsList.addAll(postsListRefined);

        addPostsListToStream(this.getPostsList);


        setHasMorePosts = true;
        addHasMorePostsToStream(true);
      }


    }
    else{

      addHasMorePostsToStream(false);
      setHasMorePosts = false;
    }

  }





  void addIsProfileAudioInitialisedToStream(bool isProfileAudioInitialised){
    _getIsProfileAudioInitialisedSink.add(isProfileAudioInitialised);
  }

  void addAcheivedRewardPointsModelToStream(RewardPointsModel achievedRewardPointsModelToStream){
    _getAchievedRewardPointsModelSink.add(achievedRewardPointsModelToStream);
  }

  void addHasMorePostsToStream(bool hasMorePosts){

    _getHasMorePostsSink.add(hasMorePosts);
  }

  void addPostsListToStream(List<PostModel> postsList){
    _getPostsListSink.add(postsList);
  }

  void addPostTypeToStream(String postType){

    this.setPostType = postType;
    _getPostTypeSink.add(postType);
  }



  void addNumberOfFriendsToStream(int numberOfFriends){
    _getNumberOfFriendsSink.add(numberOfFriends);
  }

  void addIsProfileUserAndCurrentUserFriends(bool isProfileUserAndCurrentUserFriends){
    setIsCurrentUserAFriend = isProfileUserAndCurrentUserFriends;
    _getIsProfileUserAndCurrentUserFriendsSink.add(isProfileUserAndCurrentUserFriends);
  }

  void addIsCurrentUserProfile(bool isCurrentUserProfile){
    _getIsCurrentUserProfileSink.add(isCurrentUserProfile);
  }

  // Adds Profile User data to stream
  void addProfileUserModelToStream({@required UserModel profileUserModel}){
    _getProfileUserModelSink.add(profileUserModel);
  }


  // Adds Profile User data to stream
  void addCurrentUserModelToStream({@required UserModel currentUserModel}){
    _getCurrentUserModelSink.add(currentUserModel);
  }


  // Adds Profile state to stream
  void addProfileStateToStream({@required String profileState}){
    _getProfileStateSink.add(profileState);
  }

  void addNumberOfPostsToStream(int numberOfPosts){
    _getNumberOfPostsSink.add(numberOfPosts);
  }

  void addNumberOfFollowingsToStream(int numberOfFollowings){
    _getNumberOfFollowingsSink.add(numberOfFollowings);
  }

  void addNumberOfFollowersToStream(int numberOfFollowers){
    _getNumberOfFollowersSink.add(numberOfFollowers);
  }


  // Get profile user data from database
  @override
  Future<UserModel> getProfileUserData({@required String profileUserId}) async {

    return await _profileRepository.getProfileUserData(profileUserId: profileUserId);
  }


  // Checks if current User is a follower of Profile User
  // This is excluded if current User == profile user
  @override
  Stream<Event> checkCurrentUserIsAFollowerStreamEvent({@required String currentUserId, @required profileUserId}) {
    return _profileRepository.checkCurrentUserIsAFollowerStreamEvent(currentUserId: currentUserId, profileUserId: profileUserId);
  }


  @override
  Stream<Event> checkProfileUserIsCurrentUserFollowerStreamEvent({@required String currentUserId, @required profileUserId}) {
    return _profileRepository.checkProfileUserIsCurrentUserFollowerStreamEvent(currentUserId: currentUserId, profileUserId: profileUserId);
  }


  // Adds current User to Profile User follower list
  // This is excluded if current User == profile user
  @override
  Future<Function> addProfileUserFollower({@required OptimisedFFModel optimisedFFModel, @required String profileUserId})async {
    await _profileRepository.addProfileUserFollower(optimisedFFModel: optimisedFFModel, profileUserId: profileUserId);
  }


  // adds profile user to current user list
  // This is excluded if current User == profile user
  @override
  Future<Function> addCurrentUserFollowing({@required OptimisedFFModel optimisedFFModel, @required String currentUserId})async {
    await _profileRepository.addCurrentUserFollowing(optimisedFFModel: optimisedFFModel, currentUserId: currentUserId);
  }


  // Removes current user from profile user list
  // This is excluded if current User == profile user
  @override
  Future<Function> removeProfileUserFollower({@required String currentUserId, @required String profileUserId}) async {
    await _profileRepository.removeProfileUserFollower(currentUserId: currentUserId, profileUserId: profileUserId);
  }


  // Removes profile user from current user list
  // This is excluded if current User == profile user
  @override
  Future<Function> removeCurrentUserFollowing({@required String profileUserId, @required String currentUserId})async {
    await _profileRepository.removeCurrentUserFollowing(profileUserId: profileUserId, currentUserId: currentUserId);
  }


  // Gets Firebase user data data
  // Note that this is not the user data stored in the database
  // This is data gotten from firebase authentication
  @override
  Future<FirebaseUser> getFirebaseUser()async {
    return await _profileRepository.getFirebaseUser();
  }


  @override
  Future<int> getNumberFollowers({@required String profileUserId})async {
    return await _profileRepository.getNumberFollowers(profileUserId: profileUserId);
  }


  // Gets Future for Profile user number of followings
  // This data is not streamed and only gotten once when the page is loaded
  @override
  Future<int> getNumberFollowings({@required String profileUserId}) async{
    return await _profileRepository.getNumberFollowings(profileUserId: profileUserId);
  }


  // Gets Future for Profile user number of videos
  // This data is not streamed and only gotten once when the page is loaded
  @override
  Future<int> getNumberOfPosts({@required String profileUserId})async {
    return await _profileRepository.getNumberOfPosts(profileUserId: profileUserId);
  }


  // Gets stream for Profile user number of videos
  @override
  Stream<Event> getNumberOfPostsStreamEvent({@required String profileUserId}) {
    return _profileRepository.getNumberOfPostsStreamEvent(profileUserId: profileUserId);
  }


  // Uploads file to server storage
  @override
  Future<String> uploadFile({@required storagePath, @required File file})async {
    return await _profileRepository.uploadFile(storagePath: storagePath, file: file);
  }




  @override
  Future<bool> removeFile({@required String urlPath})async {
    return await _profileRepository.removeFile(urlPath: urlPath);
  }


  @override
  Future<List<PostModel>> getProfileUserPostsData({
    @required String profileUserId,
    @required postType = null,
    @required String postAudience,
    @required POST_QUERY_TYPE postQueryType = POST_QUERY_TYPE.MOST_RECENT,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap}) async{

    return await _profileRepository.getProfileUserPostsData(
        profileUserId: profileUserId,
        postType: postType,
        postAudience: postAudience,
        postQueryType: postQueryType,
        queryLimit: queryLimit,
        startAfterMap: startAfterMap
    );
  }


  @override
  Future<Function> removePostData({@required String postId, @required String currentUserId})async {
    await _profileRepository.removePostData(postId: postId, currentUserId: currentUserId);
  }


  @override
  Future<bool> deleteFile({@required String urlPath})async {

    return await _profileRepository.deleteFile(urlPath: urlPath);
  }


  @override
  Future<Function> removePostComments({@required String postId, @required String postUserId})async {
    await _profileRepository.removePostComments(postId: postId, postUserId: postUserId);
  }

  @override
  Future<Function> removePostLikes({@required String postId, @required String postUserId})async {
    await _profileRepository.removePostLikes(postId: postId, postUserId: postUserId);
  }


  @override
  Future<Function> removeOptimisedPostData({@required String postId, @required String currentUserId})async {
    await _profileRepository.removeOptimisedPostData(postId: postId, currentUserId: currentUserId);
  }


  @override
  Stream<Event> checkCurrentUserSentFriendRequestToProfileUserStreamEvent({@required String currentUserId, @required profileUserId}) {
    return _profileRepository.checkCurrentUserSentFriendRequestToProfileUserStreamEvent(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Stream<Event> checkProfileUserSentFriendRequestToCurrentUserStreamEvent({@required String currentUserId, @required profileUserId}) {
    return _profileRepository.checkProfileUserSentFriendRequestToCurrentUserStreamEvent(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Future<Function> sendFriendRequest({@required String currentUserId, @required String profileUserId})async {

    await _profileRepository.sendFriendRequest(currentUserId: currentUserId, profileUserId: profileUserId);
  }

  @override
  Future<Function> removeFriendRequest({@required String currentUserId, @required String profileUserId})async {

    await _profileRepository.removeFriendRequest(currentUserId: currentUserId, profileUserId: profileUserId);
  }


  @override
  Future<Function> sendFriendRequestNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId})async {

    await _profileRepository.sendFriendRequestNotification(optimisedNotificationModel: optimisedNotificationModel, profileUserId: profileUserId);
  }


  @override
  Future<Function> addFriendToUserFriendList({@required FriendModel friendModel, @required String userId})async {
    await _profileRepository.addFriendToUserFriendList(friendModel: friendModel, userId: userId);
  }


  @override
  Future<Function> sendFriendRequestAcceptedNotification({@required OptimisedNotificationModel optimisedNotificationModel, @required String profileUserId})async {
    await _profileRepository.sendFriendRequestAcceptedNotification(optimisedNotificationModel: optimisedNotificationModel, profileUserId: profileUserId);
  }


  @override
  Future<bool> checkIfUserSentFriendRequestNotification({@required String currentUserId, @required String profileUserId})async {
    return await _profileRepository.checkIfUserSentFriendRequestNotification(currentUserId: currentUserId, profileUserId: profileUserId);
  }


  @override
  Future<Function> removeFriendRequestNotification({@required String currentUserId, @required String profileUserId})async {
    await _profileRepository.removeFriendRequestNotification(currentUserId: currentUserId, profileUserId: profileUserId);
  }


  @override
  Future<int> getTotalAchievedPoints({@required String userId})async {
    return await _profileRepository.getTotalAchievedPoints(userId: userId);
  }


  @override
  Future<File> getCachedNetworkFile({@required String urlPath})async {
    return await _profileRepository.getCachedNetworkFile(urlPath: urlPath);
  }




  // Dispose all resources
  @override
  void dispose() {

    _profileStateBehaviorSubject?.close();
    _profileUserModelBehaviorSubject?.close();
    _currentUserModelBehaviorSubject?.close();

    _backgroundImageBehaviorSubject?.close();


    _postsListBehaviorSubject?.close();
    _hasMorePostsBehaviorSubject?.close();
    _postTypeBehaviorSubject?.close();


    _numberOfFollowersBehaviorSubject?.close();
    _numberOfFollowingsBehaviorSubject?.close();
    _numberOfPostsBehaviorSubject?.close();

    _isCurrentUserProfileBehaviorSubject?.close();
    _isProfileUserAndCurrentUserFriendsBehaviorSubject?.close();

    _achievedRewardPointsModelBehaviorSubject?.close();
    _isProfileAudioInitialisedBehaviorSubject?.close();
  }

}

