import 'package:flutter/material.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'private_chat_bloc.dart';
import 'private_chat_views_handlers.dart';
import 'package:iris_social_network/blocs/overlay_bloc.dart';
import 'private_chat_views_handlers.dart';



class PrivateChatBlocProvider extends InheritedWidget{

  OverlayBloc overlayBloc;
  PrivateChatBloc bloc;
  Key key;
  Widget child;

  TextEditingController textEditingController;
  ScrollController scrollController;


  PrivateChatViewsHandlers handlers;


  PrivateChatBlocProvider({
    @required this.bloc,
    @required this.overlayBloc,
    @required this.scrollController,
    @required this.textEditingController,
    this.key, this.child}): super(key: key, child: child){


    handlers = PrivateChatViewsHandlers();


    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = AppFeaturesMaxLimits.DELTA_PAGINATION;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedMessages == false || bloc.getHasLoadedMessages == null)
            && bloc.getHasMoreMessages
            && bloc.getMessagesList.length < AppFeaturesMaxLimits.MAX_NUMBER_OF_MESSAGES_TO_LOAD
        ){

          bloc.setHasLoadedMessages = true;

          bloc.loadMoreMessages(
              currentUserId: bloc.getCurrentUserModel.userId,
              chatUserId: bloc.getChatUserModel.userId,
              messageQueryLimit: bloc.getMessagesQueryLimit
          ).then((_){

            bloc.setHasLoadedMessages = false;
          });
        }
      }

    });

  }



  static PrivateChatBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PrivateChatBlocProvider) as PrivateChatBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;


}






