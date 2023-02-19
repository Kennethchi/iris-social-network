import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';



class RealtimeDatabaseProvider{



  static Future<OptimisedChatModel> getChatUserChatData({@required String currentUserId,  @required String chatUserId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(currentUserId)
        .child(chatUserId)
        .once();
    
    if (dataSnapshot != null && dataSnapshot.value != null){

      OptimisedChatModel optimisedChatModel = OptimisedChatModel.fromJson(dataSnapshot.value);
      optimisedChatModel.chat_user_id = dataSnapshot.key;

      return optimisedChatModel;
    }

    return null;
  }




  static Stream<Event> getChatsDataEvent({@required String currentUserId,  @required int queryLimit, @required int endAtValue}){

    if (endAtValue == null){

      return FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.private_chats)
          .child(currentUserId)
          .orderByChild(PrivateChatsFieldNamesOptimised.t)
          .limitToLast(queryLimit)
          .onValue;

    }
    else{

      return FirebaseDatabase.instance.reference()
          .child(RootReferenceNames.private_chats)
          .child(currentUserId)
          .orderByChild(PrivateChatsFieldNamesOptimised.t)
          .limitToLast(queryLimit)
          .endAt(endAtValue)
          .onValue;
    }
    
  }


  static Future<void> setChatSeen({@required String currentUserId, @required String chatUserId}) async{

    await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(currentUserId)
        .child(chatUserId)
        .child(PrivateChatsFieldNamesOptimised.seen)
        .set(true);

  }


  static Stream<Event> getChatSeenStreamEvent({@required String currentUserId, @required String chatUserId}){

    return FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(chatUserId)
        .child(currentUserId)
        .child(PrivateChatsFieldNamesOptimised.seen)
        .onValue;
  }


  static Future<String> getUserUserName({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.username).once();

    return dataSnapshot.value;
  }

  static Future<String> getUserProfileName({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.name).once();

    return dataSnapshot.value;
  }

  static Future<String> getUserProfileThumb({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.thumb).once();

    return dataSnapshot.value;
  }

  static Future<bool> getIsUserVerified({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).child(UsersFieldNamesOptimised.v_user).once();

    return dataSnapshot.value;
  }





  static Stream<Event> getChatUserOnlineStatus({@required String chatUserId}){
    Stream<Event> event = FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(chatUserId).child(UsersFieldNamesOptimised.o).onValue;
    return event;
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

}