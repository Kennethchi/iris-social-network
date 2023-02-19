import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'menu_bloc.dart';
import 'menu_bloc_provider.dart';
import 'package:share/share.dart';
import 'package:iris_social_network/services/app_services/dynamic_links_services.dart' as dynamic_links_services;
import 'package:url_launcher/url_launcher.dart' as url_launcher;



class AboutOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MenuBloc _bloc = MenuBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return GestureDetector(

      onTap: (){

        MenuBlocProvider.of(context).handlers.showAboutModalDialog(menuContext: context);
      },

      child: ListTile(
        leading: Icon(Icons.book, color: _themeData.barBackgroundColor,),
        title: Text("About", style: TextStyle(color: _themeData.barBackgroundColor),),
      ),
    );

  }
}






class FeedBackOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MenuBloc _bloc = MenuBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return GestureDetector(

      onTap: (){

        MenuBlocProvider.of(context).handlers.showSendFeedBackModalDialog(menuContext: context);
      },

      child: ListTile(
        leading: Icon(Icons.feedback, color: _themeData.barBackgroundColor,),
        title: Text("Feedback", style: TextStyle(color: _themeData.barBackgroundColor),),
      ),
    );
  }
}







class ReportBugOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MenuBloc _bloc = MenuBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return GestureDetector(

      onTap: (){

        MenuBlocProvider.of(context).handlers.showSendBugReportModalDialog(menuContext: context);
      },

      child: ListTile(
        leading: Icon(FontAwesomeIcons.bug, color: _themeData.barBackgroundColor,),
        title: Text("Report a Bug (Error)", style: TextStyle(color: _themeData.barBackgroundColor),),
      ),
    );
  }
}








class ShareAppLinkWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MenuBloc _bloc = MenuBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return GestureDetector(

      onTap: (){

        Share.share(dynamic_links_services.app_dynamic_short_link);
      },

      child: ListTile(
        leading: Icon(FontAwesomeIcons.shareAlt, color: _themeData.barBackgroundColor,),
        title: Text("Share App", style: TextStyle(color: _themeData.barBackgroundColor),),
      ),
    );
  }
}





class InviteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MenuBloc _bloc = MenuBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return GestureDetector(

      onTap: (){

        MenuBlocProvider.of(context).handlers.showInviteModalDialog(menuContext: context);
      },

      child: ListTile(
        leading: Icon(FontAwesomeIcons.userPlus, color: _themeData.barBackgroundColor,),
        title: Text("Invite Friends", style: TextStyle(color: _themeData.barBackgroundColor),),
      ),
    );
  }
}




class DonationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MenuBloc _bloc = MenuBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return GestureDetector(

      onTap: (){

        MenuBlocProvider.of(context).handlers.showDonateModalDialog(menuContext: context);
      },

      child: ListTile(
        leading: Icon(FontAwesomeIcons.dollarSign, color: _themeData.barBackgroundColor,),
        title: Text("Donate", style: TextStyle(color: _themeData.barBackgroundColor),),
      ),
    );
  }
}







class UpdateAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MenuBloc _bloc = MenuBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
      stream: _bloc.getAppHasNewVersionUpdateStream,
      builder: (context, snapshot) {

        if (snapshot.hasData && snapshot.data){

          return GestureDetector(

            onTap: (){

              url_launcher.launch(dynamic_links_services.app_package_google_playstore_link);
            },

            child: ListTile(

              leading: Animator(
                  tween: Tween<double>(begin: 0.33, end: 1.0),
                  cycles: 1000000000,
                  //repeats: 10000000,
                  curve: Curves.linear,
                  duration: Duration(milliseconds: 700),
                  builder: (anim){
                    return Transform.scale(
                        scale: anim.value,
                        child: Icon(Icons.new_releases, color: RGBColors.fuchsia, size: 40.0,)
                    );
                  }
              ),
              title: Text("New Update Available", style: TextStyle(color: _themeData.barBackgroundColor),),
            ),
          );

        }
        else{

          return Container();
        }


      }
    );
  }
}







class AppVersionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    MenuBloc _bloc = MenuBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;


    return StreamBuilder<String>(
        stream: _bloc.getAppVersionStream,
        builder: (context, snapshot) {

          if (snapshot.hasData){
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * scaleFactor * 0.25),
                child: Text("App Version: " + snapshot.data,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.subhead.fontSize
                  ),
                ),
              ),
            );
          }
          else{
            return Container();
          }
        }
    );
  }
}



