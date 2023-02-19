import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_contants;



class RealtimeDatabaseProvider{

  static Stream<Event> getChatUserOnlineStatus({@required String chatUserId }){
    Stream<Event> event = FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(chatUserId).child(UsersFieldNamesOptimised.o).onValue;
    return event;
  }

  static Future<void> addCurrentUserTypingStatus({@required String currentUserId, @required chatUserId, @required bool isTyping}) async{
    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(chatUserId)
        .child(currentUserId)
        .child(PrivateChatsFieldNamesOptimised.tp)
        .set(isTyping);
  }



  static Stream<Event> getChatUserTypingStatus({@required currentUserId, @required String chatUserId}){

    Stream<Event> event =  FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(currentUserId)
        .child(chatUserId)
        .child(PrivateChatsFieldNamesOptimised.tp)
        .onValue;

    return event;
  }



  static Future<void> onCurrentUserDisconnect({@required String currentUserId, @required String chatUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(chatUserId)
        .child(currentUserId)
        .child(PrivateChatsFieldNamesOptimised.tp)
        .onDisconnect()
        .set(false);
  }



  static Future<void> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel})async{

    FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(currentUserChatterModel.chat_user_id)
        .child(chatUserChatterModel.chat_user_id)
        .set(chatUserChatterModel.toJson());

    FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(chatUserChatterModel.chat_user_id)
        .child(currentUserChatterModel.chat_user_id)
        .set(currentUserChatterModel.toJson());

  }
  
  
  



  static Future<void> addNotificationData({@required OptimisedNotificationModel optimisedNotificationModel, @required String chatUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.message_notifications)
        .child(chatUserId)
        .push()
        .set(optimisedNotificationModel.toJson());
  }



  static Future<void> setChatSeen({@required String currentUserId, @required String chatUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(currentUserId)
        .child(chatUserId)
        .child(PrivateChatsFieldNamesOptimised.seen)
        .set(true);
  }


  static Future<void> setCurrentUserSentMessageState({@required String messageState, @required String messageId, @required String currentUserId, @required String chatUserId})async{

     await FirebaseDatabase.instance.reference()
         .child(RootReferenceNames.private_messages)
         .child(currentUserId)
        .child(chatUserId)
        .child(messageId)
        .child(PrivateMessagesFieldNamesOptimised.msg_state)
        .set(messageState);
  }


  static Future<void> removeCurrentUserSentMessageState({@required String messageId, @required String currentUserId, @required String chatUserId})async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_messages)
        .child(currentUserId)
        .child(chatUserId)
        .child(messageId)
        .remove();
  }



  static Stream<Event> getCurrentUserSentMessageStateEvent({@required String messageId, @required String currentUserId, @required String chatUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_messages)
        .child(currentUserId)
        .child(chatUserId)
        .child(messageId)
        .child(PrivateMessagesFieldNamesOptimised.msg_state)
        .onValue;
  }



  static Future<String> getMessageState({@required String messageId, @required String currentUserId, @required String chatUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_messages)
        .child(chatUserId)
        .child(currentUserId)
        .child(messageId)
        .child(PrivateMessagesFieldNamesOptimised.msg_state)
        .once();

    return dataSnapshot.value;
  }


  static Future<void> setMessagesSeen({@required String currentUserId, @required String chatUserId})async{


    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_messages)
        .child(chatUserId)
        .child(currentUserId)
        .keepSynced(true);


    DataSnapshot dataSnapshots = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_messages)
        .child(chatUserId)
        .child(currentUserId)
        .orderByChild(PrivateMessagesFieldNamesOptimised.msg_state)
        .equalTo(MessageState.sent)
        .limitToLast(app_contants.DatabaseQueryLimits.MESSAGES_QUERY_LIMIT)
        .once();

    if (dataSnapshots.value != null){
      Map<dynamic, dynamic> dataMap = dataSnapshots.value;

      List<dynamic> messageIdList = dataMap.keys.toList();
      messageIdList.sort();
      messageIdList.reversed;

      for (int index = 0; index < messageIdList.length; ++index){

        FirebaseDatabase.instance.reference()
            .child(RootReferenceNames.private_messages)
            .child(chatUserId)
            .child(currentUserId)
            .child(messageIdList[index])
            .child(PrivateMessagesFieldNamesOptimised.msg_state)
            .set(MessageState.seen);
      }
    }

  }




  static Future<void> setSingleMessageSeen({@required String currentUserId, @required String chatUserId})async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_messages)
        .child(chatUserId)
        .child(currentUserId)
        .keepSynced(true);

    DataSnapshot dataSnapshots = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_messages)
        .child(chatUserId)
        .child(currentUserId)
        .orderByChild(PrivateMessagesFieldNamesOptimised.msg_state)
        .equalTo(MessageState.sent)
        .limitToLast(3)
        .once();

    if (dataSnapshots.value != null){
      Map<dynamic, dynamic> dataMap = dataSnapshots.value;

      List<dynamic> messageIdList = dataMap.keys.toList();
      messageIdList.sort();
      messageIdList.reversed;

      for (int index = 0; index < messageIdList.length; ++index){

        FirebaseDatabase.instance.reference()
            .child(RootReferenceNames.private_messages)
            .child(chatUserId)
            .child(currentUserId)
            .child(messageIdList[index])
            .child(PrivateMessagesFieldNamesOptimised.msg_state)
            .set(MessageState.seen);
      }
    }
  }

}




