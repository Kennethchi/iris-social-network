import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'menu_bloc.dart';
import 'menu_bloc_provider.dart';
import 'menu_views_widgets.dart';



class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MenuBloc _bloc = MenuBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;




    return Padding(
      padding: EdgeInsets.all(screenWidth * scaleFactor * 0.2),
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.5)
          ),

          child: ListView(

            children: <Widget>[

              AboutOptionWidget(),

              FeedBackOptionWidget(),

              ReportBugOptionWidget(),

              ShareAppLinkWidget(),

              InviteWidget(),

              UpdateAppWidget(),

              AppVersionWidget()
            ],
          ),

        ),
      ),
    );
  }
}








