import 'dart:async';
import 'dart:math' as math;

import 'package:animator/animator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:chewie/chewie.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/widgets/image_viewer/image_viewer.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'post_room_bloc.dart';
import 'post_room_bloc_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/utils/string_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:iris_social_network/widgets/marquee/marquee.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:iris_social_network/widgets/app_material/app_material.dart';
import 'package:iris_social_network/modules/profile/profile.dart';

import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/services/constants/app_constants.dart' as app_contants;

import 'video_post_widgets.dart' as video_post_widgets;
import 'audio_post_widgets.dart' as audio_post_widgets;
import 'image_post_widgets.dart' as image_post_widgets;
import 'package:soundpool/soundpool.dart';
import 'package:share/share.dart';

import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;




class PostLikeWidget extends StatelessWidget{

  PostModel postModel;

  PostLikeWidget({@required this.postModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    Widget _numberLikeWidget = StreamBuilder<int>(
      stream: _bloc.getNumberOfLikesStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){

        print(snapshot.connectionState);

        switch(snapshot.connectionState){
          case ConnectionState.none: case ConnectionState.done:
            return Container();
          case ConnectionState.waiting:
            return SpinKitPulse(color: RGBColors.white, size: 15.0,);
          case ConnectionState.active:
            if (snapshot.hasData){
              return Text(StringUtils.formatNumber(snapshot.data), style: TextStyle(color: RGBColors.white, fontWeight: FontWeight.bold),);
            }

            else{
              return Container(
                child: Text("0", style: TextStyle(color: RGBColors.white, fontWeight: FontWeight.bold)),
              );
            }
        }

      },
    );


    return Container(
      child: StreamBuilder<Event>(
        stream: _bloc.getIfUserLikedPostStream(postId: _bloc.getPostId, postUserId: _bloc.getPostUserId, currentUserId: _bloc.getCurrentUserId),
        builder: (BuildContext context, AsyncSnapshot<Event> userLikedPostSnapshot){

          switch(userLikedPostSnapshot.connectionState){
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return SpinKitPulse(color: RGBColors.white, size: 15,);
            case ConnectionState.active:  case ConnectionState.done:

              return GestureDetector(
                onTap: ()async{


                  AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection)async{

                    if (hasInternetConnection != null && hasInternetConnection){

                      if (userLikedPostSnapshot.data.snapshot.value == null){

                        await _bloc.addPostLike(postId: _bloc.getPostId, postUserId: _bloc.getPostUserId, currentUserId: _bloc.getCurrentUserId);
                        PostRoomBlocProvider.of(context).handlers.animatePostLike(context: context);


                        // Decrements number of likes manually
                        _bloc.setNumberOfLikes = _bloc.getNumberOfLikes + 1;
                        _bloc.addNumberOfLikesToStream(_bloc.getNumberOfLikes);
                      }
                      else{

                        await _bloc.removePostLike(postId: _bloc.getPostId, postUserId: _bloc.getPostUserId, currentUserId: _bloc.getCurrentUserId);

                        PostRoomBlocProvider.of(context).handlers.animatePostUnLike(context: context);

                        // Decrements number of likes manually
                        _bloc.setNumberOfLikes = _bloc.getNumberOfLikes - 1;
                        _bloc.addNumberOfLikesToStream(_bloc.getNumberOfLikes);
                      }

                    }
                    else{

                      BasicUI.showSnackBar(
                          context: context,
                          message: "No Internet Connection",
                          textColor:  CupertinoColors.destructiveRed,
                          duration: Duration(seconds: 1)
                      );
                    }

                  });

                },
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width),
                      color: RGBColors.black.withOpacity(0.2),
                    ),
                    child:  this.postModel.postType == constants.PostType.video
                        ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        if (userLikedPostSnapshot.data.snapshot.value == null)
                          Icon(FontAwesomeIcons.heart, color: Colors.white,)
                        else
                          Icon(FontAwesomeIcons.solidHeart, color: RGBColors.fuchsia,),

                        SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                        _numberLikeWidget
                      ],
                    )
                        : Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        if (userLikedPostSnapshot.data.snapshot.value == null)
                          Icon(FontAwesomeIcons.heart, color: Colors.white,)
                        else
                          Icon(FontAwesomeIcons.solidHeart, color: RGBColors.fuchsia,),

