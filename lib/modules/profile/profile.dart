import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/modules/profile/profile_view_handlers.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'package:iris_social_network/widgets/particles/confetti_particles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_bloc.dart';
import 'profile_bloc_provider.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'profile_views.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:after_layout/after_layout.dart';
import 'package:audioplayers/audioplayers.dart';


class Profile extends StatefulWidget{


  static const String routeName = AppRoutes.profile_screen;

  String profileUserId;

  Profile({
    @required this.profileUserId
});


  @override
  _ProfileState createState() => new _ProfileState();
}


class _ProfileState extends State<Profile> with WidgetsBindingObserver, AfterLayoutMixin<Profile>{


  ProfileBloc _bloc;

  ScrollController _scrollController;

  AudioPlayer _audioPlayer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    assert(widget.profileUserId != null, "Profile Id should not be null");

    WidgetsBinding.instance.addObserver(this);

    _bloc = ProfileBloc(profileUserId: widget.profileUserId);

    _scrollController = ScrollController();

    _audioPlayer = AudioPlayer();
  }


  @override
  void dispose() {
    // TODO: implement dispose

    WidgetsBinding.instance.removeObserver(this);

    _bloc.dispose();
    _scrollController.dispose();

    _audioPlayer.stop();
    _audioPlayer.release();
    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    switch(state){
      case AppLifecycleState.inactive:
        this._audioPlayer.stop();
        break;
      case AppLifecycleState.paused:
        this._audioPlayer.pause();
        break;
      case AppLifecycleState.resumed:
        this._audioPlayer.resume();
        break;
      case AppLifecycleState.detached:
        this._audioPlayer.stop();
        break;
    }
  }


  @override
  void afterFirstLayout(BuildContext context) {

    AppBlocProvider.of(context).bloc.getFirebaseUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null && (firebaseUser.uid == widget.profileUserId)){

        Timer(Duration(seconds: 2), (){
          SharedPreferences.getInstance().then((sharedPrefs)async{
            bool quitShowingGuideStoredValue = sharedPrefs.getBool(app_constants.SharedPrefsKeys.show_profile_screen_ui_guide);
            if (quitShowingGuideStoredValue == null){
              bool quitShowingGuide = await ProfileViewHandlers.showProfileHelpDialogAndGetShouldPopAgain(context: context);
              sharedPrefs.setBool(app_constants.SharedPrefsKeys.show_profile_screen_ui_guide, quitShowingGuide);
            }
          });
        });


        AppBlocProvider.of(context).bloc.getTotalAchievedPoints(userId: firebaseUser.uid).then((int totalPoints){
          if (totalPoints != null){
            _bloc.addAcheivedRewardPointsModelToStream(RewardPointsModel(points: totalPoints));
          }
        });
      }
    });

  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProfileBlocProvider(
      bloc: _bloc,
      audioPlayer: this._audioPlayer,
      scrollController: _scrollController,
      child: Scaffold(

        body: CupertinoPageScaffold(

            backgroundColor: Colors.transparent,

            child: ProfileView(),
          //child: ConfettiParticles()
        ),

      ),
    );
  }

}


