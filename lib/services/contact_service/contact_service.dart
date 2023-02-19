import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:iris_social_network/services/constants/platform_channel_constants.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:contacts_service/contacts_service.dart';



class ContactService{


  static Future<List<ContactModel>> getContacts()async{



    PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);


    Map<PermissionGroup, PermissionStatus> permission;

    if (permissionStatus != PermissionStatus.granted){
      permission = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

      if (permission == null)
        return null;
    }


    // Get all contacts on device
    Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);




    List<ContactModel> contactsModel = List<ContactModel>();


    for (int index = 0; index < contacts.toList().length; ++index){

      if (contacts.toList()[index].phones.toList().isEmpty){
        continue;
      }

      contactsModel.add(
          ContactModel(
              userId: null,
              displayName: contacts.toList()[index].displayName,
              phoneNumber: contacts.toList()[index].phones.toList()[0].label,
              thumb: null
          )
      );

    };




    return contactsModel;
  }


}















