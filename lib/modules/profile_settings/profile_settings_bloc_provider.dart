import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'profile_settings_bloc.dart';
import 'profile_settings_views_handlers.dart';



class ProfileSettingsBlocProvider extends InheritedWidget{


  ProfileSettingsBloc bloc;
  Key key;
  Widget child;

  ProfileSettingsViewsHandlers handlers;

  TextEditingController statusTextEditingController;
  TextEditingController profileNameTextEditingController;



  ProfileSettingsBlocProvider({
    @required this.bloc,
    @required this.profileNameTextEditingController,
    @required this.statusTextEditingController, this.key, this.child
  })
      : super(key: key, child: child)
  {

    handlers = ProfileSettingsViewsHandlers();


    bloc.getProfileNameStream.first.then((String profileName){

      profileNameTextEditingController.text = profileName;
    });

    bloc.getProfileStatusStream.first.then((String profileStatus){

      statusTextEditingController.text = profileStatus;
    });



  }


  static ProfileSettingsBlocProvider of (BuildContext context) => (context.inheritFromWidgetOfExactType(ProfileSettingsBlocProvider) as ProfileSettingsBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}