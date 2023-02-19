import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/modules/achievements/achievements.dart';
import 'package:iris_social_network/modules/friends/friends.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'profile_bloc.dart';
import 'profile_bloc_provider.dart';
import 'package:iris_social_network/services/models/user_model.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:ui';
import 'package:iris_social_network/utils/string_utils.dart';
import 'package:iris_social_network/widgets/clippers/clippers.dart';

import 'profile_strings.dart';

import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iris_social_network/modules/profile_settings/profile_settings.dart';
import 'package:iris_social_network/modules/followers_and_followings/followers_and_followings.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/widgets/image_viewer/image_viewer.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:iris_social_network/services/constants/medias_constants.dart' as media_constants;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;





class ProfileSliverAppBar extends StatelessWidget{

  final UserModel userModel;

  ProfileSliverAppBar(@required this.userModel);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    //userModel.profileThumb = "https://www.coupdemainmagazine.com/sites/default/files/styles/full_width/public/article/14959/hero-14959-1215950915.jpg?itok=h1sSj_7o";
    //userModel.coverThumb = "https://imgix.bustle.com/uploads/image/2017/12/18/ffbd681d-aa4b-461f-a168-8593def37e63-faa0e103-0033-4e16-81bd-52505f3e4f78-screen-shot-2017-12-18-at-164701.png?w=970&h=582&fit=crop&crop=faces&auto=format&q=70";