                        SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

                        _numberLikeWidget
                      ],
                    )

                ),
              );

          }

        },
      ),
    );

  }
}






class  NumberOfPostCommentsWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);


    return Container(
      child: StreamBuilder<int>(
        stream: _bloc.getNumberOfCommentsStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot){

          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return SpinKitPulse(color: RGBColors.white, size: 15,);
            case ConnectionState.active: case ConnectionState.done:
            if (snapshot.hasData){
              return Text(StringUtils.formatNumber(snapshot.data), style: TextStyle(color: RGBColors.white, fontWeight: FontWeight.bold),);
            }
            else{
              return Container(
                child: Text("0", style: TextStyle(color: RGBColors.white, fontWeight: FontWeight.bold)),
              );
            }
            break;
          }

        },
      ),
    );
  }
}





class PostCommentsWidget extends StatelessWidget{

  PostModel postModel;

  PostCommentsWidget({@required this.postModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return GestureDetector(
      onTap: (){

        PostRoomBlocProvider.of(context).handlers.showPostComments(postRoomContext: context, postModel: postModel);

      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width),
          color: RGBColors.black.withOpacity(0.2),
        ),
        child: postModel.postType == constants.PostType.video
            ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Icon(FontAwesomeIcons.comment, color: Colors.white,),
            SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

            NumberOfPostCommentsWidget()
          ],
        ): Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Icon(FontAwesomeIcons.comment, color: Colors.white,),
            SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

            NumberOfPostCommentsWidget()
          ],
        )
      ),
    );
  }
}




class NumberOfPostSharesWidget extends StatelessWidget{

  PostModel postModel;

  NumberOfPostSharesWidget({@required this.postModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    //return Container();





    return GestureDetector(

      onTap: (){

        AppBlocProvider.getDyanamicLinkWithPostIdAndPostUserId(
            postId: postModel.postId,
            postUserId: postModel.userId
        ).then((String dynamicLink){
          if (dynamicLink != null){
            Share.share(dynamicLink);
          }
        });

      },

      child: Container(
        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width),
          color: RGBColors.black.withOpacity(0.2),
        ),
        child: Icon(FontAwesomeIcons.shareAlt, color: RGBColors.white,)
      ),
    );

  }
}






class PostInfoWidget extends StatelessWidget{

  PostModel postModel;


  PostInfoWidget({@required this.postModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return Container(
      decoration: BoxDecoration(
        //color: RGBColors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: ListTile(


        leading: GestureDetector(

          onTap: (){
            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserId: postModel.userId)));
          },

          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 10.0,
                    blurRadius: 10.0,
                  ),
                ]
            ),
            child: CircleAvatar(
              backgroundColor: RGBColors.light_grey_level_1,
              backgroundImage: CachedNetworkImageProvider(postModel.userThumb),
              child: postModel.userThumb == null
                  ? Text(postModel.userProfileName.substring(0, 1).toUpperCase(),style: TextStyle(
                  color: _themeData.primaryColor,
                  fontWeight: FontWeight.bold
              ),)
                  : Container(),
            ),
          ),
        ),

        title: GestureDetector(

          onTap: (){

            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserId: postModel.userId)));
          },

          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[


              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            postModel.userProfileName,
                            maxLines: 2,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white.withOpacity(1.0),
                                fontSize: Theme.of(context).textTheme.subtitle.fontSize,
                                fontWeight: FontWeight.w900
                            ),
                          ),
                        ),
                        if (postModel.verifiedUser != null && postModel.verifiedUser)
                          SizedBox(width: screenWidth * scaleFactor * scaleFactor * 0.5,),

                        Container(
                          child: postModel.verifiedUser != null && postModel.verifiedUser
                              ? Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: 12.0,)
                              : Container(),
                        ),
                      ],
                    ),

                    Text(
                      "@" + postModel.userName,
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: Theme.of(context).textTheme.caption.fontSize,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],


                ),
              ),

              FollowButtonWidget(postModel: this.postModel,)
            ],
          ),
        ),


        subtitle: Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
          child: GestureDetector(

            onTap: (){

              PostRoomBlocProvider.of(context).handlers.showPostCaptionModalDialog(
                  menuContext: context,
                  postCaption: postModel.postCaption
              );
            },

            child: Text(postModel.postCaption == null? "": postModel.postCaption,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.subhead.fontSize,
                //fontWeight: FontWeight.bold,

              ),
            ),
          ),
        ),

        isThreeLine: true,

      ),
    );

  }
}















