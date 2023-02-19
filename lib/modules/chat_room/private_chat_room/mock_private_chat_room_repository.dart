import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/platform_channels/phone_contacts.dart';
import 'private_chat_room_repository.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';



class MockPrivateChatRoomRepository extends PrivateChatRoomRepository{


  @override
  Future<Function> addPrivateChatsData(
      {@required List<ChatModel> privateChats, @required String currentUserId}) {

  }

  @override
  Future<List<ContactModel>> getContactsData({@required String currentUserId}) {

  }

  @override
  Future<Function> addContactsData(
      {@required List<ContactModel> contactModels, @required currentUserId}) {

  }

  @override
  Future<List<ChatModel>> getPrivateChatsData({@required String currentUserId}) {

  }

  @override
  Future<List<ContactModel>> getContactsFromMobile() {

  }

  @override
  Future<FirebaseUser> getFirebaseCurrentUser() {

  }


  @override
  Future<List<ContactModel>> savePhoneNumbersToSharedPrefs({@required List<ContactModel> contactModels}) {

  }

  @override
  Future<List<String>> getPhoneNumberListFromSharedPrefs() {

  }

  @override
  Future<UserModel> getAllCurrentUserData({@required String currentUserId}) {

  }


  @override
  Future<OptimisedChatModel> getChatUserChatData(
      {@required String currentUserId, @required String chatUserId}) {

  }

  @override
  Stream<Event> getChatsDataEvent({@required String currentUserId, @required int queryLimit, @required int endAtValue}) {

  }

  @override
  Future<Function> setChatSeen(
      {@required String currentUserId, @required String chatUserId}) {

  }

  @override
  Future<bool> getIsUserVerified({@required String userId}) {

  }

  @override
  Future<String> getUserProfileThumb({@required String userId}) {

  }

  @override
  Future<String> getUserProfileName({@required String userId}) {

  }

  @override
  Future<String> getUserUserName({@required String userId}) {

  }

  @override
  Stream<Event> getChatSeenStreamEvent(
      {@required String currentUserId, @required String chatUserId}) {

  }

  @override
  Stream<Event> getChatUserTypingStatus(
      {@required currentUserId, @required String chatUserId}) {

  }

  @override
  Stream<Event> getChatUserOnlineStatus({@required String chatUserId}) {

  }


}