import 'package:iris_social_network/services/constants/app_constants.dart';

import 'private_chat_room_repository.dart';
import 'private_chat_room_dependency_injection.dart';
import 'package:iris_social_network/services/platform_channels/phone_contacts.dart';
import 'dart:async';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:rxdart/rxdart.dart';




abstract class PrivateChatRoomBlocBlueprint{

  Future<List<ContactModel>> getContactsData({@required String currentUserId});

  Future<void> addContactsData({@required List<ContactModel> contactModels, @required currentUserId});

  Future<List<ContactModel>> getContactsFromMobile();

  Future<FirebaseUser> getFirebaseCurrentUser();


  Future<List<String>> getPhoneNumberListFromSharedPrefs();

  Future<List<ContactModel>> savePhoneNumbersToSharedPrefs({@required List<ContactModel> contactModels});


  Future<UserModel> getAllCurrentUserData({@required String currentUserId});

  Future<OptimisedChatModel> getChatUserChatData({@required String currentUserId,  @required String chatUserId});

  Stream<Event> getChatsDataEvent({@required String currentUserId, @required int queryLimit, @required int endAtValue});

  Future<void> setChatSeen({@required String currentUserId, @required String chatUserId});

  Stream<Event> getChatSeenStreamEvent({@required String currentUserId, @required String chatUserId});

  Future<String> getUserUserName({@required String userId});

  Future<String> getUserProfileName({@required String userId});

  Future<String> getUserProfileThumb({@required String userId});

  Future<bool> getIsUserVerified({@required String userId});


  Stream<Event> getChatUserOnlineStatus({@required String chatUserId});

  Stream<Event> getChatUserTypingStatus({@required currentUserId, @required String chatUserId});

  void dispose();
}



class PrivateChatRoomBloc extends PrivateChatRoomBlocBlueprint{

  UserModel _currentUserData;
  UserModel get getCurrentUserData => _currentUserData;
  set setCurrentUserData(UserModel currentUserData) {
    _currentUserData = currentUserData;
  }

  String _currentUserId;
  String get getCurrentUserId => _currentUserId;
  set setCurrentUserId(String currentUserId) {
    _currentUserId = currentUserId;
  }





  int _chatsQueryLimit;
  int get getChatsQueryLimit => _chatsQueryLimit;
  set setChatsQueryLimit(int chatsQueryLimit) {
    _chatsQueryLimit = chatsQueryLimit;
  }



  int _queryEndAtValue;
  int get getQueryEndAtValue => _queryEndAtValue;
  set setQueryEndAtValue(int queryEndAtValue) {
    _queryEndAtValue = queryEndAtValue;
  }


  // List of chats
  List<OptimisedChatModel> _ChatsList;
  List<OptimisedChatModel> get getChatsList => _ChatsList;
  set setChatsList(List<OptimisedChatModel> chatsList) {
    _ChatsList = chatsList;
  }


  bool _hasMoreChats;
  bool get getHasMoreChats => _hasMoreChats;
  set setHasMoreChats(bool hasMoreChats) {
    _hasMoreChats = hasMoreChats;
  }
  
  

  // has loaded chats to avoid repetition of chats
  // bloc provider implements this
  bool _hasLoadedChats;
  bool get getHasLoadedChats => _hasLoadedChats;
  set setHasLoadedChats(bool hasLoadedChats) {
    _hasLoadedChats = hasLoadedChats;
  }




  // Streaming all contacts on phone found in database
  BehaviorSubject<List<ContactModel>> _contactsDataBehaviorSubject = BehaviorSubject<List<ContactModel>>();
  Stream<List<ContactModel>> get getContactsDataStream => _contactsDataBehaviorSubject.stream;
  Sink<List<ContactModel>> get _getContactsDataSink => _contactsDataBehaviorSubject.sink;



  // Streaming all private chats in the database of current user
  BehaviorSubject<List<OptimisedChatModel>> _chatsListBehaviorSubject = BehaviorSubject<List<OptimisedChatModel>>();
  Stream<List<OptimisedChatModel>> get getChatsListStream => _chatsListBehaviorSubject.stream;
  Sink<List<OptimisedChatModel>> get _getChatsListSink => _chatsListBehaviorSubject.sink;
  StreamSubscription<Event> _loadChatsListEventStreamSubscription;
  StreamSubscription<Event> _loadMoreChatsListEventStreamSubscription;




