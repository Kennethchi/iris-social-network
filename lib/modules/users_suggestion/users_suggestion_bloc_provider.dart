import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';
import 'users_suggestion_bloc.dart';
import 'users_suggestion_view_handlers.dart';




class UsersSuggestionBlocProvider extends InheritedWidget{

  final UsersSuggestionBloc bloc;
  final Key key;
  final Widget child;

  ScrollController scrollController;


  UsersSuggestionViewHandlers handlers;


  UsersSuggestionBlocProvider({@required this.bloc, @required this.scrollController, this.key, this.child}): super(key: key, child: child){
    handlers = UsersSuggestionViewHandlers();


    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = 0.0;

      if (maxScroll - currentScroll < delta){

        if ((bloc.getHasLoadedUsers == false || bloc.getHasLoadedUsers == null)
            && bloc.getHasMoreUsers
            && bloc.getUsersList.length < AppFeaturesMaxLimits.MAX_NUMBER_OF_SUGGESTED_USERS_TO_LOAD
        ) {

          bloc.setHasLoadedUsers = true;
          bloc.loadMoreUsers(
             userQueryLimit: bloc.getUsersQueryLimit
          ).then((_){

            bloc.setHasLoadedUsers = false;
          });
        }
      }

    });


  }


  static UsersSuggestionBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(UsersSuggestionBlocProvider) as UsersSuggestionBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
