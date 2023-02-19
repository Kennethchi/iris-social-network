import 'dart:async';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:iris_social_network/services/models/message_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat_repository.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat_dependency_injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'private_chat_validators.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'dart:io';
import 'package:rxdart/rxdart.dart';



abstract class PrivateChatBlocBlueprint{

  void dispose();

  Future<String>  addMessageData({@required MessageModel messageModel, @required String currentUserId, @required String chatUserId});


  Stream<QuerySnapshot> getMessagesDataEvent({
    @required String currentUserId, @required String chatUserId,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap});

  Stream<Event> getChatUserOnlineStatus({@required String chatUserId });

  Stream<Event> getChatUserTypingStatus({@required String currentUserId, @required String chatUserId});

  Future<void> addCurrentUserTypingStatus({@required String currentUserId, @required String chatUserId, @required bool isTyping});

  Future<void> onCurrentUserDisconnect({@required String currentUserId, @required String chatUserId});

  Future<void> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel});

  Future<FirebaseUser> getCurrentUser();

  Future<void> addNotificationData({@required OptimisedNotificationModel optimisedNotificationModel, @required String chatUserId});

  Future<void> updateChattersMessagesSeenField({@required String currentUserId, @required String chatUserId});

  Future<void> updateChattersSingleMessageSeenField({
    @required String currentUserId, @required String chatUserId, @required messageId});

  Future<void> setChatSeen({@required String currentUserId, @required String chatUserId});

  Future<void> setCurrentUserSentMessageState({@required String messageState, @required String messageId, @required String currentUserId, @required String chatUserId});

  Stream<Event> getCurrentUserSentMessageStateEvent({@required String messageId, @required String currentUserId, @required String chatUserId});

  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink});

  Future<File> getVideoThumbNailFile({@required File videoFile});

  Future<MediaInfo> getMediaInfo({@required String mediaPath});

  Future<File> compressVideo({@required String videoPath});

  Future<void>  removeMessageData({@required String messageId, @required String currentUserId, @required String chatUserId});

  Future<void> removeCurrentUserSentMessageState({@required String messageId, @required String currentUserId, @required String chatUserId});

  Future<void> setMessagesSeen({@required String currentUserId, @required String chatUserId});

  Future<String> getMessageState({@required String messageId, @required String currentUserId, @required String chatUserId});

  Future<void> setSingleMessageSeen({@required String currentUserId, @required String chatUserId});
}


class PrivateChatBloc extends PrivateChatBlocBlueprint with PrivateChatValidators{

  static final DURATION_BEFORE_SET_MESSAGE_AS_SEEN = Duration(seconds: 1);


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




  // current User model
  UserModel _currentUserModel;
  UserModel get getCurrentUserModel => _currentUserModel;
  set setCurrentUserModel(UserModel currentUserModel) {
    _currentUserModel = currentUserModel;
  }

  UserModel _chatUserModel;
  UserModel get getChatUserModel => _chatUserModel;
  set setChatUserModel(UserModel chatUserModel) {
    _chatUserModel = chatUserModel;
  }



  // message query limits
  int _messagesQueryLimit;
  int get getMessagesQueryLimit => _messagesQueryLimit;
  set setMessagesQueryLimit(int messagesQueryLimit) {
    _messagesQueryLimit = messagesQueryLimit;
  }


  // startMap for checkpoint for get messages
  Map<String, dynamic> _queryStartAfterMap;
  Map<String, dynamic> get getQueryStartAfterMap => _queryStartAfterMap;
  set setQueryStartAfterMap(Map<String, dynamic> queryStartAfterMap) {
    _queryStartAfterMap = queryStartAfterMap;
  }


  // List of messages
  List<MessageModel> _messagesList;
  List<MessageModel> get getMessagesList => _messagesList;
  set setMessagesList(List<MessageModel> messagesList) {
    _messagesList = messagesList;
  }

  // has more messages to loaded
  bool _hasMoreMessages;
  bool get getHasMoreMessages => _hasMoreMessages;
  set setHasMoreMessages(bool hasMoreMessages) {
    _hasMoreMessages = hasMoreMessages;
  }


  // has loaded messages to avoid repetition of messages
  // bloc provider implements this
  bool _hasLoadedMessages;
  bool get getHasLoadedMessages => _hasLoadedMessages;
  set setHasLoadedMessages(bool hasLoadedMessages) {
    _hasLoadedMessages = hasLoadedMessages;
  }