  BehaviorSubject<bool> _hasMoreChatsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMoreChatsStream => _hasMoreChatsBehaviorSubject.stream;
  StreamSink<bool> get _getHasMoreChatsSink => _hasMoreChatsBehaviorSubject.sink;





  // Private chat repository dependency
  PrivateChatRoomRepository _privateChatRoomRepository;

  PrivateChatRoomBloc({@required String currentUserId}){

    // getting repository dependency
    _privateChatRoomRepository = PrivateChatRoomDependencyInjector().getPrivateChatRoomRepository;



    if (currentUserId != null){

      setCurrentUserId = currentUserId;

      getAllCurrentUserData(currentUserId: currentUserId).then((UserModel userModel){
        setCurrentUserData = userModel;
      });

      setChatsList = List<OptimisedChatModel>();
      setHasMoreChats = true;
      setHasLoadedChats = false;
      setChatsQueryLimit = DatabaseQueryLimits.CHATS_QUERY_LIMIT;

      loadChats(currentUserId: currentUserId, queryLimit: DatabaseQueryLimits.CHATS_QUERY_LIMIT, endAtValue: null);
    }
    else{

      getFirebaseCurrentUser().then((FirebaseUser firebaseCurrentUser){

        if (firebaseCurrentUser != null){

          setCurrentUserId = firebaseCurrentUser.uid;

          getAllCurrentUserData(currentUserId: firebaseCurrentUser.uid).then((UserModel userModel){
            setCurrentUserData = userModel;
          });

          setChatsList = List<OptimisedChatModel>();
          setHasMoreChats = true;
          setHasLoadedChats = false;
          setChatsQueryLimit = DatabaseQueryLimits.CHATS_QUERY_LIMIT;

          loadChats(currentUserId: firebaseCurrentUser.uid, queryLimit: DatabaseQueryLimits.CHATS_QUERY_LIMIT, endAtValue: null);
        }

      });
    }
    
  }




  Future<void> setUpChatsData({@required List<OptimisedChatModel> chatsList})async{


    for (int index = 0; index < chatsList.length; ++index){


      // Its working but still check this
      if (chatsList.length > 1 && index < chatsList.length - 1){
        if (chatsList[index].t == chatsList[index + 1].t){
          continue;
        }
      }


      String chatUserId = chatsList[index].chat_user_id;

      // using current user function to get chat user data
      UserModel chatUserModel = await this.getAllCurrentUserData(currentUserId: chatUserId);

      if (chatUserModel == null){
        continue;
      }

      chatsList[index].chatUserModel = chatUserModel;
      chatsList[index].name = chatUserModel.profileName;
      chatsList[index].thumb = chatUserModel.profileThumb;
      chatsList[index].username = chatUserModel.username;
      chatsList[index].v_user = chatUserModel.verifiedUser;


      this.getChatsList.add(chatsList[index]);
      addChatsListDataToStream(this.getChatsList);
    }
  }



