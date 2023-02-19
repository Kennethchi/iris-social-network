import 'package:animator/animator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'profile_bloc.dart';
import 'profile_bloc_provider.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'profile_views_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';



import 'package:random_pk/random_pk.dart';


import 'package:iris_social_network/modules/home/home.dart';
import 'dart:async';
import 'dart:io';
import 'package:iris_social_network/services/constants/app_constants.dart';

import 'package:iris_social_network/services/models/post_model.dart';

import 'package:iris_social_network/modules/post_space/post_space.dart';



class ProfileView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBlocProvider _provider = ProfileBlocProvider.of(context);
    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[

        Positioned.fill(
            child: VisibilityDetector(
              key: UniqueKey(),
              onVisibilityChanged: (VisibilityInfo info){
                _bloc.getIsProfileAudioInitialisedStream.listen((bool isProfileAudioInitialised){
                  if (isProfileAudioInitialised != null && isProfileAudioInitialised){
                    if (info.visibleFraction == 0.0){
                      _provider.audioPlayer.pause();
                    }
                    else if (info.visibleFraction == 1.0){
                      _provider.audioPlayer.resume();
                    }
                  }
                });
                print("Profile Visibility ${info.visibleFraction}");
              },
                child: Container()
            )
        ),

        Positioned.fill(

          child: Container(
            child: StreamBuilder<UserModel>(
              stream: _bloc.getProfileUserModelStream,
              builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot){

                if (snapshot.hasData){

                  return CustomScrollView(

                    controller: ProfileBlocProvider.of(context).scrollController,

                    slivers: <Widget>[

                      ProfileSliverAppBar(snapshot.data),

                      SliverList(delegate: SliverChildListDelegate(<Widget>[
                        PostTypeListWidget(),
                      ])),

                      SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: PostsSliverGridViewDismissible(),
                      ),

                      SliverPadding(
                          padding: EdgeInsets.all(5.0),
                          sliver: LoadingVideosIndicatorWidget()
                      )
                    ],

                  );

                }
                else{
                  return Container(
                    width: screenWidth,
                    height: screenHeight,
                    color: RGBColors.white,
                    child: Center(
                      child: SpinKitChasingDots(color: _themeData.primaryColor),
                    ),
                  );
                }


              },
            ),
          ),
        ),
      ],
    );
  }


}












class PostsSliverGridViewDismissible extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;

    return StreamBuilder<bool>(
      stream: _bloc.getIsCurrentUserProfileStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshots){

        if (snapshots.hasData && snapshots.data){

          return _PostsSliverGridView(isCurrentUserProfile: true);
        }
        else{

          return _PostsSliverGridView(isCurrentUserProfile: false,);
        }

      },

    );
  }
}




class _PostsSliverGridView extends StatelessWidget{

  bool isCurrentUserProfile;

  _PostsSliverGridView({@required this.isCurrentUserProfile});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<List<PostModel>>(
        stream: _bloc.getPostsListStream,
        builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshots){



          if (snapshots.hasData){


            if (snapshots.data.length == 0){
              return SliverList(delegate: SliverChildListDelegate(
                  <Widget>[

                    Container(),
                  ]
              ),);
            }
            else{


              return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: 10 / 16,
                  ),
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index){



                    return GestureDetector(

                      onTap: (){

                        Navigator.of(context).push(
                            PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> primaryAnimation, Animation<double> secondaryAnimation){
                              return PostSpace(
                                  dynamicBloc: _bloc,
                                  postsList: snapshots.data,
                                  currentPostViewIndex: index
                              );
                            }, transitionDuration: Duration(milliseconds: 500)
                            ));


                      },

                      child: Card(
                        elevation: 0.0,

                        child: this.isCurrentUserProfile? Dismissible(
                          key: UniqueKey(),

                          confirmDismiss: (DismissDirection direction)async{

                            if (direction == DismissDirection.startToEnd || direction == DismissDirection.endToStart){

                              ProfileBlocProvider.of(context).profileViewHandlers.showPostOptionDialog(profileContext: context, postModel: snapshots.data[index]);
                            }

                            return false;
                          },
                          onDismissed: (DismissDirection direction){

                          },

                          child: Hero(
                            tag: snapshots.data[index].postId,
                            child: Animator(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              repeats: 1,
                              curve: Curves.elasticOut,
                              duration: Duration(seconds: 1),
                              builder: (anim){
                                return Transform.scale(
                                    scale: anim.value,
                                  child: Container(
                                      child: ProfileBlocProvider.of(context).profileViewHandlers.getPostPreviewWidget(context: context, postModel: snapshots.data[index])
                                  ),
                                );
                              },
                            ),
                          )
                        ):

                        Hero(
                          tag: snapshots.data[index].postId,
                          child: Animator(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            repeats: 1,
                            curve: Curves.elasticOut,
                            duration: Duration(seconds: 1),
                            builder: (anim){
                              return Transform.scale(
                                scale: anim.value,
                                child: Container(
                                    child: ProfileBlocProvider.of(context).profileViewHandlers.getPostPreviewWidget(context: context, postModel: snapshots.data[index])
                                ),
                              );
                            },
                          ),
                        )

                      ),
                    );
                  },
                    childCount: snapshots.data.length,
                  )
              );

            }


          }
          else{

            return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: 10 / 16
                ),
                delegate: SliverChildBuilderDelegate((BuildContext context, int index){
                  return Container(
                    padding: EdgeInsets.all(2.0),
                    child: Animator(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      cycles: 1000000000,
                      curve: Curves.elasticOut,
                      duration: Duration(seconds: 1),
                      builder: (anim){
                        return Transform.scale(
                          scale: anim.value,
                          child: Container(
                            height: screenHeight,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25),
                              color: RGBColors.light_grey_level_1,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                    childCount: 4
                )
            );
          }




        }
    );
  }

}




















