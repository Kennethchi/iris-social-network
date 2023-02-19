import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'friends_post_feed_bloc.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'friends_post_feed_handlers.dart';


class FriendsPostFeedBlocProvider extends InheritedWidget{

  final FriendsPostFeedBloc bloc;
  final Key key;
  final Widget child;

  ScrollController scrollController;

  FriendsPostFeedHandlers handlers;


  FriendsPostFeedBlocProvider({@required this.bloc, @required this.scrollController, this.key, this.child}): super(key: key, child: child){

    handlers = FriendsPostFeedHandlers();

    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 0.0;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedPosts == false || bloc.getHasLoadedPosts == null) && bloc.getHasMorePosts) {

          bloc.setHasLoadedPosts = true;
          bloc.loadMorePosts(
            currentUserId: bloc.getCurrentUserId,
              postType: bloc.getPostType,
              postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
              postQueryLimit: bloc.getPostsQueryLimit
          ).then((_){

            bloc.setHasLoadedPosts = false;
          });
        };


      }

    });


  }



  static FriendsPostFeedBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(FriendsPostFeedBlocProvider) as FriendsPostFeedBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}