  void loadChats({@required String currentUserId, @required int queryLimit,@required int endAtValue}){

    this.setChatsList = List<OptimisedChatModel>();


    _loadChatsListEventStreamSubscription = this.getChatsDataEvent(currentUserId: currentUserId, queryLimit: queryLimit, endAtValue: endAtValue).listen((Event event)async{


      bool isAnUpdate = false;

      Map<dynamic, dynamic> dataMap = event.snapshot.value;


      List<OptimisedChatModel> _chatsList = new List<OptimisedChatModel>();


      if(dataMap != null){


        dataMap.forEach((key, value)async{

          OptimisedChatModel optimisedChatModel = OptimisedChatModel.fromJson(value);
          if (optimisedChatModel.chat_user_id == null){
            optimisedChatModel.chat_user_id = key;
          }

          List<OptimisedChatModel> dummyList = List<OptimisedChatModel>();
          for (int index = 0; index < this.getChatsList.length; ++index){
            dummyList.add(OptimisedChatModel.fromJson(this.getChatsList[index].toJson()));
          }

          for (int index = 0; index < dummyList.length; ++index){
            if (optimisedChatModel.chat_user_id == dummyList[index].chat_user_id){

              isAnUpdate = true;

              UserModel userModel = await getAllCurrentUserData(currentUserId: optimisedChatModel.chat_user_id);

              if (userModel == null){
                continue;
              }

              this.getChatsList[index] = optimisedChatModel;
              this.getChatsList[index].chatUserModel = userModel;


              this.getChatsList[index].name = this.getChatsList[index].chatUserModel.profileName;
              this.getChatsList[index].username = this.getChatsList[index].chatUserModel.username;
              this.getChatsList[index].thumb = this.getChatsList[index].chatUserModel.profileThumb;
              this.getChatsList[index].v_user = this.getChatsList[index].chatUserModel.verifiedUser;


              // sort after update
              this.getChatsList.sort();

              addChatsListDataToStream(this.getChatsList);
              return;
            }
          }


          if (isAnUpdate == false){
            _chatsList.add(optimisedChatModel);
          }

        });

        _chatsList.sort();
      }


      if(isAnUpdate){
        return;
      }
      else{

        if (_chatsList.length < getChatsQueryLimit){

          this.setHasMoreChats = false;
          addHasMoreChatsToStream(false);
        }
        else{
          this.setQueryEndAtValue = _chatsList.removeLast().t;
        }


        setUpChatsData(chatsList: _chatsList).then((_){

          addChatsListDataToStream(this.getChatsList);
        });

      }


    });
    
  }



  Future<void> loadMoreChats({@required String currentUserId, @required int queryLimit, @required int endAtValue})async{


    if (getHasMoreChats){

      _loadMoreChatsListEventStreamSubscription = this.getChatsDataEvent(currentUserId: currentUserId, queryLimit: queryLimit, endAtValue: endAtValue).listen((Event event){

        bool isAnUpdate = false;

        // Preprocess event
        Map<dynamic, dynamic> dataMap = event.snapshot.value;
        List<OptimisedChatModel> chatsList = new List<OptimisedChatModel>();


        if(dataMap != null){
          dataMap.forEach((key, value)async{

            OptimisedChatModel optimisedChatModel = OptimisedChatModel.fromJson(value);
            if (optimisedChatModel.chat_user_id == null){
              optimisedChatModel.chat_user_id = key;
            }


            List<OptimisedChatModel> dummyList = List<OptimisedChatModel>();
            for (int index = 0; index < this.getChatsList.length; ++index){
              dummyList.add(OptimisedChatModel.fromJson(this.getChatsList[index].toJson()));
            }

            for (int index = 0; index < dummyList.length; ++index){
              if (optimisedChatModel.chat_user_id == dummyList[index].chat_user_id){

                isAnUpdate = true;

                UserModel userModel = await getAllCurrentUserData(currentUserId: optimisedChatModel.chat_user_id);

                if (userModel == null){
                  continue;
                }

                this.getChatsList[index] = optimisedChatModel;
                this.getChatsList[index].chatUserModel = userModel;

                this.getChatsList[index].name = this.getChatsList[index].chatUserModel.profileName;
                this.getChatsList[index].username = this.getChatsList[index].chatUserModel.username;
                this.getChatsList[index].thumb = this.getChatsList[index].chatUserModel.profileThumb;
                this.getChatsList[index].v_user = this.getChatsList[index].chatUserModel.verifiedUser;

                // sort after update
                this.getChatsList.sort();

                addChatsListDataToStream(this.getChatsList);
                return;
              }
            }


            if(isAnUpdate == false){
              chatsList.add(optimisedChatModel);
            }

          });
        }


        if(isAnUpdate){
          return;
        }
        else{
          if (chatsList.length < getChatsQueryLimit){
            this.setHasMoreChats = false;
            addHasMoreChatsToStream(false);
          }
          else{

            setQueryEndAtValue = chatsList.removeLast().t;
          }

          chatsList.sort();
          setUpChatsData(chatsList: chatsList).then((_){

            addChatsListDataToStream(this.getChatsList);
          });
        }




      });
      

    }
    else{
      addHasMoreChatsToStream(false);
      setHasMoreChats = false;

    }

  }



