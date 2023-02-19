import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/services/platform_channels/phone_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:backdrop/backdrop.dart';

import 'package:iris_social_network/modules/chat_room/private_chat_room/private_chat_room.dart';


class ChatRoom extends StatelessWidget{

  static const String routeName = AppRoutes.chat_room_screen;

  ChatRoom(){

    /*
    PhoneContacts.getContacts().then((List<ContactModel> contacts ){

      contacts.forEach((model){
        print("Phone Number: ${model.phoneNumber}");
      });

    });
    */
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body: CupertinoPageScaffold(

        child: PrivateChatRoom(currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,),
      ),

    );
  }




}
















