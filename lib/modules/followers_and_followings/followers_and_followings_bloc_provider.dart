import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'followers_and_followings_bloc.dart';



class FollowersAndFollowingsBlocProvider extends InheritedWidget{

  final FollowersAndFollowingsBloc bloc;
  final Key key;
  final Widget child;

  String profileUserId;

  ScrollController scrollController;

  FollowersAndFollowingsBlocProvider({@required this.bloc, @required this.profileUserId, @required this.scrollController, this.key, this.child}): super(key: key, child: child){



    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 0.0;


      if (maxScroll == currentScroll){


        if ((bloc.getHasLoadedFF == false || bloc.getHasLoadedFF == null) && bloc.getHasMoreFF){

          bloc.setHasLoadedFF = true;

          if (bloc.getIsFollowersView){
            bloc.loadMoreFollowers().then((_){

              bloc.setHasLoadedFF = false;
            });
          }
          else{

            bloc.loadMoreFollowings().then((_){
              bloc.setHasLoadedFF = false;
            });
          }

        }
      }

    });

  }


  static FollowersAndFollowingsBlocProvider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(FollowersAndFollowingsBlocProvider) as FollowersAndFollowingsBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}