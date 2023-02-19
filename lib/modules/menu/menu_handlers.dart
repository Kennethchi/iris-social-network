import 'package:animator/animator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart';
import 'package:iris_social_network/services/app_services/remote_config_services.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'menu_bloc.dart';
import 'menu_bloc_provider.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/services/app_services/dynamic_links_services.dart' as dynamic_links_services;
import 'package:url_launcher/url_launcher.dart' as url_launcher;



class MenuHandlers{


  Future<void> getAppVersion({@required MenuBloc menuBloc})async{

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    menuBloc.addAppVersionToStream(packageInfo.version + "." + packageInfo.buildNumber);
  }


  Future<void> showAboutModalDialog({@required BuildContext menuContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(menuContext);
    MenuBloc _bloc = MenuBlocProvider.of(menuContext).bloc;
    double screenWidth = MediaQuery.of(menuContext).size.width;
    double screenHeight = MediaQuery.of(menuContext).size.height;
    double scaleFactor = 0.125;

    await showCupertinoModalPopup(
        context: menuContext,
        builder: (BuildContext context){

          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(seconds: 1),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoActionSheet(

                      title: Center(
                          //child: Icon(Icons.info_outline)
                        child: Text("About", style: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
                      ),

                      message: Text(
                        "Iris is a social platform where you come an express your passion.",
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.subhead.fontSize
                        ),
                      )

                  ),
                );
              },
            ),
          );
        }
    );

  }






  Future<void> showSendFeedBackModalDialog({@required BuildContext menuContext})async{

    MenuBlocProvider _provider = MenuBlocProvider.of(menuContext);
    CupertinoThemeData _themeData = CupertinoTheme.of(menuContext);
    MenuBloc _bloc = MenuBlocProvider.of(menuContext).bloc;
    double screenWidth = MediaQuery.of(menuContext).size.width;
    double screenHeight = MediaQuery.of(menuContext).size.height;
    double scaleFactor = 0.125;


    await showCupertinoModalPopup(
        context: menuContext,
        builder: (BuildContext context){

          return Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
              child: SafeArea(
                child: Column(
                  children: <Widget>[

                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25)),
                        elevation: 20.0,
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Text("Send Feedback", style: TextStyle(
                                fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
                                color: _themeData.primaryColor
                              ),),
                              SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                              TextField(
                                controller: MenuBlocProvider.of(menuContext).feedBackTextEditingController,
                                maxLines: null,
                                maxLength: 300,
                                cursorColor: _themeData.primaryColor,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                                    labelStyle: TextStyle(color: Colors.black26),
                                    labelText: "FeedBack",
                                    suffixIcon: StreamBuilder<String>(
                                      stream: _bloc.getFeedBackTextStream,
                                      builder: (context, snapshot) {
                                        return CupertinoButton(
                                          onPressed: snapshot.hasData && snapshot.hasError == false?  (){

                                            _provider.feedBackTextEditingController.clear();
                                            _bloc.addFeedBackTextToStream(feedBackText: null);

                                            _bloc.sendFeedBack(feedback: snapshot.data);

                                            Navigator.of(context).pop();

                                            BasicUI.showSnackBar(
                                                context: menuContext,
                                                message: "FeedBack Sent", textColor: _themeData.primaryColor,
                                            );
                                          }: null,
                                          child: Icon(FontAwesomeIcons.solidPaperPlane,),
                                        );
                                      }
                                    )
                                ),
                                onChanged: (String feedBackText){

                                  _bloc.addFeedBackTextToStream(feedBackText: feedBackText);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

    );

  }








  Future<void> showSendBugReportModalDialog({@required BuildContext menuContext})async{

    MenuBlocProvider _provider = MenuBlocProvider.of(menuContext);
    CupertinoThemeData _themeData = CupertinoTheme.of(menuContext);
    MenuBloc _bloc = MenuBlocProvider.of(menuContext).bloc;
    double screenWidth = MediaQuery.of(menuContext).size.width;
    double screenHeight = MediaQuery.of(menuContext).size.height;
    double scaleFactor = 0.125;


    await showCupertinoModalPopup(
        context: menuContext,
        builder: (BuildContext context){

          return Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
              child: SafeArea(
                child: Column(
                  children: <Widget>[

                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: Card(
                        elevation: 20.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25)),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Text("Report Bug", style: TextStyle(
                                  fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
                                  color: _themeData.primaryColor
                              ),),
                              SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                              TextField(
                                controller: MenuBlocProvider.of(menuContext).reportBugTextEditingController,
                                maxLines: null,
                                maxLength: 300,
                                cursorColor: _themeData.primaryColor,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                                    labelText: "Report Bug",
                                    labelStyle: TextStyle(color: Colors.black26),
                                    suffixIcon: StreamBuilder<String>(
                                        stream: _bloc.getReportBugTextStream,
                                        builder: (context, snapshot) {
                                          return CupertinoButton(
                                            onPressed: snapshot.hasData && snapshot.hasError == false?  (){

                                              _provider.reportBugTextEditingController.clear();
                                              _bloc.addReportBugTextToStream(reportBugText: null);

                                              _bloc.sendBugReport(bugReport: snapshot.data);

                                              Navigator.of(context).pop();

                                              BasicUI.showSnackBar(
                                                context: menuContext,
                                                message: "Bug Report Sent", textColor: _themeData.primaryColor,
                                              );

                                            }: null,
                                            child: Icon(FontAwesomeIcons.solidPaperPlane,),
                                          );
                                        }
                                    )
                                ),
                                onChanged: (String reportBugText){

                                  _bloc.addReportBugTextToStream(reportBugText: reportBugText);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

    );

  }






  Future<void> showInviteModalDialog({@required BuildContext menuContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(menuContext);
    MenuBloc _bloc = MenuBlocProvider.of(menuContext).bloc;
    double screenWidth = MediaQuery.of(menuContext).size.width;
    double screenHeight = MediaQuery.of(menuContext).size.height;
    double scaleFactor = 0.125;

    await showCupertinoModalPopup(
        context: menuContext,
        builder: (BuildContext context){

          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(seconds: 1),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoAlertDialog(

                      title: Center(
                        //child: Icon(Icons.info_outline)
                        child: Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.25),
                          child: Text("Invite Friends",
                            style: TextStyle(
                                color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                            ),),
                        ),
                      ),

                      content: Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.25),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Invite your friends to Iris to come an feel the moment and have fun.",
                              style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.subtitle.fontSize
                              ),
                            ),
                            SizedBox(height: screenHeight * scaleFactor * 0.25,),
                            Text(
                              "Your Friends will be directed to your Profile immediately when the SignUp.",
                              style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.subtitle.fontSize
                              ),
                            ),
                            SizedBox(height: screenHeight * scaleFactor * 0.25,),

                            RichText(
                              textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Theme.of(context).textTheme.subtitle.fontSize,
                                  ),
                              children: <TextSpan>[

                                TextSpan(
                                  text: "For each Friend you invite and creates an Account on Iris, you and your friend will receive"
                                ),
                                TextSpan(
                                  text: "  ${RewardsTypePoints.invite_new_user_reward_point}  ",
                                  style: TextStyle(
                                    color: _themeData.primaryColor,
                                    fontSize: Theme.of(context).textTheme.subhead.fontSize
                                  )
                                ),
                                TextSpan(
                                  text: "Reward Points each.",
                                )

                              ]
                            ))

                          ],
                        ),
                      ),

                    actions: <Widget>[

                      CupertinoDialogAction(
                        child: Text("Cancel",
                          style: TextStyle(
                            color: _themeData.primaryColor
                          ),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),

                      CupertinoDialogAction(
                          child: Text("Invite Now",
                            style: TextStyle(
                                color: _themeData.primaryColor
                            ),
                          ),
                        onPressed: (){

                            Navigator.of(context).pop();

                            AppBlocProvider.of(context).bloc.getFirebaseUser().then((FirebaseUser firebaseUser)async{

                              if (firebaseUser != null){
                                Share.share(
                                    await dynamic_links_services.getDynamicLinkWithUserInviteData(
                                        userId: firebaseUser.uid,
                                      earnPoints: RewardsTypePoints.invite_new_user_reward_point
                                    )
                                );
                              }
                            });

                        },
                      )

                    ],

                  ),
                );
              },
            ),
          );
        }
    );

  }










  Future<void> showDonateModalDialog({@required BuildContext menuContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(menuContext);
    MenuBloc _bloc = MenuBlocProvider.of(menuContext).bloc;
    double screenWidth = MediaQuery.of(menuContext).size.width;
    double screenHeight = MediaQuery.of(menuContext).size.height;
    double scaleFactor = 0.125;

    await showCupertinoModalPopup(
        context: menuContext,
        builder: (BuildContext context){

          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(seconds: 1),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoAlertDialog(

                    title: Center(
                      //child: Icon(Icons.info_outline)
                      child: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.25),
                        child: Text("Donate",
                          style: TextStyle(
                              color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                          ),),
                      ),
                    ),

                    content: Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.25),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "If you love this App, donate to help support the developement and the maintainance of the platform.",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * scaleFactor * 0.25,),
                          Text("Any Gesture of yours can help grow this platform.",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),

                    actions: <Widget>[

                      CupertinoDialogAction(
                        child: Text("Cancel",
                          style: TextStyle(
                              color: _themeData.primaryColor
                          ),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),

                      CupertinoDialogAction(
                        child: Text("Donate",
                          style: TextStyle(
                              color: _themeData.primaryColor
                          ),
                        ),
                        onPressed: ()async{

                          Navigator.of(context).pop();

                          RemoteConfig remoteConfig = RemoteConfig();

                          await remoteConfig.fetch(expiration: Duration.zero);
                          await remoteConfig.activateFetched();

                          String donation_link = remoteConfig.getString(RemoteConfigKeys.donation_link);

                          if (donation_link != null){
                            url_launcher.launch(donation_link);
                          }
                        },
                      )

                    ],

                  ),
                );
              },
            ),
          );
        }
    );

  }




}