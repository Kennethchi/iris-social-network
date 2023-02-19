import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'private_chat_room_views_widgets.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'private_chat_room_bloc.dart';
import 'private_chat_room_bloc_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';





class PrivateChatRoomViewHandlers{


  void pushToPrivateChat({@required BuildContext context, @required UserModel currentUserModel, @required UserModel chatUserModel}){

    PrivateChatRoomBloc bloc = PrivateChatRoomBlocProvider.of(context).bloc;
  }


  Widget getChatMessageView({@required OptimisedChatModel optimisedChatModel}){

    switch(optimisedChatModel.msg_type){

      case MessageType.text:
        return ChatMessageTextWidget(optimisedChatModel: optimisedChatModel);
      case MessageType.image:
        return ChatMessageImageWidget(optimisedChatModel: optimisedChatModel);
      case MessageType.audio:
        return ChatMessageAudioWidget(optimisedChatModel: optimisedChatModel);
      case MessageType.video:
        return ChatMessageVideoWidget(optimisedChatModel: optimisedChatModel);
      default:
        return Container();
    }
  }



}