class VideoViewPlaceHolderWidget extends StatelessWidget{

  VideoModel videoModel;

  VideoViewPlaceHolderWidget({@required this.videoModel});






  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);


    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: <Widget>[

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(videoModel.videoThumb),
                    fit: BoxFit.fill
                )
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                //sigmaX: 5.0,
                //sigmaY: 5.0
              ),
              child: Container(
                color: RGBColors.black.withOpacity(0.0),
              ),
            ),
          ),

        ],
      ),
    );
  }

}









class VideoViewOverlayWidget extends StatelessWidget{

  PostModel postModel;

  VideoViewOverlayWidget({@required this.postModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;

    return SafeArea(
      child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            //fit: StackFit.passthrough,
            fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: <Widget>[



              Positioned(
                right: 0.0,
                child: Container(
                  //padding: EdgeInsets.all(8.0),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[

                      Spacer(), Spacer(), Spacer(), Spacer(), Spacer(), Spacer(),
                      video_post_widgets.NumberOfVideoViewsWidget(),
                      Spacer(),
                      PostLikeWidget(postModel: this.postModel,),
                      Spacer(),
                      PostCommentsWidget(postModel: postModel,),
                      Spacer(),
                      NumberOfPostSharesWidget(postModel: this.postModel,),
                      Spacer(), Spacer(), Spacer(), Spacer(), Spacer(), Spacer()
                    ],
                  ),
                ),
              ),



              Center(
                child: video_post_widgets.PlayIconWidget(),
              ),

              Positioned(
                right: 10.0,
                top: 10.0,
                child: video_post_widgets.VideoDurationWidget(videoModel: VideoModel.fromJson(postModel.postData),),
              ),

              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 5.0,
                child: video_post_widgets.VideoBufferingWidget(),
              ),

              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: screenHeight * scaleFactor * scaleFactor,
                child: PostInfoWidget(postModel: postModel),
              )

            ],
          )
      ),
    );
  }

}










class AudioViewOverlayWidget extends StatelessWidget{

  PostModel postModel;

  AudioViewOverlayWidget({@required this.postModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;

    return SafeArea(
      child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            //fit: StackFit.passthrough,
            fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: <Widget>[



              Positioned(
                top: 0.0,
                child: Container()
              ),


              /*
              Positioned(
                right: 10.0,
                top: 10.0,
                child: video_post_widgets.VideoDurationWidget(videoModel: VideoModel.fromJson(postModel.postData),),
              ),
              */

              /*
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 5.0,
                child: video_post_widgets.VideoBufferingWidget(),
              ),
              */

              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: screenHeight * scaleFactor * scaleFactor,
                child: Column(
                  children: <Widget>[


                    Container(
                      //padding: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Spacer(), Spacer(), Spacer(), Spacer(), Spacer(), Spacer(),
                          audio_post_widgets.NumberOfAudioListensWidget(),
                          Spacer(),
                          PostLikeWidget(postModel: this.postModel,),
                          Spacer(),
                          PostCommentsWidget(postModel: postModel,),
                          Spacer(),
                          NumberOfPostSharesWidget(postModel: this.postModel,),
                          Spacer(), Spacer(), Spacer(), Spacer(), Spacer(), Spacer()
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                    PostInfoWidget(postModel: postModel),
                  ],
                ),
              )

            ],
          )
      ),
    );
  }

}






class ImageViewOverlayWidget extends StatelessWidget{

  PostModel postModel;

