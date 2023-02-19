import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'audio_widget.dart';
import 'profile_settings_bloc.dart';
import 'profile_settings_bloc_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:iris_social_network/services/server_services/constants.dart';


import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/utils/image_utils.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;



class SaveButtonWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(

      stream: _bloc.getProfileSettingsChangedStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

        return CupertinoButton(
            disabledColor: RGBColors.light_grey_level_1,
            padding: EdgeInsets.all(0.0),
            child: Text("Save",),
            onPressed: snapshot.hasData && snapshot.data? ()async{

              AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection)async{

                if (hasInternetConnection != null && hasInternetConnection){

                  ProfileSettingsBlocProvider.of(context).handlers.saveProfileSettings(context: context);

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

            }: null
        );

      },

    );

  }
}




class ProfileAvatarWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return GestureDetector(

      onTap: (){

        ProfileSettingsBlocProvider.of(context).handlers.showUploadImageOptionDialog(profileSettingsContext: context);


      },


      child: Container(
        width: screenWidth * 0.5,
        height: screenWidth * 0.5,
        child: Stack(
          children: <Widget>[

            Positioned.fill(
              child: StreamBuilder<String>(
                stream: _bloc.getProfileImageChangedStream,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                  if (snapshot.hasData){

                    return CircleAvatar(
                      radius: scaleFactor * screenWidth,
                      backgroundColor: RGBColors.light_grey_level_1,
                      backgroundImage: FileImage(File(snapshot.data)),
                    );

                  }
                  else{

                    return StreamBuilder(
                      stream: _bloc.getProfileImageStream,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                        switch(snapshot.connectionState){

                          case ConnectionState.none:case ConnectionState.waiting:
                            return Animator(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              repeats: 1,
                              curve: Curves.easeInOutBack,
                              duration: Duration(milliseconds: 1500),
                              builder: (anim){
                                return Transform.scale(
                                  scale: anim.value,
                                  child: CircleAvatar(
                                    radius: scaleFactor * screenWidth,
                                    backgroundImage: CachedNetworkImageProvider(""),
                                    backgroundColor: RGBColors.light_grey_level_1,
                                    child: Center(
                                      child: SpinKitThreeBounce(color: _themeData.primaryColor,),
                                    ),
                                  ),
                                );
                              },
                            );
                          case ConnectionState.active: case ConnectionState.done:


                            if (snapshot.hasData){

                              return Animator(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                repeats: 1,
                                curve: Curves.easeInOutBack,
                                duration: Duration(milliseconds: 1500),
                                builder: (anim){
                                  return Transform.scale(
                                    scale: anim.value,
                                    child: CircleAvatar(
                                      radius: scaleFactor * screenWidth,
                                      backgroundImage: CachedNetworkImageProvider(snapshot.data),
                                      backgroundColor: RGBColors.light_grey_level_1,
                                    ),
                                  );
                                },
                              );
                            }
                            else{
                              return Animator(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                repeats: 1,
                                curve: Curves.easeInOutBack,
                                duration: Duration(milliseconds: 1500),
                                builder: (anim){
                                  return Transform.scale(
                                    scale: anim.value,
                                    child: CircleAvatar(
                                      radius: scaleFactor * screenWidth,
                                      backgroundColor: RGBColors.light_grey_level_1,
                                    ),
                                  );
                                },
                              );
                            }

                        }



                      },
                    );
                  }

                },
              )
            ),


            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: Container(
                padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RGBColors.light_grey_level_1,
                    border: Border.all(color: RGBColors.white, width: 3.0)
                  ),
                  child: Icon(Icons.add_a_photo)
              ),
            )
          ],
        ),
      ),
    );
  }


}




class ProfileNameWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return InkWell(

      onTap: (){

        ProfileSettingsBlocProvider.of(context).handlers.showUpdateProfileNameModalDialog(profileSettingsContext: context);

      },

      child: Container(
          child: ListTile(
            leading: Icon(CupertinoIcons.person_solid, color: _themeData.barBackgroundColor,),
            title: Text("Profile Name", style: TextStyle(color: _themeData.barBackgroundColor),),

            subtitle: StreamBuilder(
              stream: _bloc.getProfileNameStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                switch(snapshot.connectionState){

                  case ConnectionState.none:case ConnectionState.waiting:
                    return Row(
                      children: <Widget>[
                        SpinKitThreeBounce(color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.5,),
                      ],
                  );
                  case ConnectionState.active: case ConnectionState.done:

                    if (snapshot.hasData){
                      return Text(snapshot.data, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: _themeData.primaryColor),);
                    }
                    else{
                      return Text("");
                    }
                }



              },
            ),
            trailing: Icon(Icons.edit, color: _themeData.barBackgroundColor,),
          )

      ),
    );

  }


}







class ProfileStatusWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return InkWell(

      onTap: (){

        ProfileSettingsBlocProvider.of(context).handlers.showUpdateProfileStatusModalDialog(profileSettingsContext: context);

      },

      child: Container(

          child: ListTile(

            leading: Icon(Icons.info_outline, color: _themeData.barBackgroundColor,),

            title: Text("Status", style: TextStyle(color: _themeData.barBackgroundColor),),

            subtitle: StreamBuilder(
              stream: _bloc.getProfileStatusStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                switch(snapshot.connectionState){

                  case ConnectionState.none:case ConnectionState.waiting:
                    return Row(
                      children: <Widget>[
                        SpinKitThreeBounce(color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.5,),
                      ],
                    );
                  case ConnectionState.active: case ConnectionState.done:

                    if (snapshot.hasData){
                      return Text(snapshot.data, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: _themeData.primaryColor),);
                    }
                    else{
                      return Text("");
                    }
                }



              },
            ),
            trailing: Icon(Icons.edit, color: _themeData.barBackgroundColor,),
          )

      ),
    );

  }


}







class ProfileUsernameWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return InkWell(

      onTap: (){

        ProfileSettingsBlocProvider.of(context).handlers.showUpdateUsernameModalDialog(profileSettingsContext: context);

      },

      child: Container(
          child: ListTile(

            leading: Icon(FontAwesomeIcons.idBadge, color: _themeData.barBackgroundColor,),

            title: Text("Username", style: TextStyle(color: _themeData.barBackgroundColor),),
            subtitle: StreamBuilder(
              stream: _bloc.getUserNameStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                switch(snapshot.connectionState){

                  case ConnectionState.none:case ConnectionState.waiting:
                  return Row(
                    children: <Widget>[
                      SpinKitThreeBounce(color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.5,),
                    ],
                  );
                  case ConnectionState.active: case ConnectionState.done:

                  if (snapshot.hasData){
                    return Text("@" + snapshot.data, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: _themeData.primaryColor),);
                  }
                  else{
                    return Text("");
                  }

                }

              },
            ),
          )

      ),
    );

  }


}







class ProfileGenderWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return InkWell(

      onTap: (){

        ProfileSettingsBlocProvider.of(context).handlers.showUpdateGenderTypeModalDialog(profileSettingsContext: context);
      },

      child: Container(
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(FontAwesomeIcons.male, color: _themeData.barBackgroundColor,),
              Icon(FontAwesomeIcons.female, color: _themeData.barBackgroundColor,)
            ],
          ),
          title: Text("Gender", style: TextStyle(color: _themeData.barBackgroundColor),),
          subtitle: StreamBuilder(
            stream: _bloc.getGenderTypeStream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){

              switch(snapshot.connectionState){

                case ConnectionState.none:case ConnectionState.waiting:
                return Row(
                  children: <Widget>[
                    SpinKitThreeBounce(color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.5,),
                  ],
                );
                case ConnectionState.active: case ConnectionState.done:

                if (snapshot.hasData){
                  return Text(snapshot.data, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: _themeData.primaryColor),);
                }
                else{
                  return Text("");
                }

              }

            },
          ),
          trailing: Icon(Icons.edit, color: _themeData.barBackgroundColor,),
        )

      ),
    );
  }


}











class ReceiveFriendRequestOptionWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(

        child: ListTile(

          leading: Icon(Icons.notifications, color: _themeData.barBackgroundColor,),

          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Receive Friend Request", style: TextStyle(color: _themeData.barBackgroundColor),),
            ],
          ),

          trailing: SizedBox(
            width: screenWidth * scaleFactor,
            child: StreamBuilder<bool>(
              stream: _bloc.getReceiveFriendRequestStream,
              builder: (context, snapshot) {


                switch(snapshot.connectionState){

                  case ConnectionState.none:case ConnectionState.waiting:
                    return SpinKitThreeBounce(color: _themeData.primaryColor, size: screenWidth * scaleFactor * scaleFactor,);

                  case ConnectionState.active: case ConnectionState.done:


                    if (snapshot.hasData){
                      return CupertinoSwitch(
                        value: snapshot.data,
                        onChanged: (bool shouldReceivedFriendRequest){

                          _bloc.addReceiveFriendRequestToStream(shouldReceivedFriendRequest);
                          _bloc.addProfileSettingsChangedToStream(true);
                        },
                      );
                    }
                    else{
                      return CupertinoSwitch(
                        value: true,
                        onChanged: (bool receivedFriendRequest){

                          _bloc.addReceiveFriendRequestToStream(receivedFriendRequest);
                          _bloc.addProfileSettingsChangedToStream(true);

                        },
                      );
                    }

                }



              }
            ),
          )
        ),

    );

  }


}









class ShowPublicPostsOptionWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(

      child: ListTile(

          leading: Icon(Icons.view_module, color: _themeData.barBackgroundColor,),

          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Show Public Posts", style: TextStyle(color: _themeData.barBackgroundColor),),
            ],
          ),

          trailing: SizedBox(
            width: screenWidth * scaleFactor,
            child: StreamBuilder<bool>(
                stream: _bloc.getShowPublicPostsStream,
                builder: (context, snapshot) {


                  switch(snapshot.connectionState){

                    case ConnectionState.none:case ConnectionState.waiting:
                      return SpinKitThreeBounce(color: _themeData.primaryColor, size: screenWidth * scaleFactor * scaleFactor,);

                    case ConnectionState.active: case ConnectionState.done:


                      if (snapshot.hasData){
                        return CupertinoSwitch(
                          value: snapshot.data,
                          onChanged: (bool showPublicPosts){

                            _bloc.addShowPublicPostsToStream(showPublicPosts);
                            _bloc.addProfileSettingsChangedToStream(true);
                          },
                        );
                      }
                      else{
                        return CupertinoSwitch(
                          value: true,
                          onChanged: (bool showPublicPosts){

                            _bloc.addShowPublicPostsToStream(showPublicPosts);
                            _bloc.addProfileSettingsChangedToStream(true);
                          },
                        );
                      }

                  }



                }
            ),
          )
      ),

    );

  }


}











class AppThemeColorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<RewardPointsModel>(
        stream: _bloc.getAchievedRewardPointsModelStream,
        builder: (context, snapshot) {

          switch(snapshot.connectionState){
            case ConnectionState.none: case ConnectionState.waiting:
              return Container();
            case ConnectionState.active:case ConnectionState.done:
              if (snapshot.hasData && snapshot.data.points >= achievements_services.AchievementsLevelsUnlockPoints.app_theme_color){
                return InkWell(

                  onTap: (){

                    ProfileSettingsBlocProvider.of(context).handlers.showAppThemeColorModalDialog(profileSettingsContext: context);
                  },

                  child: Container(
                      child: ListTile(
                        leading: Icon(Icons.palette, color: _themeData.barBackgroundColor,),
                        title: Text("App Theme Color", style: TextStyle(color: _themeData.barBackgroundColor),),

                        trailing: StreamBuilder<int>(
                            stream: _bloc.getAppThemeColorValueStream,
                            builder: (context, snapshot) {
                              return CircleAvatar(
                                backgroundColor: snapshot.hasData? Color(snapshot.data): _themeData.primaryColor,
                              );
                            }
                        ),
                      )

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
  



class ProfileAudioWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return StreamBuilder<RewardPointsModel>(
      stream: _bloc.getAchievedRewardPointsModelStream,
      builder: (context, snapshot) {

        switch(snapshot.connectionState){
          case ConnectionState.none: case ConnectionState.waiting:
            return Container();
          case ConnectionState.active:case ConnectionState.done:
            if (snapshot.hasData && snapshot.data.points >= achievements_services.AchievementsLevelsUnlockPoints.profile_audio){

              return InkWell(

                onTap: (){

                  ProfileSettingsBlocProvider.of(context).handlers.showProfileSoundsModalDialog(profileSettingsContext: context);
                },

                child: Container(
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.headphonesAlt, color: Colors.white,),
                      title: Text("Profile Audio", style: TextStyle(color: _themeData.barBackgroundColor),),


                      trailing: FittedBox(
                        child: StreamBuilder<String>(
                            stream: _bloc.getProfileAudioStream,
                            builder: (context, snapshot) {

                              switch(snapshot.connectionState){

                                case ConnectionState.none:case ConnectionState.waiting:
                                  return SpinKitThreeBounce(color: _themeData.primaryColor, size: screenWidth * scaleFactor * scaleFactor,);

                                case ConnectionState.active: case ConnectionState.done:
  
                                  if (snapshot.hasData){
                                    return ProfileSettingsAudioWidget(cachedAudioPath: snapshot.data,);
                                  }
                                  else{
                                    return Container();
                                  }
                              }
                            }
                        ),
                      ),

                    )

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












class InterestsWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileSettingsBlocProvider _provider = ProfileSettingsBlocProvider.of(context);
    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<RewardPointsModel>(
        stream: _bloc.getAchievedRewardPointsModelStream,
        builder: (context, snapshot) {

          switch(snapshot.connectionState){
            case ConnectionState.none: case ConnectionState.waiting:
              return Container();
            case ConnectionState.active:case ConnectionState.done:
              return GestureDetector(

                onTap: (){

                  _provider.handlers.showUserInterestsModalDialog(profileSettingsContext: context);
                },

                child: Container(
                  child: ListTile(
                    title: Text("Interests",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              );
              
          }
        }
    );

  }


}
  



