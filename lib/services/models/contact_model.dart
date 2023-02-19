import 'package:iris_social_network/services/constants/platform_channel_constants.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';


class ContactModel{

  String userId;
  String displayName;
  String phoneNumber;
  String thumb;


  ContactModel({
    @required this.userId,
    @required this.displayName,
    @required this.phoneNumber,
    @required this.thumb
  });



  ContactModel.fromJson(dynamic json){

    this.userId = json[ContactsDocumentFieldName.user_id];
    this.displayName = json[ContactsDocumentFieldName.display_name];
    this.phoneNumber = json[ContactsDocumentFieldName.phone_number];
    this.thumb = json[ContactsDocumentFieldName.thumb];
  }



  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = Map<String, dynamic>();

    data[ContactsDocumentFieldName.user_id] = this.userId;
    data[ContactsDocumentFieldName.display_name] = this.displayName;
    data[ContactsDocumentFieldName.phone_number] = this.phoneNumber;
    data[ContactsDocumentFieldName.thumb] = this.thumb;

    return data;
  }





}