import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'profile_settings_view.dart';
import 'profile_settings_bloc.dart';
import 'profile_settings_bloc_provider.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'profile_settings_view_widgets.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:after_layout/after_layout.dart';



class ProfileSettings extends StatefulWidget{

  String currentUserId;
  String profileThumb;

  ProfileSettings({@required this.currentUserId, this.profileThumb});

  _ProfileSettingsState createState() => new _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> with AfterLayoutMixin<ProfileSettings>{


  ProfileSettingsBloc _bloc;

  TextEditingController _statusTextEditingController;
  TextEditingController _profileNameTextEditingController;

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _bloc = ProfileSettingsBloc(currentUserId: widget.currentUserId);

    _profileNameTextEditingController =  TextEditingController();
    _statusTextEditingController = TextEditingController();

  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    _profileNameTextEditingController.dispose();
    _statusTextEditingController.dispose();

    super.dispose();
  }


  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout

    _bloc.getProfileUserData(profileUserId: widget.currentUserId).then((UserModel currentUserModel)async{
      if (currentUserModel != null && currentUserModel.profileAudio != null){
        File cachedAudioFIle = await AppBlocProvider.of(context).bloc.getCachedNetworkFile(urlPath: currentUserModel.profileAudio);
        _bloc.addProfileAudioToStream(cachedAudioFIle.path);
      }
    });


    AppBlocProvider.of(context).bloc.getFirebaseUser().then((FirebaseUser firebaseUser){
      if (firebaseUser != null){
        AppBlocProvider.of(context).bloc.getTotalAchievedPoints(userId: firebaseUser.uid).then((int totalPoints){

          _bloc.addAcheivedRewardPointsModelToStream(RewardPointsModel(points: totalPoints));
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return ProfileSettingsBlocProvider(
      bloc: _bloc,
      profileNameTextEditingController: _profileNameTextEditingController,
      statusTextEditingController: _statusTextEditingController,
      child: Scaffold(

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.profileThumb),
              fit: BoxFit.cover
            )
          ),
          
          child: BackdropFilter(

            filter: ImageFilter.blur(
              sigmaX: WidgetsOptions.blurSigmaX,
              sigmaY: WidgetsOptions.blurSigmaY
            ),
            child: CupertinoPageScaffold(

              backgroundColor: Colors.black.withOpacity(0.2),

              navigationBar: CupertinoNavigationBar(
                middle: Text("Edit Profile", style: TextStyle(color: RGBColors.white.withOpacity(0.5)),),
                trailing: SaveButtonWidget(),
                backgroundColor: RGBColors.white.withOpacity(0.2),
              ),
              child: SafeArea(child: ProfileSettingsView()),
            ),
          ),
        ),
      ),
    );
  }


}