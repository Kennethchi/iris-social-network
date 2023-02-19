import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'profile_bloc.dart';
import 'profile_view_handlers.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:audioplayers/audioplayers.dart';


class ProfileBlocProvider extends InheritedWidget{


  final Key key;
  final Widget child;
  final ProfileBloc bloc;

  ProfileViewHandlers profileViewHandlers;

  OverlayState overlayState;
  OverlayEntry overlayEntry;


  ScrollController scrollController;

  AudioPlayer audioPlayer;


  ProfileBlocProvider({@required this.bloc, @required this.audioPlayer, @required this.scrollController, this.key, this.child}): super(key: key, child: child){

    profileViewHandlers = ProfileViewHandlers();

    bloc.getProfileUserModelStream.listen((UserModel profileUserModel)async{
      if(profileUserModel != null && profileUserModel.profileAudio != null){
        
        File cachedAudioFile = await bloc.getCachedNetworkFile(urlPath: profileUserModel.profileAudio);

        if (cachedAudioFile != null){
          audioPlayer.play(cachedAudioFile.path, isLocal: true).then((int isPlaying){

            if (isPlaying == 1){
             // bloc.addIsProfileAudioInitialisedToStream(true);
            }

            bloc.addIsProfileAudioInitialisedToStream(true);
          });
          audioPlayer.onPlayerCompletion.listen((_){
            audioPlayer.resume();
          });
        }
      }
    });


    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 0.0;


      if (maxScroll - currentScroll < deltaBottom){

        if ((bloc.getHasLoadedPosts == false || bloc.getHasLoadedPosts == null) && bloc.getHasMorePosts) {

          bloc.setHasLoadedPosts = true;

          bloc.loadMorePosts(
            profileUserId: bloc.getProfileUserId,
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



  static ProfileBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(ProfileBlocProvider) as ProfileBlocProvider);



  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;


}