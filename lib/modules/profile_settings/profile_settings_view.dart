import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/modules/profile_settings/profile_settings_bloc.dart';
import 'package:iris_social_network/modules/profile_settings/profile_settings_bloc_provider.dart';
import 'profile_settings_view_widgets.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';



class ProfileSettingsView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build



    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return Padding(
      padding: EdgeInsets.all(screenWidth * scaleFactor * 0.2),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.5)
        ),
        child: SingleChildScrollView(
          child: Column(

            children: <Widget>[

              SizedBox(height: screenHeight * scaleFactor * 0.33,),
              ProfileAvatarWidget(),
              SizedBox(height: screenHeight * scaleFactor * 0.33,),

              ProfileAudioWidget(),

              ProfileNameWidget(),

              ProfileUsernameWidget(),

              ProfileStatusWidget(),

              ProfileGenderWidget(),


              SizedBox(height: screenHeight * scaleFactor * 0.25,),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(child: Divider(color: Colors.white,)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * scaleFactor),
                    child: Text("Other Settings", style: TextStyle(color: Colors.white),),
                  ),
                  Flexible(child: Divider(color: Colors.white,)),

                ],
              ),

              ReceiveFriendRequestOptionWidget(),

              ShowPublicPostsOptionWidget(),

              AppThemeColorWidget(),

              //InterestsWidget(),

              SizedBox(height: screenHeight * scaleFactor * 0.25,)

            ],
          ),
        ),
      ),
    );
  }

}






