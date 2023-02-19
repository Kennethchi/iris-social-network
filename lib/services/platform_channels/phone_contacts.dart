import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:iris_social_network/services/constants/platform_channel_constants.dart';
import 'package:iris_social_network/services/models/contact_model.dart';



class PhoneContacts{


  static Future<List<ContactModel>> getContacts()async{



    PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);

    Map<PermissionGroup, PermissionStatus> permission;

    if (permissionStatus != PermissionStatus.granted){
      permission = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

      if (permission == null)
        return null;
    }



    MethodChannel platform = MethodChannel(PlatformChannelConstants.contacts_channel);

    List<dynamic> contacts = List<Map<String, dynamic>>();
    try{

      contacts = await platform.invokeMethod(PlatformChannelMethods.get_contacts);


    } on PlatformException catch(e){
      print(e.toString());
    }

    List<ContactModel> contactsModel = List<ContactModel>();
    
    contacts.asMap().forEach((int index, dynamic value){
      contactsModel.add(ContactModel.fromJson(value));
    });




    return contactsModel;
  }


}















