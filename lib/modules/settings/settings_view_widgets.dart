import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'settings_bloc.dart';
import 'settings_bloc_provider.dart';


class SignOutOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SettingsBloc _bloc = SettingsBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
      stream: _bloc.getIsPhoneAuthStream,
      builder: (context, snapshot) {

        if (snapshot.hasData && snapshot.data){

          return Container();
        }
        else{

          return GestureDetector(

            onTap: (){

              // Option to logout from App
              SettingsBlocProvider.of(context).handlers.signOutPopUpModalMenu(settingsCcontext: context);

            },

            child: ListTile(
              leading: Icon(Icons.exit_to_app, color: RGBColors.red,),
              title: Text("Log Out", style: TextStyle(color: _themeData.barBackgroundColor),),
            ),
          );
        }


      }
    );
  }
}



