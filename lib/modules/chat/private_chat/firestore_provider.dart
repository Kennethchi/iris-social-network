import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/message_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';


class FirestoreProvider{



  // they private chats option is just for test
  static Future<String>  addMessageData({@required MessageModel messageModel, @required String currentUserId, @required String chatUserId})async{

    DocumentReference currentUserMessageRef = Firestore
        .instance.collection(RootCollectionNames.users)
        .document(currentUserId)
        .collection(SubCollectionNames.private_chats)
        .document(chatUserId)
        .collection(SubCollectionNames.private_messages)
        .document();

    DocumentReference chatUserMessageRef = Firestore
        .instance.collection(RootCollectionNames.users)
        .document(chatUserId)
        .collection(SubCollectionNames.private_chats)
        .document(currentUserId)
        .collection(SubCollectionNames.private_messages)
        .document();

    WriteBatch batch = Firestore.instance.batch();

    batch.setData(currentUserMessageRef, messageModel.toJson());
    batch.setData(chatUserMessageRef, messageModel.toJson());

    await batch.commit();

    return currentUserMessageRef.documentID;
  }



  static Future<void>  removeMessageData({@required String messageId, @required String currentUserId, @required String chatUserId})async{

    await Firestore.instance
        .collection(RootCollectionNames.users)
        .document(currentUserId)
        .collection(SubCollectionNames.private_chats)
        .document(chatUserId)
        .collection(SubCollectionNames.private_messages)
        .document(messageId)
        .delete();
  }

  /*
  static Future<void> addMessageImageData({
        @required MessageModel userMessageModel,
        @required String currentUserImageUrl,
        @required String chatUserImageUrl,
        @required String currentUserThumb,
        @required String chatUserThumb
      }) async{

    DocumentReference currentUserMessageRef = Firestore
        .instance.collection(RootCollectionNames.users)
        .document(userMessageModel.sender_id)
        .collection(SubCollectionNames.contacts)
        .document(userMessageModel.receiver_id)
        .collection(SubCollectionNames.private_messages)
        .document();

    DocumentReference chatUserMessageRef = Firestore
        .instance.collection(RootCollectionNames.users)
        .document(userMessageModel.receiver_id)
        .collection(SubCollectionNames.contacts)
        .document(userMessageModel.sender_id)
        .collection(SubCollectionNames.private_messages)
        .document();


    WriteBatch batch = Firestore.instance.batch();



    MessageModel currentUserMessageModel = userMessageModel;
    currentUserMessageModel.images = [currentUserImageUrl];
    if(currentUserThumb != null){
      currentUserMessageModel.images_thumbs = [currentUserThumb];
    }

    MessageModel chatUserMessageModel = userMessageModel;
    chatUserMessageModel.images = [chatUserImageUrl];
    if(chatUserThumb != null){
      chatUserMessageModel.images_thumbs = [chatUserThumb];
    }


    assert(currentUserMessageModel.images != null);
    assert(currentUserMessageModel.images_thumbs != null);
    assert(chatUserMessageModel.images != null);
    assert(chatUserMessageModel.images_thumbs != null);


    batch.setData(currentUserMessageRef, currentUserMessageModel.toJson());
    batch.setData(chatUserMessageRef, chatUserMessageModel.toJson());

    await batch.commit();
  }
  */



  static Stream<QuerySnapshot> getMessagesDataEvent({
    @required String currentUserId, @required String chatUserId,
    @required int queryLimit,
    @required Map<String, dynamic> startAfterMap}) {

    if (startAfterMap == null){
      return Firestore
          .instance.collection(RootCollectionNames.users)
          .document(currentUserId)
          .collection(SubCollectionNames.private_chats)
          .document(chatUserId)
          .collection(SubCollectionNames.private_messages)
          .orderBy(UsersDocumentFieldNames.timestamp, descending: true)
          .limit(queryLimit)
          .snapshots();
    }
    else{
      return Firestore
          .instance.collection(RootCollectionNames.users)
          .document(currentUserId)
          .collection(SubCollectionNames.private_chats)
          .document(chatUserId)
          .collection(SubCollectionNames.private_messages)
          .orderBy(UsersDocumentFieldNames.timestamp, descending: true)
          .limit(queryLimit)
          .startAfter([startAfterMap[MessageDocumentFieldName.timestamp]])
          .snapshots();
    }
  }


  static Future<void> updateChattersMessagesSeenField({@required String currentUserId, @required String chatUserId}) async{

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(RootCollectionNames.users)
        .document(chatUserId)
        .collection(SubCollectionNames.private_chats)
        .document(currentUserId)
        .collection(SubCollectionNames.private_messages)
        .where(MessageDocumentFieldName.seen, isEqualTo: false)
        .where(MessageDocumentFieldName.sender_id, isEqualTo: chatUserId)
        .limit(AppFeaturesMaxLimits.MAX_NUMBER_OF_MESSAGES_TO_LOAD)
        .getDocuments();


    WriteBatch writeBatch = Firestore.instance.batch();

    if (querySnapshot.documents != null){

      for (int i = 0; i < querySnapshot.documents.length; ++i){

        if (querySnapshot.documents[i].data[MessageDocumentFieldName.seen] == false){
          querySnapshot.documents[i].reference.updateData({MessageDocumentFieldName.seen: true});
        }
      }
    }
  }



  static Future<void> updateChattersSingleMessageSeenField({@required String currentUserId, @required String chatUserId, @required messageId}) async{

    Map<String, dynamic> updateDataMap = {MessageDocumentFieldName.seen: true};

    DocumentReference documentReference = Firestore.instance
        .collection(RootCollectionNames.users)
        .document(chatUserId)
        .collection(SubCollectionNames.private_chats)
        .document(currentUserId)
        .collection(SubCollectionNames.private_messages)
        .document(messageId);

    await documentReference.updateData(updateDataMap);
  }

}