  void addHasMoreChatsToStream(bool hasMoreVideos){
    _getHasMoreChatsSink.add(hasMoreVideos);
  }


  void addContactsDataToStream(List<ContactModel> contacts){

    _getContactsDataSink.add(contacts);
  }


  void addChatsListDataToStream(List<OptimisedChatModel> chatsList){

    _getChatsListSink.add(chatsList);
  }



  @override
  Future<void> addContactsData({@required List<ContactModel> contactModels, @required currentUserId}) async {
    await _privateChatRoomRepository.addContactsData(contactModels: contactModels, currentUserId: currentUserId);
  }


  @override
  Future<List<ContactModel>> getContactsData({@required String currentUserId}) async {
    return await _privateChatRoomRepository.getContactsData(currentUserId: currentUserId);
  }


  @override
  Future<List<ContactModel>> getContactsFromMobile() async {
    return await _privateChatRoomRepository.getContactsFromMobile();
  }


  @override
  Future<FirebaseUser> getFirebaseCurrentUser() async{
    return await _privateChatRoomRepository.getFirebaseCurrentUser();
  }


  @override
  Future<List<String>> getPhoneNumberListFromSharedPrefs() async {
    return await _privateChatRoomRepository.getPhoneNumberListFromSharedPrefs();
  }


  @override
  Future<List<ContactModel>> savePhoneNumbersToSharedPrefs({@required List<ContactModel> contactModels}) async {
    return await _privateChatRoomRepository.savePhoneNumbersToSharedPrefs(contactModels: contactModels);
  }


  @override
  Future<UserModel> getAllCurrentUserData({@required String currentUserId}) async{
    return await _privateChatRoomRepository.getAllCurrentUserData(currentUserId: currentUserId);
  }


  @override
  Future<OptimisedChatModel> getChatUserChatData({@required String currentUserId, @required String chatUserId})async {

    return await _privateChatRoomRepository.getChatUserChatData(currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Stream<Event> getChatsDataEvent({@required String currentUserId, @required int queryLimit, @required int endAtValue}) {
    return _privateChatRoomRepository.getChatsDataEvent(currentUserId: currentUserId, queryLimit: queryLimit, endAtValue: endAtValue);
  }


  @override
  Future<Function> setChatSeen({@required String currentUserId, @required String chatUserId}) async {
    await _privateChatRoomRepository.setChatSeen(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Stream<Event> getChatSeenStreamEvent({@required String currentUserId, @required String chatUserId}) {
    return _privateChatRoomRepository.getChatSeenStreamEvent(currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<String> getUserUserName({@required String userId})async {

    return await _privateChatRoomRepository.getUserUserName(userId: userId);
  }


  @override
  Future<String> getUserProfileName({@required String userId})async {

    return await _privateChatRoomRepository.getUserProfileName(userId: userId);
  }

  @override
  Future<String> getUserProfileThumb({@required String userId})async {

    return await _privateChatRoomRepository.getUserProfileThumb(userId: userId);
  }

  @override
  Future<bool> getIsUserVerified({@required String userId})async {

    return await _privateChatRoomRepository.getIsUserVerified(userId: userId);
  }


  @override
  Stream<Event> getChatUserOnlineStatus({@required String chatUserId}) {
    return _privateChatRoomRepository.getChatUserOnlineStatus(chatUserId: chatUserId);
  }


  @override
  Stream<Event> getChatUserTypingStatus({@required currentUserId, @required String chatUserId}) {
    return _privateChatRoomRepository.getChatUserTypingStatus(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  void dispose() {


    _contactsDataBehaviorSubject?.close();
    _chatsListBehaviorSubject?.close();

    _loadChatsListEventStreamSubscription?.cancel();
    _loadMoreChatsListEventStreamSubscription?.cancel();

    _hasMoreChatsBehaviorSubject?.close();
  }


}