  MessageModel _referredMessageModel;
  MessageModel get getReferredMessageModel => _referredMessageModel;
  set setReferredMessageModel(MessageModel referredMessageModel) {
    _referredMessageModel = referredMessageModel;
  }

  // stream messageList
  BehaviorSubject<List<MessageModel>> _messagesListBehaviorSubject = BehaviorSubject<List<MessageModel>>();
  Stream<List<MessageModel>> get getMessagesListStream => _messagesListBehaviorSubject.stream;
  StreamSink<List<MessageModel>> get _getMessagesListSink => _messagesListBehaviorSubject.sink;

  StreamSubscription<QuerySnapshot> getLoadMessagesListQuerySnapshotStreamSubscription;
  StreamSubscription<QuerySnapshot> getLoadMoreMessagesListQuerySnapshotStreamSubscription;



  // stream has more messages
  BehaviorSubject<bool> _hasMoreMessagesBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMoreMessagesStream => _hasMoreMessagesBehaviorSubject.stream;
  StreamSink<bool> get _getHasMoreMessagesSink => _hasMoreMessagesBehaviorSubject.sink;




  // streaming chat user online status from realtime database
  BehaviorSubject<Event> _chatUserOnlineStatusEventBehaviorSubject = BehaviorSubject<Event>();
  Stream<Event> get getChatUserOnlineStatusEventStream => _chatUserOnlineStatusEventBehaviorSubject.stream;
  StreamSink<Event> get _getChatUserOnlineStatusEventSink => _chatUserOnlineStatusEventBehaviorSubject.sink;
  StreamSubscription<Event> _chatUserOnlineStatusEventStreamSubscription;


  // streaming current user online status from realtime database
  BehaviorSubject<Event> _currentUserOnlineStatusEventBehaviorSubject = BehaviorSubject<Event>();
  Stream<Event> get getCurrentUserOnlineStatusEventStream => _currentUserOnlineStatusEventBehaviorSubject.stream;
  StreamSink<Event> get _getCurrentUserOnlineStatusEventSink => _currentUserOnlineStatusEventBehaviorSubject.sink;
  StreamSubscription<Event> _currentUserOnlineStatusEventStreamSubscription;




  // streaming chat user typing status from realtime database
  BehaviorSubject<Event> _chatUserTypingStatusEventBehaviorSubject = BehaviorSubject<Event>();
  Stream<Event> get getChatUserTypingStatusEventStream => _chatUserTypingStatusEventBehaviorSubject.stream;
  StreamSink<Event> get _getChatUserTypingStatusEventSink => _chatUserTypingStatusEventBehaviorSubject.sink;
  StreamSubscription<Event> _chatUserTypingStatusEventStreamSubscription;




  // message Text Stream Controller
  BehaviorSubject<String> _textBehaviorSubject = BehaviorSubject<String>();
  Stream<String> get getTextStream => _textBehaviorSubject.stream.transform(textValidator);
  StreamSink<String> get _getTextSink => _textBehaviorSubject.sink;



  // Is Media Uploading stream
  BehaviorSubject<bool> _isMediaUploadingBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getIsMediaUploadingStream => _isMediaUploadingBehaviorSubject.stream;
  Sink<bool> get _getIsMediaUploadSink => _isMediaUploadingBehaviorSubject.sink;

  // Referred Message Model stream
  BehaviorSubject<MessageModel> _referredMessageModelBehaviorSubject = BehaviorSubject<MessageModel>();
  Stream<MessageModel> get getReferredMessageModelStream => _referredMessageModelBehaviorSubject.stream;
  Sink<MessageModel> get _getReferredMessageModelSink => _referredMessageModelBehaviorSubject.sink;


  // Repository
  PrivateChatRepository _privateChatRepository;


