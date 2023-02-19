import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'friends_bloc.dart';
import 'friends_view_handlers.dart';



class FriendsBlocProvider extends InheritedWidget{

  final FriendsBloc bloc;
  final Key key;
  final Widget child;

  ScrollController scrollController;

  FriendsViewHandlers handlers;

  FriendsBlocProvider({@required this.bloc, @required this.scrollController, this.key, this.child}): super(key: key, child: child){

    handlers = FriendsViewHandlers();

    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = AppFeaturesMaxLimits.DELTA_PAGINATION;


      if (maxScroll - currentScroll < deltaBottom){

        print(bloc.getFriendsList.length);
        print(bloc.getHasMoreFriends);

        if (bloc.getHasLoadedFriends == false && bloc.getFriendsList.length < bloc.getQueryMaxLimit && bloc.getHasMoreFriends) {

          bloc.setHasLoadedFriends = true;

          bloc.loadMoreFriends().then((_){

            bloc.setHasLoadedFriends = false;

            if (bloc.getFriendsList.length < bloc.getQueryMaxLimit){
              bloc.setHasMoreFriends = true;
            }
            else{
              // Ends pagination
              bloc.setHasMoreFriends = false;
            }

          });
        }

      }
    });

  }


  static FriendsBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(FriendsBlocProvider) as FriendsBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}