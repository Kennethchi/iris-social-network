import 'dart:async';

import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/modules/post_room/post_room.dart';
import 'package:iris_social_network/modules/profile/profile.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'dart:convert';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:share/share.dart';
import 'app_bloc_provider.dart';
import 'app_bloc.dart';
import 'package:iris_social_network/services/app_services/dynamic_links_services.dart' as dynamic_links_services;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;




class AppDynamicLinksHandlers{

  Future<void> launchInviteDynamicLinkHandler({@required BuildContext pageContext})async{


    AppBlocProvider _provider = AppBlocProvider.of(pageContext);
    AppBloc _bloc = AppBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;

    final PendingDynamicLinkData pendingDynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();


    if(pendingDynamicLinkData != null && pendingDynamicLinkData.link.queryParameters.isNotEmpty){

      String inviteData = pendingDynamicLinkData.link.queryParameters[dynamic_links_services.DYNAMIC_LINK_INVITE_DATA_MAP_KEY];
      Map jsonDecodedInviteDataMap = jsonDecode(inviteData);
      String inviteUserId = jsonDecodedInviteDataMap[dynamic_links_services.DYNAMIC_LINK_INVITE_USER_ID_KEY];


      if (inviteData != null && inviteUserId != null) {


        _bloc.getAllCurrentUserData(currentUserId: inviteUserId).then((UserModel inviteUserModel)async{

          inviteUserModel.verifiedUser  = true;



          if (inviteUserModel != null) {

            inviteUserModel.verifiedUser  = true;

            FirebaseUser firebaseUser = await _bloc.getFirebaseUser();
            if (firebaseUser != null){
              UserModel userModel = await _bloc.getAllCurrentUserData(currentUserId: firebaseUser.uid);

              if (userModel != null && userModel.timestamp != null){
                DateTime currentUserSignUpDateTime = userModel.timestamp.toDate();
                DateTime dateTimeNow = DateTime.now();
                Duration differenceDuration = dateTimeNow.difference(currentUserSignUpDateTime);

                if (differenceDuration.inMinutes <= 10){

                  _bloc.increaseUserPoints(userId: firebaseUser.uid, points: achievements_services.RewardsTypePoints.invite_new_user_reward_point).then((totalPoits){

                    _provider.handler.showRewardAchievedDialog(
                        pageContext: pageContext,
                        points: achievements_services.RewardsTypePoints.invite_new_user_reward_point,
                      message: "For Signing Up through an Invite from @${inviteUserModel.username}"
                    );
                  });
                  _bloc.increaseUserPoints(userId: inviteUserId, points: achievements_services.RewardsTypePoints.invite_new_user_reward_point);
                }

              }
            }

            showDialog(
                barrierDismissible: false,
                context: pageContext,
                builder: (BuildContext context) {

                  return Center(
                    child: Animator(

                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      //repeats: 1,
                      curve: Curves.easeOutBack,
                      duration: Duration(milliseconds: 1000),
                      builder: (anim){
                        return Transform.scale(
                          scale: anim.value,
                          child: CupertinoAlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.clear, color: _themeData.primaryColor,),
                                )
                              ],
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[

                                CircleAvatar(
                                  radius: screenWidth * 0.2,
                                  backgroundColor: Colors.black.withOpacity(0.1),
                                  backgroundImage: CachedNetworkImageProvider(inviteUserModel.profileThumb != null? inviteUserModel.profileThumb : ""),
                                ),
                                SizedBox(height: screenHeight * scaleFactor * 0.25,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                        child: Text(inviteUserModel.profileName != null? inviteUserModel.profileName: "",
                                          style: TextStyle(
                                              color: Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.bold,
                                              fontSize: Theme.of(context).textTheme.title.fontSize
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                    ),

                                    Container(
                                      child: inviteUserModel.verifiedUser != null && inviteUserModel.verifiedUser? Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(width: 5.0,),
                                            Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: 15.0,),
                                          ],
                                        ),
                                      ): Container(),
                                    )
                                  ],
                                ),
                                Text("@" + inviteUserModel.username, style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),)
                              ],
                            ),
                            actions: <Widget>[

                              CupertinoDialogAction(
                                child: Text("Go to Profile",
                                  style: TextStyle(
                                      color: _themeData.primaryColor,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onPressed: (){
                                  Navigator.of(context).pop();

                                  Navigator.of(pageContext).push(CupertinoPageRoute(builder: (BuildContext context){
                                    return Profile(profileUserId: inviteUserId,);
                                  }));
                                },
                              )
                            ],
                          )
                        );
                      },
                    ),
                  );

            });
          }
        });
      }

    }


  }




  Future<void> launchSharedPostDynamicLink({@required BuildContext pageContext})async{


    AppBlocProvider _provider = AppBlocProvider.of(pageContext);
    AppBloc _bloc = AppBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;


    final PendingDynamicLinkData pendingDynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();


    if(pendingDynamicLinkData != null && pendingDynamicLinkData.link.queryParameters.isNotEmpty){

      String postData = pendingDynamicLinkData.link.queryParameters[dynamic_links_services.DYNAMIC_LINK_POST_DATA_MAP_KEY];
      Map jsonDecodedPostDataMap = jsonDecode(postData);
      String postId = jsonDecodedPostDataMap[dynamic_links_services.DYNAMIC_LINK_POST_ID_KEY];
      String postUserId = jsonDecodedPostDataMap[dynamic_links_services.DYNAMIC_LINK_POST_USER_ID_KEY];



      if (postData != null && postId != null && postUserId != null){

        _bloc.getSinglePostData(postId: postId, postUserId: postUserId).then((PostModel postModel){

          if (postModel != null){

            Timer(Duration(seconds: 1), (){
              showCupertinoDialog(
                  context: pageContext,
                  builder: (BuildContext context){
                    return PageView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        PostRoom(postModel: postModel),
                      ],
                    );
              });
            });

          }
        });
      }

    }
  }

}