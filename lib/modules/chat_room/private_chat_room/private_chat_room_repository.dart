import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/platform_channels/phone_contacts.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';


abstract class PrivateChatRoomRepository{


  Future<void> addContactsData({@required List<ContactModel> contactModels, @required currentUserId });

  Future<List<ContactModel>> getContactsData({@required String currentUserId});


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
}