  ImageViewOverlayWidget({@required this.postModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;

    return SafeArea(
      child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            //fit: StackFit.passthrough,
            fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: <Widget>[



              Positioned(
                  top: 0.0,
                  child: Container()
              ),



              Positioned(
                right: screenWidth * scaleFactor * 0.25,
                top: screenWidth * scaleFactor * 0.25,
                child: image_post_widgets.ImageCountWidget(imageModel: ImageModel.fromJson(postModel.postData)),
              ),


              /*
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 5.0,
                child: video_post_widgets.VideoBufferingWidget(),
              ),
              */

              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: screenHeight * scaleFactor * scaleFactor,
                child: Column(
                  children: <Widget>[


                    Container(
                      //padding: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Spacer(), Spacer(), Spacer(), Spacer(), Spacer(), Spacer(),
                          //video_post_widgets.NumberOfVideoViewsWidget(),
                          Spacer(),
                          PostLikeWidget(postModel: this.postModel,),
                          Spacer(),
                          PostCommentsWidget(postModel: postModel,),
                          Spacer(),
                          NumberOfPostSharesWidget(postModel: this.postModel,),
                          Spacer(), Spacer(), Spacer(), Spacer(), Spacer(), Spacer()
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                    PostInfoWidget(postModel: postModel),
                  ],
                ),
              )

            ],
          )
      ),
    );
  }

}








class FollowButtonWidget extends StatelessWidget{

  PostModel postModel;

  FollowButtonWidget({@required this.postModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);


    if (AppBlocProvider.of(context).bloc.getCurrentUserId == this.postModel.userId){
      return Container();
    }
    else{
      return StreamBuilder<Event>(
          stream: _bloc.checkIfCurrentUserFollowsPostUserStreamEvent(
              currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,
              postUserId: this.postModel.userId
          ),
          builder: (buildContext, checkIfCurrentUserFollowsPostUserSnapshot) {

            switch(checkIfCurrentUserFollowsPostUserSnapshot.connectionState){
              case ConnectionState.none:case ConnectionState.waiting:
              return Container();
              case ConnectionState.active:case ConnectionState.done:

              if (checkIfCurrentUserFollowsPostUserSnapshot.data.snapshot.value == null){
                return StreamBuilder<Event>(
                    stream: _bloc.checkIfPostUserFollowsCurrentUserStreamEvent(
                        currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,
                        postUserId: this.postModel.userId
                    ),
                    builder: (buildContext, checkIfPostUserFollowsCurrentUserSnapshot) {
                      return Animator(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        repeats: 1,
                        curve: Curves.easeInOutBack,
                        duration: Duration(seconds: 1),
                        builder: (anim) => Transform.scale(
                          scale: anim.value,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: GestureDetector(
                              onTap: (){


                                _bloc.addPostUserFollower(
                                    optimisedFFModel: OptimisedFFModel(
                                        user_id: AppBlocProvider.of(context).bloc.getCurrentUserId,
                                        t: Timestamp.now().millisecondsSinceEpoch
                                    ),
                                    postUserId: this.postModel.userId
                                ).then((_){


                                  AppBlocProvider.of(context).bloc.increaseUserPoints(
                                      userId: this.postModel.userId,
                                      points: achievements_services.RewardsTypePoints.followers_growth_reward_point
                                  );
                                });


                                _bloc.addCurrentUserFollowing(
                                    optimisedFFModel: OptimisedFFModel(
                                        user_id: this.postModel.userId,
                                        t: Timestamp.now().millisecondsSinceEpoch
                                    ),
                                    currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId
                                ).then((_){

                                  BasicUI.showSnackBar(
                                      context: context,
                                      message: "You followed ${this.postModel.userProfileName}",
                                      textColor: _themeData.primaryColor
                                  );
                                });

                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                                decoration: BoxDecoration(
                                    color: _themeData.primaryColor,
                                    borderRadius: BorderRadius.circular(50.0)

                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[

                                    Icon(Icons.add, color: Colors.white,),
                                    SizedBox(width: 5.0,),

                                    Text(checkIfPostUserFollowsCurrentUserSnapshot.hasData && checkIfPostUserFollowsCurrentUserSnapshot.data.snapshot.value != null
                                        ? "Follow Back": "Follow",
                                        style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.button.fontSize,
                                            color: Colors.white
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                );
              }
              else{
                return Container();
              }
            }

          }
      );
    }

  }

}




