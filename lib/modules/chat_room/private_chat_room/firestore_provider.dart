import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/utils/string_utils.dart';

import 'package:firebase_database/firebase_database.dart';
import 'phone_number_provider.dart';



class FirestoreProvider {


  static Future<void> addContactsData({@required List<ContactModel> contactModels, @required currentUserId }) async{

    contactModels.forEach((ContactModel contactModel) async{

      List<String> phoneTrials = PhoneNumberProvider.getPhoneNumberTrialsList(phoneNumber: StringUtils.removeAllSpaces(contactModel.phoneNumber));


      for (String trial in phoneTrials) {

        UserModel findContactUser = await _isContactAUser(phoneNumber: trial);

        if (findContactUser != null){

          print("found ${findContactUser.phoneNumber}");

          contactModel.thumb = findContactUser.profileThumb;
          contactModel.userId = findContactUser.userId;

          Firestore.instance
              .collection(RootCollectionNames.users)
              .document(currentUserId)
              .collection(SubCollectionNames.contacts)
              .document(findContactUser.userId).setData(contactModel.toJson());

          break;
        }
      }

    });
  }


  static Future<List<ContactModel>> getContactsData({@required String currentUserId}) async {


    QuerySnapshot querySnapshot = await Firestore.instance.collection(
        RootCollectionNames.users).document(currentUserId).collection(
        SubCollectionNames.contacts).getDocuments();
    List<ContactModel> contactModels = new List<ContactModel>();

    await querySnapshot.documents.asMap().forEach((int index, DocumentSnapshot documentSnapshot) {
      contactModels.add(ContactModel.fromJson(documentSnapshot.data));
    });

    return contactModels;
  }


  static Future<UserModel> _isContactAUser({@required String phoneNumber})async{


    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(RootCollectionNames.users)
        .where(UsersDocumentFieldNames.phone_number, isEqualTo: phoneNumber)
        .getDocuments();


    if (querySnapshot.documents != null && querySnapshot.documents.length > 0){
      return UserModel.fromJson(querySnapshot.documents[0].data);
    }
    else{
      return null;
    }

  }



  static Future<UserModel> getAllCurrentUserData({@required String currentUserId})async{

    DocumentSnapshot documentSnapshot = await Firestore.instance.collection(RootCollectionNames.users).document(currentUserId).get();

    if (documentSnapshot.exists){
      return UserModel.fromJson(documentSnapshot.data);
    }

    return null;
  }


}















