import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/platform_channels/phone_contacts.dart';
import 'private_chat_room_repository.dart';
import 'contacts_provider.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';
import 'firestore_provider.dart';
import 'contacts_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_provider.dart';
import 'shared_preferences_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'realtime_database_provider.dart';



class ProductionPrivateChatRoomRepository extends PrivateChatRoomRepository{


  @override
  Future<List<ContactModel>> getContactsData({@required String currentUserId}) async {

    return await FirestoreProvider.getContactsData(currentUserId: currentUserId);
  }

  @override
  Future<Function> addContactsData({@required List<ContactModel> contactModels, @required currentUserId}) async {

    await FirestoreProvider.addContactsData(contactModels: contactModels, currentUserId: currentUserId);
  }


  @override
  Future<List<ContactModel>> getContactsFromMobile() async {

    return await ConstactsProvider.getContactsFromMobile();
  }

  @override
  Future<FirebaseUser> getFirebaseCurrentUser() async {

    return await FirebaseAuthProvider.getFirebaseCurrentUser();
  }

  @override
  Future<List<ContactModel>> savePhoneNumbersToSharedPrefs({@required List<ContactModel> contactModels}) async {
    return await SharedPreferencesProvider.savePhoneNumbersToSharedPrefs(contacts: contactModels);
  }

  @override
  Future<List<String>> getPhoneNumberListFromSharedPrefs() async{
    return await SharedPreferencesProvider.getPhoneNumberListFromSharedPrefs();
  }

  @override
  Future<UserModel> getAllCurrentUserData({@required String currentUserId}) async{
    return await FirestoreProvider.getAllCurrentUserData(currentUserId: currentUserId);
  }


  @override
  Future<OptimisedChatModel> getChatUserChatData({@required String currentUserId, @required String chatUserId}) async{
    return await RealtimeDatabaseProvider.getChatUserChatData(currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Stream<Event> getChatsDataEvent({@required String currentUserId, @required int queryLimit, @required int endAtValue}) {
    return RealtimeDatabaseProvider.getChatsDataEvent(currentUserId: currentUserId, queryLimit: queryLimit, endAtValue: endAtValue);
  }

  @override
  Future<Function> setChatSeen({@required String currentUserId, @required String chatUserId})async {
    await RealtimeDatabaseProvider.setChatSeen(currentUserId: currentUserId, chatUserId: chatUserId);
  }


  @override
  Stream<Event> getChatSeenStreamEvent({@required String currentUserId, @required String chatUserId}) {
    return RealtimeDatabaseProvider.getChatSeenStreamEvent(currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Future<bool> getIsUserVerified({@required String userId})async {
    return await RealtimeDatabaseProvider.getIsUserVerified(userId: userId);
  }

  @override
  Future<String> getUserProfileThumb({@required String userId})async {

    return await RealtimeDatabaseProvider.getUserProfileThumb(userId: userId);
  }

  @override
  Future<String> getUserProfileName({@required String userId})async {

    return await RealtimeDatabaseProvider.getUserProfileName(userId: userId);
  }

  @override
  Future<String> getUserUserName({@required String userId})async{

    return await RealtimeDatabaseProvider.getUserUserName(userId: userId);
  }

  @override
  Stream<Event> getChatUserTypingStatus({@required currentUserId, @required String chatUserId}) {
    return RealtimeDatabaseProvider.getChatUserTypingStatus(currentUserId: currentUserId, chatUserId: chatUserId);
  }

  @override
  Stream<Event> getChatUserOnlineStatus({@required String chatUserId}) {
    return RealtimeDatabaseProvider.getChatUserOnlineStatus(chatUserId: chatUserId);
  }


}