  PrivateChatBloc({@required UserModel chatUserModel, @required UserModel currentUserModel}){


    // Initialising private chat Repository
    _privateChatRepository = PrivateChatDependencyInjector().getPrivateChatRepository;


    // setting chat user model and current user model data
    setChatUserModel = chatUserModel;
    setCurrentUserModel = currentUserModel;


    /*
    //  Listen to message query snapshots to add it to stream controller
    _messageQuerySnapshotsStreamSubscription = getMessagesData(currentUserId: getCurrentUserModel.userId, chatUserId: getChatUserContactModel.userId).listen((QuerySnapshot querySnapshots){
      addMessageQuerySnapshotsToStream(messageQuerySnapshots: querySnapshots);
    });
    */

    //listen to chat user online state
    _chatUserOnlineStatusEventStreamSubscription = getChatUserOnlineStatus(chatUserId: chatUserModel.userId).listen((Event event){
      addChatUserOnlineStatusToStream(event: event);
    });

    //listen to current user online state
    _currentUserOnlineStatusEventStreamSubscription = getChatUserOnlineStatus(chatUserId: currentUserModel.userId).listen((Event event){
      addCurrentUserOnlineStatusToStream(event: event);
    });


    //listen to chat user typing state
    _chatUserTypingStatusEventStreamSubscription = getChatUserTypingStatus(currentUserId: currentUserModel.userId, chatUserId: chatUserModel.userId).listen((Event event){
      addChatUserTypingStatusToStream(event: event);
    });

    // sets user is typing to false_0 and other features to false_0 in relation to the private chat
    onCurrentUserDisconnect(currentUserId: currentUserModel.userId, chatUserId: chatUserModel.userId);



    //this.updateChattersMessagesSeenField(currentUserId: currentUserModel.userId, chatUserId: chatUserModel.userId);



    setMessagesQueryLimit = DatabaseQueryLimits.MESSAGES_QUERY_LIMIT;
    setHasMoreMessages = true;;
    setHasLoadedMessages = false;

    loadMessages(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId, messageQueryLimit: this.getMessagesQueryLimit);

    //setMessageSeen(messageId: null, currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId,);


    // obserbing percentage ratio transfer
    _observeCombineLatestProgressAndTotalTransfer = Observable.combineLatest2(getProgressTransferDataStream, getTotalTransferDataStream, (int progressTransfer, int totalTransfer){

      print("Sent: $progressTransfer, total: $totalTransfer");

      return progressTransfer / totalTransfer;
    }).listen((double percentProgressRatio){
      addPercentRatioProgress(percentProgressRatio);
    });

    addIsMediaUploadingToStream(false);
  }




  Future<void> loadMessages({@required String currentUserId, @required String chatUserId, @required int messageQueryLimit, })async{

    // Sets the messages loaded as seen
    this.setMessagesSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);


    this.setHasMoreMessages = true;
    addHasMoreMessagesToStream(true);

    this.setMessagesList = List<MessageModel>();


    getLoadMessagesListQuerySnapshotStreamSubscription = getMessagesDataEvent(
        currentUserId: currentUserId,
        chatUserId: chatUserId, 
        queryLimit: messageQueryLimit, 
        startAfterMap: null
    ).listen((QuerySnapshot querySnapshot){

      this.setMessagesList = List<MessageModel>();
      List<MessageModel> messagesList = new List<MessageModel>();

      if(querySnapshot.documents != null){

        for (int index = 0; index < querySnapshot.documents.length; ++index){

          Map<String, dynamic> messageMap = querySnapshot.documents[index].data;
          MessageModel messageModel = MessageModel.fromJson(messageMap);
          messageModel.message_id = querySnapshot.documents[index].reference.documentID;

          assert(messageModel.message_id != null, "Message Id from querySnapshot is null");

          messagesList.add(messageModel);

          Timer(DURATION_BEFORE_SET_MESSAGE_AS_SEEN, (){
            if(this.getCurrentUserModel.userId != messageModel.sender_id){
              this.setSingleMessageSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);
            }
          });

          if (messageModel.seen == false && messageModel.sender_id == this.getChatUserModel.userId){
            // Set also sets chatuser  seen field to true
            this.setChatSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);
          }
        }
      }



      this.getMessagesList.clear();


