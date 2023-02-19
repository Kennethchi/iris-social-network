import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'post_feed_bloc.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'post_feed_handlers.dart';


class PostFeedBlocProvider extends InheritedWidget{

  final PostFeedBloc bloc;
  final Key key;
  final Widget child;

  ScrollController scrollController;

  PostFeedHandlers handlers;

  PostFeedBlocProvider({@required this.bloc, @required this.scrollController, this.key, this.child}): super(key: key, child: child){

    handlers = PostFeedHandlers();

    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 0.0;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedPosts == false || bloc.getHasLoadedPosts == null) && bloc.getHasMorePosts) {

          bloc.setHasLoadedPosts = true;
          bloc.loadMorePosts(
              postType: bloc.getPostType,
              postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
              postQueryLimit: bloc.getPostsQueryLimit
          ).then((_){

            bloc.setHasLoadedPosts = false;
          });
        }
      }

    });


  }



  static PostFeedBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PostFeedBlocProvider) as PostFeedBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}