import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iris_social_network/modules/friends_post_feed/friends_post_feed_bloc.dart';
import 'package:iris_social_network/modules/post_feed/post_feed_bloc.dart';
import 'package:iris_social_network/modules/profile/profile_bloc.dart';
import 'post_space_bloc.dart';
import 'post_space_bloc_provider.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;



class PostSpaceViewHandlers{


  Future<void> loadMorePostsToPostSpace({@required BuildContext context, @required int currentIndex, @required dynamic dynamicBloc})async{

    PostSpaceBloc postSpaceBloc = PostSpaceBlocProvider.of(context).postsSpaceBloc;


    if (dynamicBloc is PostFeedBloc){

      PostFeedBloc postFeedBloc = dynamicBloc as PostFeedBloc;

      if ((postFeedBloc.getHasLoadedPosts == false || postFeedBloc.getHasLoadedPosts ==  null) && postFeedBloc.getHasMorePosts){

        postFeedBloc.setHasLoadedPosts = true;
        await postFeedBloc.loadMorePosts(
            postType: postFeedBloc.getPostType,
            postQueryLimit: 1,
            postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT
        );
        postSpaceBloc.addPostsListToStream(postFeedBloc.getPostsList);

        postFeedBloc.setHasLoadedPosts = false;
      }
      else{
        postFeedBloc.addHasMorePostsToStream(false);
      }


      PostSpaceBlocProvider.of(context).swiperController.index = currentIndex;
    }
    else if (dynamicBloc is ProfileBloc){

      ProfileBloc profileBloc = dynamicBloc as ProfileBloc;

      if ((profileBloc.getHasLoadedPosts == false || profileBloc.getHasLoadedPosts == null) && profileBloc.getHasMorePosts){

        profileBloc.setHasLoadedPosts = true;
        await profileBloc.loadMorePosts(
            profileUserId: profileBloc.getProfileUserId,
            postType: profileBloc.getPostType,
            postQueryLimit: 1,
            postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT
        );

        postSpaceBloc.addPostsListToStream(profileBloc.getPostsList);

        profileBloc.setHasLoadedPosts = false;
      }else{
        profileBloc.addHasMorePostsToStream(false);
      }


      PostSpaceBlocProvider.of(context).swiperController.index = currentIndex;
    }
    else if (dynamicBloc is FriendsPostFeedBloc){

      FriendsPostFeedBloc friendsPostFeedBloc = dynamicBloc as FriendsPostFeedBloc;

      if ((friendsPostFeedBloc.getHasLoadedPosts == false || friendsPostFeedBloc.getHasLoadedPosts == null) && friendsPostFeedBloc.getHasMorePosts){

        friendsPostFeedBloc.setHasLoadedPosts = true;
        await friendsPostFeedBloc.loadMorePosts(
            postType: friendsPostFeedBloc.getPostType,
            postQueryLimit: 1,
            postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT
        );

        postSpaceBloc.addPostsListToStream(friendsPostFeedBloc.getPostsList);

        friendsPostFeedBloc.setHasLoadedPosts = false;
      }else{
        friendsPostFeedBloc.addHasMorePostsToStream(false);
      }


      PostSpaceBlocProvider.of(context).swiperController.index = currentIndex;
    }



  }



  Stream<bool> getHasMorePostStreamFromDynamicBloc({@required dynamic dynamicBloc}){

    if(dynamicBloc is PostFeedBloc){
      return (dynamicBloc as PostFeedBloc).getHasMorePostsStream;
    }
    else if (dynamicBloc is ProfileBloc){
      return (dynamicBloc as ProfileBloc).getHasMorePostsStream;
    }
    else if (dynamicBloc is FriendsPostFeedBloc){
      return (dynamicBloc as FriendsPostFeedBloc).getHasMorePostsStream;
    }
    else{
      return (dynamicBloc as PostFeedBloc).getHasMorePostsStream;
    }
  }






  Stream<String> getPostTypeStreamFromDynamicBloc({@required dynamic dynamicBloc}){

    if(dynamicBloc is PostFeedBloc){
      return (dynamicBloc as PostFeedBloc).getPostTypeStream;
    }
    else if (dynamicBloc is ProfileBloc){
      return (dynamicBloc as ProfileBloc).getPostTypeStream;
    }
    else if (dynamicBloc is FriendsPostFeedBloc){
      return (dynamicBloc as FriendsPostFeedBloc).getPostTypeStream;
    }
    else{
      return (dynamicBloc as PostFeedBloc).getPostTypeStream;
    }
  }

}