      if (messagesList.length < messageQueryLimit){

        getMessagesList.addAll(messagesList);

        addMessagesListToStream(this.getMessagesList);

        addHasMoreMessagesToStream(false);
        this.setHasMoreMessages = false;
        return;
      }
      else{

        this.setQueryStartAfterMap = messagesList.last.toJson();

        getMessagesList.addAll(messagesList);

        addMessagesListToStream(this.getMessagesList);

        addHasMoreMessagesToStream(true);
        this.setHasMoreMessages = true;
      }

    });
  }




  Future<void> loadMoreMessages({@required String currentUserId, @required String chatUserId, @required int messageQueryLimit,})async{

    // Sets the more messages loaded as seen
    this.setMessagesSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);


    setHasMoreMessages = true;
    addHasMoreMessagesToStream(true);


    if (getHasMoreMessages){


      getLoadMoreMessagesListQuerySnapshotStreamSubscription = getMessagesDataEvent(
          currentUserId: currentUserId, 
          chatUserId: chatUserId, 
          queryLimit: messageQueryLimit, 
          startAfterMap: this.getQueryStartAfterMap
      ).listen((QuerySnapshot querySnapshot){



        List<MessageModel> messagesList = new List<MessageModel>();

        if(querySnapshot.documents != null){

          for (int index = 0; index < querySnapshot.documents.length; ++index){

            Map<String, dynamic> messageMap = querySnapshot.documents[index].data;
            MessageModel messageModel = MessageModel.fromJson(messageMap);

            messageModel.message_id = querySnapshot.documents[index].reference.documentID;

            assert(messageModel.message_id != null, "Message Id from querySnapshot is null");

            messagesList.add(messageModel);

            Timer(DURATION_BEFORE_SET_MESSAGE_AS_SEEN, (){
              if(this.getCurrentUserModel.userId != messageModel.sender_id){
                this.setSingleMessageSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);
              }
            });

            if (messageModel.seen == false && messageModel.sender_id == this.getChatUserModel.userId){
              // Set also sets chatuser  seen field to true
              this.setChatSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);
            }
          }

        }


        if (messagesList.length < messageQueryLimit){

          getMessagesList.addAll(messagesList);

          addMessagesListToStream(this.getMessagesList);

          setHasMoreMessages = false;
          addHasMoreMessagesToStream(false);
        }
        else{

          setQueryStartAfterMap = messagesList.last.toJson();

          getMessagesList.addAll(messagesList);

          addMessagesListToStream(this.getMessagesList);

          setHasMoreMessages = true;
          addHasMoreMessagesToStream(true);
        }

      });

    }
    else{
      addHasMoreMessagesToStream(false);
      setHasMoreMessages = false;
    }

  }



  void addReferredMessageModelToStream(MessageModel referredMessageModel){
    setReferredMessageModel = referredMessageModel;
    _getReferredMessageModelSink.add(referredMessageModel);
  }

  void addIsMediaUploadingToStream(bool isMediaUploading){
    _getIsMediaUploadSink.add(isMediaUploading);
  }

  void addHasMoreMessagesToStream(bool hasMoreMessages){

    this.setHasMoreMessages = hasMoreMessages;
    _getHasMoreMessagesSink.add(hasMoreMessages);
  }

  void addMessagesListToStream(List<MessageModel> messagesList)async{

    // Sets the more messages loaded as seen
    this.setMessagesSeen(currentUserId: this.getCurrentUserModel.userId, chatUserId: this.getChatUserModel.userId);

    _getMessagesListSink.add(messagesList);
  }




  void addChatUserOnlineStatusToStream({@required Event event}){
    _getChatUserOnlineStatusEventSink.add(event);
  }

  void addCurrentUserOnlineStatusToStream({@required Event event}){
    _getCurrentUserOnlineStatusEventSink.add(event);
  }

  void addChatUserTypingStatusToStream({@required Event event}){
    _getChatUserTypingStatusEventSink.add(event);
  }

  void addTextToStream({@required text}){
    _getTextSink.add(text);
  }





  @override
  Future<String> addMessageData({@required MessageModel messageModel, @required String currentUserId, @required String chatUserId}) async {
    return await _privateChatRepository.addMessageData(messageModel: messageModel, currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Stream<QuerySnapshot> getMessagesDataEvent(
      {@required String currentUserId, @required String chatUserId, @required int queryLimit, @required Map<
          String,
          dynamic> startAfterMap}) {

    return _privateChatRepository.getMessagesDataEvent(currentUserId: currentUserId, chatUserId: chatUserId, queryLimit: queryLimit, startAfterMap: startAfterMap);
  }

  @override
  Stream<Event> getChatUserOnlineStatus({@required String chatUserId}) {
    return _privateChatRepository.getChatUserOnlineStatus(chatUserId: chatUserId);
  }






  @override
  Future<Function> addCurrentUserTypingStatus({@required String currentUserId, @required String chatUserId, @required bool isTyping}) async {
    await _privateChatRepository.addCurrentUserTypingStatus(currentUserId: currentUserId, chatUserId: chatUserId, isTyping: isTyping);
  }

  @override
  Stream<Event> getChatUserTypingStatus({@required String currentUserId, @required String chatUserId}){
    return _privateChatRepository.getChatUserTypingStatus(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<Function> onCurrentUserDisconnect({@required String currentUserId, @required String chatUserId}) async {
    await _privateChatRepository.onCurrentUserDisconnect(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<Function> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel}) async{
    await _privateChatRepository.addChatsData(chatUserChatterModel: chatUserChatterModel, currentUserChatterModel: currentUserChatterModel);
  }


  @override
  Future<FirebaseUser> getCurrentUser() async {
    return await _privateChatRepository.getCurrentUser();
  }

  @override
  Future<Function> addNotificationData({@required OptimisedNotificationModel optimisedNotificationModel, @required String chatUserId}) async {
    await _privateChatRepository.addNotificationData(optimisedNotificationModel: optimisedNotificationModel, chatUserId: chatUserId);
  }


  @override
  Future<Function> updateChattersMessagesSeenField({@required String currentUserId, @required String chatUserId})async {
    await _privateChatRepository.updateChattersMessagesSeenField(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<Function> updateChattersSingleMessageSeenField({@required String currentUserId, @required String chatUserId, @required messageId})async {
    await _privateChatRepository.updateChattersSingleMessageSeenField(
        currentUserId: currentUserId,
        chatUserId: chatUserId,
        messageId: messageId);
  }


  @override
  Future<Function> setChatSeen({@required String currentUserId, @required String chatUserId})async {
    await _privateChatRepository.setChatSeen(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<Function> setCurrentUserSentMessageState(
      {@required String messageState, @required String messageId, @required String currentUserId, @required String chatUserId})async {
    await _privateChatRepository.setCurrentUserSentMessageState(messageState: messageState, messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Stream<Event> getCurrentUserSentMessageStateEvent({@required String messageId, @required String currentUserId, @required String chatUserId}) {
    return _privateChatRepository.getCurrentUserSentMessageStateEvent(messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {
    return await _privateChatRepository.uploadFile(sourceFile: sourceFile, filename: filename, progressSink: progressSink, totalSink: totalSink);
  }


  @override
  Future<File> getVideoThumbNailFile({@required File videoFile})async {
    return await _privateChatRepository.getVideoThumbNailFile(videoFile: videoFile);
  }


  @override
  Future<MediaInfo> getMediaInfo({@required String mediaPath})async {
    return await _privateChatRepository.getMediaInfo(mediaPath: mediaPath);
  }

  @override
  Future<File> compressVideo({@required String videoPath})async{
    return await _privateChatRepository.compressVideo(videoPath: videoPath);
  }

  @override
  Future<Function> removeMessageData({@required String messageId, @required String currentUserId, @required String chatUserId})async {
    await _privateChatRepository.removeMessageData(messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<Function> removeCurrentUserSentMessageState({@required String messageId, @required String currentUserId, @required String chatUserId})async {
    await _privateChatRepository.removeMessageData(messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<Function> setMessagesSeen({@required String currentUserId, @required String chatUserId})async {
    await _privateChatRepository.setMessagesSeen(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<String> getMessageState({@required String messageId, @required String currentUserId, @required String chatUserId})async{
    return await _privateChatRepository.getMessageState(messageId: messageId, currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Future<Function> setSingleMessageSeen({@required String currentUserId, @required String chatUserId})async {
    await _privateChatRepository.setSingleMessageSeen(currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  void dispose() {

    addCurrentUserTypingStatus(currentUserId: _currentUserModel.userId, chatUserId: _chatUserModel.userId, isTyping: false);

    _messagesListBehaviorSubject?.close();

    getLoadMessagesListQuerySnapshotStreamSubscription?.cancel();
    getLoadMessagesListQuerySnapshotStreamSubscription?.cancel();


    _chatUserOnlineStatusEventBehaviorSubject?.close();
    _chatUserOnlineStatusEventStreamSubscription?.cancel();

    _chatUserTypingStatusEventBehaviorSubject?.close();
    _chatUserTypingStatusEventStreamSubscription?.cancel();

    _textBehaviorSubject?.close();

    _isMediaUploadingBehaviorSubject?.close();

    _referredMessageModelBehaviorSubject?.close();
  }

}