    return SliverAppBar(
      expandedHeight: screenHeight * 0.85,
      //floating: true,
      pinned: false,
      elevation: 1.0,
      //backgroundColor: RGBColors.white,
      backgroundColor: Colors.transparent,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
        Navigator.pop(context);
      }),
      flexibleSpace: ClipPath(

        clipper: OvalBottomClipper(),
        child: FlexibleSpaceBar(

          background: Stack(
            children: <Widget>[


              Positioned.fill(
                child: CachedNetworkImage(
                    imageUrl: this.userModel.profileThumb != null? this.userModel.profileThumb: "",
                  fit: BoxFit.cover,
                ),
              ),


              /*
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaY: 500.0,
                    sigmaX: 500.0,
                  ),
                  child: Container(),
                ),
              ),
              */


              Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                      child: ProfileAudioWidget())
              ),




              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0
                  ),
                  child: Container(
                    child: SafeArea(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[


                                  Flexible(
                                    flex: 25,
                                      fit: FlexFit.tight,
                                      child: Center(child: NumberOfFriendsWidget())
                                  ),

                                  Flexible(
                                    flex: 50,
                                    fit: FlexFit.tight,
                                    child: GestureDetector(

                                      onTap: (){

                                        Navigator.of(context).push(
                                            PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> primaryAnimation, Animation<double> secondaryAnimation){
                                              return ImageViewer(
                                                imageList: [userModel.profileImage],
                                                currentIndex: 0,
                                              );
                                            }, transitionDuration: Duration(milliseconds: 700)
                                            ));

                                      },

                                      child: Center(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Stack(
                                            children: <Widget>[
                                              Hero(
                                                tag: userModel.profileImage,
                                                child: Animator(
                                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                                  repeats: 1,
                                                  curve: Curves.easeInOutBack,
                                                  duration: Duration(milliseconds: 1500),
                                                  builder: (anim){
                                                    return Transform.scale(
                                                      scale: anim.value,
                                                      child: CircleAvatar(
                                                        backgroundImage: CachedNetworkImageProvider(userModel.profileThumb),
                                                        backgroundColor: RGBColors.light_grey_level_1,
                                                        radius: screenWidth * scaleFactor * 1.5,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),


                                  Flexible(
                                    flex: 25,
                                    fit: FlexFit.tight,
                                    //child: Container(),
                                      child: Center(child: NumberOfPointsWidget())
                                  ),




                                ],
                              ),
                              SizedBox(height: screenHeight * scaleFactor * 0.2,),


                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(userModel.profileName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.headline.fontSize,fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    if (userModel.verifiedUser != null && userModel.verifiedUser)
                                      SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

                                    Container(
                                      child: userModel.verifiedUser != null && userModel.verifiedUser
                                          ? Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.4,)
                                          : Container(),
                                    )
                                  ],
                                ),
                              ),


                              Text("@" + userModel.username,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: RGBColors.white.withOpacity(0.6), fontSize: Theme.of(context).textTheme.subhead.fontSize, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: screenHeight * scaleFactor * 0.2,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[

                                  Flexible(
                                    flex: 33,
                                    fit: FlexFit.tight,
                                    child: Center(child: NumberOfPostsWidget()),
                                  ),


                                  Flexible(
                                    flex: 33,
                                    fit: FlexFit.tight,
                                    child: InkWell(
                                      onTap: (){

                                        Navigator.of(context).push(CupertinoPageRoute(
                                            builder: (BuildContext context) => FollowersAndFollowings(
                                              profileUserId: _bloc.getProfileUserId,
                                              profileUserThumb: _bloc.getProfileUserModel.profileThumb,
                                              isFollowersView: true,
                                            )));
                                      },
                                      child: Center(child: NumberOfFollowersWidget()),
                                    ),
                                  ),


                                  Flexible(
                                    flex: 33,
                                    fit: FlexFit.tight,
                                    child: InkWell(
                                      onTap: (){

                                        Navigator.of(context).push(CupertinoPageRoute(
                                            builder: (BuildContext context) => FollowersAndFollowings(
                                              profileUserId: _bloc.getProfileUserId,
                                              profileUserThumb: _bloc.getProfileUserModel.profileThumb,
                                              isFollowersView: false,
                                            )
                                        ));
                                      },
                                      child: Center(child: NumberOfFollowingsWidget()),
                                    ),
                                  )

                                ],
                              ),
                              SizedBox(height: screenHeight * scaleFactor * 0.2,),



                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor  * 0.5, ),
                                child: StatusWidget(),
                              ),

                              SizedBox(height: screenHeight * scaleFactor * 0.2,),


                              Row(
                                mainAxisAlignment: _bloc.getCurrentUserId == _bloc.getProfileUserId
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceEvenly,
                                children: <Widget>[


                                  if (_bloc.getCurrentUserId != _bloc.getProfileUserId)
                                    Flexible(
                                        flex: 50,
                                        child: Center(
                                            child: SizedBox(
                                              width: screenWidth * 0.33,
                                                child: FriendRequestButtonWidget()
                                            )
                                        )
                                    ),


                                  Flexible(
                                    flex: 50,
                                      child: Center(
                                          child: SizedBox(
                                            width: screenWidth * 0.33,
                                              child: FollowButtonWidget()
                                          )
                                      )
                                  ),
                                ],
                              ),

                              /*
                              Animator(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                repeats: 1,
                                curve: Curves.easeInOutBack,
                                duration: Duration(seconds: 1),
                                builder: (anim){
                                  return Transform.scale(
                                      scale: anim.value,
                                      child: Container()
                                  );
                                },
                              )
                              */


                            ],
                          ),
                        ),
                      ),
                    ),

                  ),
                ),
              ),
            ],
          ),


          /*
          title: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: Text(userModel.profileName, overflow: TextOverflow.ellipsis, style: TextStyle(color: _themeData.primaryColor),),
          ),
          */

          //centerTitle: true,

        ),
      ),
      actions: <Widget>[

        _bloc.getCurrentUserId == _bloc.getProfileUserId? IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: _bloc.getCurrentUserId == _bloc.getProfileUserId? (){

              ProfileBlocProvider.of(context).profileViewHandlers.showProfileOptionMenuDialog(profileContext: context);

            }: null
        ): Container()

      ],

    );

  }

}





class StatusWidget extends StatelessWidget{
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Text(
        _bloc.getProfileUserModel.profileStatus,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: RGBColors.white,

      ),
    );
  }
}










class FollowButtonWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;




    return _bloc.getCurrentUserId == _bloc.getProfileUserId?
        Container(

          child: Animator(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            repeats: 1,
            curve: Curves.easeInOutBack,
            duration: Duration(seconds: 1),
            builder: (anim){
              return Transform.scale(
                  scale: anim.value,
                  child: CupertinoButton.filled(



                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    onPressed: (){

                      Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (BuildContext context) => ProfileSettings(
                                currentUserId: _bloc.getCurrentUserId,
                                profileThumb: _bloc.getProfileUserModel.profileThumb,
                              )
                          )
                      );
                    },
                    borderRadius: BorderRadius.circular(100.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.edit,),
                        SizedBox(width: screenWidth * scaleFactor * scaleFactor,),
                        Text(ProfileWidgetStrings.profile_state_btn_edit, style: TextStyle(fontSize: Theme.of(context).textTheme.button.fontSize)),
                      ],
                    ),
                  ),
              );
            },
          ),

        )

        : StreamBuilder<Event>(
      stream: _bloc.checkCurrentUserIsAFollowerStreamEvent(
          currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,
          profileUserId: _bloc.getProfileUserModel.userId
      ),
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot){



        switch(snapshot.connectionState){
          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            return SpinKitPulse(color: _themeData.primaryColor,);
          case ConnectionState.done: case ConnectionState.active:

            if (snapshot.data.snapshot.value == null){

              return StreamBuilder<Event>(
                stream: _bloc.checkProfileUserIsCurrentUserFollowerStreamEvent(
                    currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,
                    profileUserId: _bloc.getProfileUserModel.userId
                ),
                builder: (streamContext, profileUserIsCurrentUserFollowerSnapshot) {
                  return Animator(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    repeats: 1,
                    curve: Curves.easeInOutBack,
                    duration: Duration(seconds: 1),
                    builder: (anim){
                      return Transform.scale(
                          scale: anim.value,
                          child: Container(
                            child: CupertinoButton.filled(
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                              onPressed: (){


                                _bloc.addProfileUserFollower(
                                    optimisedFFModel: OptimisedFFModel(
                                        user_id: AppBlocProvider.of(context).bloc.getCurrentUserId,
                                        t: Timestamp.now().millisecondsSinceEpoch
                                    ),
                                    profileUserId: _bloc.getProfileUserModel.userId
                                ).then((_){

                                  AppBlocProvider.of(context).bloc.increaseUserPoints(
                                      userId: _bloc.getProfileUserId,
                                      points: achievements_services.RewardsTypePoints.followers_growth_reward_point
                                  );
                                });


                                _bloc.addCurrentUserFollowing(
                                    optimisedFFModel: OptimisedFFModel(
                                        user_id: _bloc.getProfileUserId,
                                        t: Timestamp.now().millisecondsSinceEpoch
                                    ),
                                    currentUserId: _bloc.getCurrentUserId
                                );


                                _bloc.setNumberOfFollowers = _bloc.getNumberOfFollowers + 1;
                                _bloc.addNumberOfFollowersToStream(_bloc.getNumberOfFollowers);

                              },
                              borderRadius: BorderRadius.circular(100.0),
                              child: Text(profileUserIsCurrentUserFollowerSnapshot.hasData && profileUserIsCurrentUserFollowerSnapshot.data.snapshot.value == null
                                  ? ProfileWidgetStrings.profile_state_btn_follow
                                  : ProfileWidgetStrings.profile_state_btn_follow_back,
                                  style: TextStyle(fontSize: Theme.of(context).textTheme.button.fontSize)
                              ),
                            ),
                          )
                      );
                    },
                  );
                }
              );

            }
            else{

              return Animator(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                repeats: 1,
                curve: Curves.easeInOutBack,
                duration: Duration(seconds: 1),
                builder: (anim){
                  return Transform.scale(
                      scale: anim.value,
                      child: Container(
                        child: CupertinoButton(
                          color: _themeData.primaryColor.withOpacity(0.3),
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                          onPressed: (){

                            ProfileBlocProvider.of(context).profileViewHandlers.showUnfollowUserActionDialog(profileContext: context);
                          },
                          borderRadius: BorderRadius.circular(100.0),
                          child: Text(ProfileWidgetStrings.profile_state_btn_following, style: TextStyle(fontSize: Theme.of(context).textTheme.button.fontSize)),
                        ),
                      )
                  );
                },
              );

            }
            break;

          default:

            return Container(
              child: SpinKitPulse(color: _themeData.primaryColor,),
            );
        }


      },
    );
  }

}





class NumberOfFollowersWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<int>(
      stream: _bloc.getNumberOfFollowersStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){

        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: ProfileWidgetStrings.profile_followers_text,
              style: TextStyle(
                color: RGBColors.white,
              ),
              children: <TextSpan>[

                TextSpan(text: ProfileWidgetStrings.profile_newline_character),
                TextSpan(
                  //text: "${snapshot.data.snapshot.value}",
                    text: snapshot.hasData? StringUtils.formatNumber(snapshot.data): StringUtils.formatNumber(0),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(context).textTheme.headline.fontSize,
                        color: _themeData.primaryColor
                    )
                )


              ]
          ),
        );

      }
    );
  }

}



class NumberOfFollowingsWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<int>(
      stream: _bloc.getNumberOfFollowingsStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){

        if (snapshot.hasData){
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: ProfileWidgetStrings.profile_followings_text,
                style: TextStyle(
                  color: RGBColors.white
                ),
                children: <TextSpan>[

                  TextSpan(text: ProfileWidgetStrings.profile_newline_character),
                  TextSpan(
                      text: StringUtils.formatNumber(snapshot.data),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(context).textTheme.headline.fontSize,
                          color: _themeData.primaryColor
                      )
                  )


                ]
            ),
          );
        }
        else{
          return SpinKitPulse(color: _themeData.primaryColor,);
        }


      },
    );

  }

}




class NumberOfPostsWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return _bloc.getCurrentUserId == _bloc.getProfileUserId? StreamBuilder<Event>(
        stream: _bloc.getNumberOfPostsStreamEvent(profileUserId: _bloc.getProfileUserId),
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot){

          if (snapshot.hasData){
            return RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: ProfileWidgetStrings.profile_num_posts_text,
                  style: TextStyle(
                    color: RGBColors.white,
                  ),
                  children: <TextSpan>[

                    TextSpan(
                        text: ProfileWidgetStrings.profile_newline_character
                    ),
                    TextSpan(
                      //text: "${snapshot.data.snapshot.value}",
                        text: StringUtils.formatNumber(snapshot.data.snapshot.value),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Theme.of(context).textTheme.headline.fontSize,
                            color: _themeData.primaryColor
                        )
                    )
                  ]
              ),
            );
          }
          else {
            return SpinKitPulse(color: _themeData.primaryColor,);
          }

        }
    ):
    StreamBuilder<int>(
      stream: _bloc.getNumberOfPostsStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){


        if (snapshot.hasData){
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: ProfileWidgetStrings.profile_num_posts_text,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subhead.fontSize,
                  color: RGBColors.light_grey_level_1,
                ),
                children: <TextSpan>[

                  TextSpan(text: ProfileWidgetStrings.profile_newline_character),
                  TextSpan(
                      text: StringUtils.formatNumber(snapshot.data),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(context).textTheme.headline.fontSize,
                          color: _themeData.primaryColor
                      )
                  )


                ]
            ),
          );
        }
        else{
          return SpinKitPulse(color: _themeData.primaryColor,);
        }


      },
    );
  }





}




class NumberOfFriendsWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    if (_bloc.getProfileUserId == _bloc.getCurrentUserId){
      return Container(
        child: StreamBuilder<int>(
            stream: _bloc.getNumberOfFriendsStream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot){

              return RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "FRIENDS",
                    style: TextStyle(
                      color: RGBColors.white,
                    ),
                    children: <TextSpan>[

                      TextSpan(text: ProfileWidgetStrings.profile_newline_character),
                      TextSpan(
                        //text: "${snapshot.data.snapshot.value}",
                          text: snapshot.hasData? StringUtils.formatNumber(snapshot.data): StringUtils.formatNumber(0),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context).textTheme.headline.fontSize,
                              color: _themeData.primaryColor
                          )
                      )


                    ]
                ),
              );

            }
        ),
      );
    }
    else{

      return Container();
    }


  }

}






class NumberOfPointsWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
      stream: _bloc.getIsCurrentUserProfileStream,
      builder: (context, isCurrentUserProfileSnapshot) {

        switch(isCurrentUserProfileSnapshot.connectionState){
          case ConnectionState.none: case ConnectionState.waiting:

            return SpinKitPulse(color: _themeData.primaryColor,);
          case ConnectionState.active:case ConnectionState.done:


            if (isCurrentUserProfileSnapshot.hasData && isCurrentUserProfileSnapshot.data){

              return GestureDetector(

                onTap: (){

                  if (isCurrentUserProfileSnapshot.hasData && isCurrentUserProfileSnapshot.data){

                    Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Achievements()));
                  }
                },

                child: Container(
                  child: StreamBuilder<RewardPointsModel>(
                      stream: _bloc.getAchievedRewardPointsModelStream,
                      builder: (BuildContext context, AsyncSnapshot<RewardPointsModel> rewardModelSnapshot){

                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "POINTS",
                              style: TextStyle(
                                color: RGBColors.white,
                              ),
                              children: <TextSpan>[

                                TextSpan(text: ProfileWidgetStrings.profile_newline_character),
                                TextSpan(
                                    text: rewardModelSnapshot.hasData? "${rewardModelSnapshot.data.points}": "0",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Theme.of(context).textTheme.headline.fontSize,
                                        color: _themeData.primaryColor
                                    )
                                )

                              ]
                          ),
                        );

                      }
                  ),
                ),
              );

            }
            else{

              return StreamBuilder<bool>(
                stream: _bloc.getIsProfileUserAndCurrentUserFriendsStream,
                builder: (context, isFriendsnapshot) {

                  switch(isFriendsnapshot.connectionState){

                    case ConnectionState.none:case ConnectionState.waiting:

                      return SpinKitPulse(color: _themeData.primaryColor,);
                    case ConnectionState.active:case ConnectionState.done:


                    if (isFriendsnapshot.hasData && isFriendsnapshot.data){

                        return Container(
                          child: StreamBuilder<RewardPointsModel>(
                              stream: _bloc.getAchievedRewardPointsModelStream,
                              builder: (BuildContext context, AsyncSnapshot<RewardPointsModel> rewardModelSnapshot){

                                return RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: "POINTS",
                                      style: TextStyle(
                                        color: RGBColors.white,
                                      ),
                                      children: <TextSpan>[

                                        TextSpan(text: ProfileWidgetStrings.profile_newline_character),
                                        TextSpan(
                                            text: rewardModelSnapshot.hasData? "${rewardModelSnapshot.data.points}": "0",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Theme.of(context).textTheme.headline.fontSize,
                                                color: _themeData.primaryColor
                                            )
                                        )

                                      ]
                                  ),
                                );

                              }
                          ),
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
    );
  }

}








class FriendRequestButtonWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    if (_bloc.getCurrentUserId == _bloc.getProfileUserId){
      return Container();
    }
    else{

      return StreamBuilder<UserModel>(
          stream: _bloc.getProfileUserModelStream,
          builder: (buildContext, profileUserModelSnapshot) {

            if (profileUserModelSnapshot.hasData){

              return StreamBuilder<UserModel>(
                  stream: _bloc.getCurrentUserModelStream,
                  builder: (buildContext, currentUserModelSnapshot) {


                    if (currentUserModelSnapshot.hasData){


                      if ((currentUserModelSnapshot.data?.friends != null && currentUserModelSnapshot.data?.friends.length >= AppFeaturesMaxLimits.MAX_NUMBER_OF_FRIENDS)
                          || (profileUserModelSnapshot.data?.friends != null && profileUserModelSnapshot.data?.friends.length >= AppFeaturesMaxLimits.MAX_NUMBER_OF_FRIENDS)
                      ){
                        return Container();
                      }
                      else{
                        return StreamBuilder<bool>(
                            stream: _bloc.getIsProfileUserAndCurrentUserFriendsStream,
                            builder: (buildContext, snapshot) {

                              switch(snapshot.connectionState){
                                case ConnectionState.none:
                                  return Container();
                                case ConnectionState.waiting:
                                  return SpinKitPulse(color: _themeData.primaryColor,);
                                case ConnectionState.done: case ConnectionState.active:
                                if (snapshot.hasData && snapshot.data){
                                  return Animator(
                                    tween: Tween<double>(begin: 0.0, end: 1.0),
                                    repeats: 1,
                                    curve: Curves.easeInOutBack,
                                    duration: Duration(seconds: 1),
                                    builder: (anim){
                                      return Transform.scale(
                                          scale: anim.value,
                                          child: Container(
                                            child: CupertinoButton(
                                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                                              color: _themeData.primaryColor.withOpacity(0.3),

                                              onPressed: (){


                                              },
                                              borderRadius: BorderRadius.circular(100.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Icon(FontAwesomeIcons.solidHandshake),
                                                  SizedBox(width: screenWidth * scaleFactor * 0.25,),
                                                  Text("Friends", style: TextStyle(fontSize: Theme.of(context).textTheme.button.fontSize), textAlign: TextAlign.center,),
                                                ],
                                              ),
                                            ),
                                          )
                                      );
                                    },
                                  );
                                }
                                else{

                                  if (profileUserModelSnapshot.data.receiveFriendrequest == false){
                                    return Container();
                                  }
                                  else if (currentUserModelSnapshot.data.receiveFriendrequest == false){
                                    return Container();
                                  }


                                  return Container(
                                    child: StreamBuilder<Event>(
                                      stream: _bloc.checkCurrentUserSentFriendRequestToProfileUserStreamEvent(
                                          currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,
                                          profileUserId: _bloc.getProfileUserModel.userId
                                      ),
                                      builder: (BuildContext buildContext, AsyncSnapshot<Event> snapshot){



                                        switch(snapshot.connectionState){
                                          case ConnectionState.none:
                                            return Container();
                                          case ConnectionState.waiting:
                                            return SpinKitPulse(color: _themeData.primaryColor,);
                                          case ConnectionState.done: case ConnectionState.active:

                                          if (snapshot.hasData && snapshot.data.snapshot.value == null){

                                            return StreamBuilder<Event>(
                                                stream: _bloc.checkProfileUserSentFriendRequestToCurrentUserStreamEvent(
                                                    currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,
                                                    profileUserId: _bloc.getProfileUserModel.userId
                                                ),
                                                builder: (buildContext, profileUserSentFriendRequestToCurrentUserSnapshot) {

                                                  switch(profileUserSentFriendRequestToCurrentUserSnapshot.connectionState){
                                                    case ConnectionState.none:
                                                      return Container();
                                                    case ConnectionState.waiting:
                                                      return SpinKitPulse(color: _themeData.primaryColor,);
                                                    case ConnectionState.done: case ConnectionState.active:
                                                    if (profileUserSentFriendRequestToCurrentUserSnapshot.hasData
                                                        && profileUserSentFriendRequestToCurrentUserSnapshot.data.snapshot.value == null
                                                    ){

                                                      return Animator(
                                                        tween: Tween<double>(begin: 0.0, end: 1.0),
                                                        repeats: 1,
                                                        curve: Curves.easeInOutBack,
                                                        duration: Duration(seconds: 1),
                                                        builder: (anim){
                                                          return Transform.scale(
                                                              scale: anim.value,
                                                              child: Container(
                                                                child: CupertinoButton.filled(
                                                                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                                                  onPressed: (){


                                                                    AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection){

                                                                      if (hasInternetConnection != null && hasInternetConnection){


                                                                        _bloc.sendFriendRequest(currentUserId: _bloc.getCurrentUserId, profileUserId: _bloc.getProfileUserId).then((_){


                                                                          _bloc.checkIfUserSentFriendRequestNotification(
                                                                              currentUserId: _bloc.getCurrentUserId,
                                                                              profileUserId: _bloc.getProfileUserId
                                                                          ).then((bool hasAlreadySentNotification){

                                                                            if (hasAlreadySentNotification != null && hasAlreadySentNotification){
                                                                              // Do thing
                                                                            }
                                                                            else{

                                                                              _bloc.sendFriendRequestNotification(
                                                                                  optimisedNotificationModel: OptimisedNotificationModel(
                                                                                      from: _bloc.getCurrentUserId,
                                                                                      n_type: constants.NotificationType.friend_req,
                                                                                      t: Timestamp.now().millisecondsSinceEpoch
                                                                                  ),
                                                                                  profileUserId: _bloc.getProfileUserId
                                                                              );
                                                                            }

                                                                          });



                                                                          BasicUI.showSnackBar(
                                                                              context: context,
                                                                              message: "Friendship Request sent",
                                                                              textColor:  _themeData.primaryColor,
                                                                              duration: Duration(seconds: 1)
                                                                          );
                                                                        });

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
                                                                  borderRadius: BorderRadius.circular(100.0),
                                                                  child: Text("Request \nFriendship",
                                                                    style: TextStyle(fontSize: Theme.of(context).textTheme.button.fontSize),
                                                                    textAlign: TextAlign.center,
                                                                  ),

                                                                ),
                                                              )
                                                          );
                                                        },
                                                      );
                                                    }
                                                    else{
                                                      return Animator(
                                                        tween: Tween<double>(begin: 0.0, end: 1.0),
                                                        repeats: 1,
                                                        curve: Curves.easeInOutBack,
                                                        duration: Duration(seconds: 1),
                                                        builder: (anim){
                                                          return Transform.scale(
                                                              scale: anim.value,
                                                              child: Container(
                                                                child: CupertinoButton(
                                                                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                                                  color: CupertinoColors.activeGreen,
                                                                  onPressed: (){



                                                                    AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection)async{

                                                                      if (hasInternetConnection != null && hasInternetConnection){

                                                                        ProfileBlocProvider.of(context).profileViewHandlers.showAcceptFriendRequestActionModal(profileContext: context);
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
                                                                  borderRadius: BorderRadius.circular(100.0),
                                                                  child: Text("Accept \nFriendship",
                                                                    style: TextStyle(fontSize: Theme.of(context).textTheme.button.fontSize),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              )
                                                          );
                                                        },
                                                      );
                                                    }
                                                    break;

                                                    default:
                                                      return Container(
                                                        child: SpinKitPulse(color: _themeData.primaryColor,),
                                                      );


                                                  }


                                                }
                                            );

                                          }
                                          else{

                                            return Animator(
                                              tween: Tween<double>(begin: 0.0, end: 1.0),
                                              repeats: 1,
                                              curve: Curves.easeInOutBack,
                                              duration: Duration(seconds: 1),
                                              builder: (anim){
                                                return Transform.scale(
                                                    scale: anim.value,
                                                    child: Container(
                                                      child: CupertinoButton(
                                                        color: CupertinoColors.destructiveRed,
                                                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                                                        onPressed: (){

                                                          AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection){

                                                            if (hasInternetConnection != null && hasInternetConnection){

                                                              _bloc.removeFriendRequest(currentUserId: _bloc.getCurrentUserId, profileUserId: _bloc.getProfileUserId).then((_){

                                                                _bloc.removeFriendRequestNotification(
                                                                    currentUserId: _bloc.getCurrentUserId,
                                                                    profileUserId: _bloc.getProfileUserId
                                                                );

                                                                BasicUI.showSnackBar(
                                                                    context: context,
                                                                    message: "Friend Request canceled",
                                                                    textColor:  _themeData.primaryColor,
                                                                    duration: Duration(seconds: 1)
                                                                );

                                                              });

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
                                                        borderRadius: BorderRadius.circular(100.0),
                                                        child: Text("Cancel Friend \nRequest",
                                                          style: TextStyle(fontSize: Theme.of(context).textTheme.button.fontSize),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    )
                                                );
                                              },
                                            );

                                          }
                                          break;

                                          default:

                                            return Container(
                                              child: SpinKitPulse(color: _themeData.primaryColor,),
                                            );
                                        }


                                      },
                                    ),
                                  );
                                }
                              }



                            }
                        );
                      }

                    }
                    else{
                      return SpinKitPulse(color: _themeData.primaryColor,);
                    }

                  }
              );

            }
            else{
              return SpinKitPulse(color: _themeData.primaryColor,);
            }

          }
      );
    }


  }

}






class PostTypeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ProfileBlocProvider _provider = ProfileBlocProvider.of(context);
    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
      child: Row(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
              child: InkWell(

                onTap: (){


                  if (_bloc.getPostType != null){

                    _bloc.addPostTypeToStream(null);

                    _bloc.loadPosts(
                        profileUserId: _bloc.getProfileUserId,
                        postType: null,
                        postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
                        postQueryLimit: _bloc.getPostsQueryLimit
                    );

                    _bloc.addBackgroundColorValueToStream(Colors.white.value);
                  }


                },


                child: StreamBuilder<String>(

                    stream: _bloc.getBackgroundImageStream,
                    builder: (context, snapshot) {
                      return Container(
                        width: screenWidth * 0.33,
                        padding: EdgeInsets.symmetric(horizontal:screenWidth * scaleFactor * 0.25, vertical:  screenWidth * scaleFactor * scaleFactor),
                        decoration: BoxDecoration(
                            color: _themeData.primaryColor,
                            borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    snapshot.hasData
                                        ?  snapshot.data
                                        : ""),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(_themeData.primaryColor, BlendMode.color)
                            )
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Icon(CupertinoIcons.person_solid, color: Colors.white,),

                            Text("All", style: TextStyle(color: Colors.white, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),)

                          ],
                        ),
                      );
                    }
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
              child: InkWell(

                onTap: (){


                  if (_bloc.getPostType != constants.PostType.video){

                    _bloc.addPostTypeToStream(constants.PostType.video);

                    _bloc.loadPosts(
                        profileUserId: _bloc.getProfileUserId,
                        postType: constants.PostType.video,
                        postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
                        postQueryLimit: _bloc.getPostsQueryLimit
                    );

                    _bloc.addBackgroundColorValueToStream(Colors.purple.value);
                  }

                },

                child: Container(
                  width: screenWidth * 0.33,
                  padding: EdgeInsets.symmetric(horizontal:screenWidth * scaleFactor * 0.25, vertical:  screenWidth * scaleFactor * scaleFactor),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25),
                      image: DecorationImage(
                          image: AssetImage(PostTypeBackgroundImages.video),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.purple, BlendMode.color)

                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Icon(FontAwesomeIcons.film, color: Colors.white,),

                      Text("Video", style: TextStyle(color: Colors.white, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),)


                    ],
                  ),
                ),
              ),
            ),



            Padding(
              padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
              child: InkWell(

                onTap: (){



                  if (_bloc.getPostType != constants.PostType.image){

                    _bloc.addPostTypeToStream(constants.PostType.image);

                    _bloc.loadPosts(
                        profileUserId: _bloc.getProfileUserId,
                        postType: constants.PostType.image,
                        postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
                        postQueryLimit: _bloc.getPostsQueryLimit
                    );

                    _bloc.addBackgroundColorValueToStream(Colors.yellowAccent.value);

                  }


                },

                child: Container(
                  width: screenWidth * 0.33,
                  padding: EdgeInsets.symmetric(horizontal:screenWidth * scaleFactor * 0.25, vertical:  screenWidth * scaleFactor * scaleFactor),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25),
                      image: DecorationImage(
                          image: AssetImage(PostTypeBackgroundImages.image),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.yellowAccent, BlendMode.color)
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Icon(FontAwesomeIcons.solidImages, color: Colors.white,),

                      Text("Image", style: TextStyle(color: Colors.white, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),)


                    ],
                  ),
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
              child: InkWell(

                onTap: (){


                  if (_bloc.getPostType != constants.PostType.audio){

                    _bloc.addPostTypeToStream(constants.PostType.audio);

                    _bloc.loadPosts(
                        profileUserId: _bloc.getProfileUserId,
                        postType: constants.PostType.audio,
                        postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
                        postQueryLimit: _bloc.getPostsQueryLimit
                    );

                    _bloc.addBackgroundColorValueToStream(Colors.pinkAccent.value);
                  }


                },

                child: Container(
                  width: screenWidth * 0.33,
                  padding: EdgeInsets.symmetric(horizontal:screenWidth * scaleFactor * 0.25, vertical:  screenWidth * scaleFactor * scaleFactor),
                  decoration: BoxDecoration(
                      color: CupertinoColors.activeOrange,
                      borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25),
                      image: DecorationImage(
                          image: AssetImage(PostTypeBackgroundImages.audio),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.pinkAccent, BlendMode.color)
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Icon(FontAwesomeIcons.headphonesAlt, color: Colors.white,),

                      Text("Audio", style: TextStyle(color: Colors.white, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),)

                    ],
                  ),
                ),
              ),
            ),

          ]
      ),
    );
  }
}











class LoadingVideosIndicatorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return SliverList(delegate: SliverChildListDelegate(
        <Widget>[
          Container(
              child: StreamBuilder(
                stream: _bloc.getHasMorePostsStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.waiting:
                      return SpinKitChasingDots(color: _themeData.primaryColor,);
                    case ConnectionState.active: case ConnectionState.done:

                    if (snapshot.hasData && snapshot.data){
                      return SpinKitChasingDots(color: _themeData.primaryColor,);
                    }
                    else{

                      return Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * scaleFactor * 0.25,
                            bottom: screenHeight * scaleFactor
                        ),
                        child: Center(
                          child: StreamBuilder<String>(
                              stream: _bloc.getPostTypeStream,
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                                if (snapshot.hasData){

                                  switch(snapshot.data){
                                    case constants.PostType.video:
                                      return Text(_bloc.getPostsList.length > 0? "No More Videos": "No Videos",
                                        style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                                      );
                                    case constants.PostType.image:
                                      return Text(_bloc.getPostsList.length > 0? "No More Images": "No Images",
                                        style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                                      );
                                    case constants.PostType.audio:
                                      return Text(_bloc.getPostsList.length > 0? "No More Audios": "No Audios",
                                        style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                                      );
                                    default:
                                      return Text(_bloc.getPostsList.length > 0? "No More Posts": "No Posts",
                                        style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                                      );
                                  }

                                }
                                {
                                  return Text(_bloc.getPostsList.length > 0? "No More Posts": "No Posts",
                                    style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                                  );
                                }


                              }
                          ),
                        ),
                      );


                      /*
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.125),
                          child: ScaleAnimatedTextKit(
                            text: ["No", "More", "Videos", "No Videos Uploaded"],
                            textStyle: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                            alignment: Alignment.center,
                            isRepeatingAnimation: false,
                            //duration: Duration(milliseconds: 4000),
                          ),
                        ),
                      );
                      */

                    }
                  }


                },
              )
          )
        ]
    ));
  }

}








class ProfileAudioWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return StreamBuilder<UserModel>(
      stream: _bloc.getProfileUserModelStream,
      builder: (context, snapshot) {

        if (snapshot.hasData && snapshot.data.profileAudio != null){

          return Container(
            width: screenWidth * scaleFactor * 1.5 * 2,
            height: screenWidth * scaleFactor * 1.5 * 2,
            child: Image.asset(
              media_constants.ImagesConstants.music_note_animation_gif,
              fit: BoxFit.cover,
              color: _themeData.primaryColor.withOpacity(0.5),

              //filterQuality: FilterQuality.low,
            ),
          );
        }
        else{
          return Container();
        }

      }
    );
  }

}






