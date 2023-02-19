import 'package:flutter/material.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'private_chat_room_bloc.dart';
import 'private_chat_room_view_handlers.dart';


class PrivateChatRoomBlocProvider extends InheritedWidget{

  final PrivateChatRoomBloc bloc;
  final Key key;
  final Widget child;

  ScrollController scrollController;

  PrivateChatRoomViewHandlers privateChatRoomViewHandlers;


  PrivateChatRoomBlocProvider({@required this.bloc, @required this.scrollController, this.key, this.child}):super(key: key, child: child){

    privateChatRoomViewHandlers = PrivateChatRoomViewHandlers();




    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = AppFeaturesMaxLimits.DELTA_PAGINATION;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedChats == false || bloc.getHasLoadedChats == null) && bloc.getHasMoreChats){

          bloc.setHasLoadedChats = true;

          bloc.loadMoreChats(
              currentUserId: bloc.getCurrentUserId,
              queryLimit: bloc.getChatsQueryLimit,
              endAtValue: bloc.getQueryEndAtValue
          ).then((_){

            bloc.setHasLoadedChats = false;
          });
        }
      }

    });
  }


  static PrivateChatRoomBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PrivateChatRoomBlocProvider) as PrivateChatRoomBlocProvider);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

}