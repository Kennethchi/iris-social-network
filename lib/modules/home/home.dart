import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_handlers.dart';
import 'package:iris_social_network/modules/chat_room/chat_room.dart';
import 'package:iris_social_network/modules/friends/friends.dart';
import 'package:iris_social_network/modules/friends_post_feed/friends_post_feed.dart';
import 'package:iris_social_network/modules/notifications/notifications.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_bloc.dart';
import 'home_bloc_provider.dart';
import 'home_view_widgets.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:firebase_database/firebase_database.dart';
import 'home_view_handlers.dart';
import 'package:iris_social_network/modules/post_feed/post_feed.dart';
import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/app/app_bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:iris_social_network/modules/post_room/post_room.dart';
import 'package:share/share.dart';
import 'package:iris_social_network/services/app_services/dynamic_links_services.dart' as dynamic_links_services;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:package_info/package_info.dart';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;



class Home extends StatefulWidget{

  static const String routeName = AppRoutes.home_screen;

  AppBloc appBloc;

  Home({@required this.appBloc}){

    // Initialise all values in the app
    appBloc.getFirebaseUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){
        appBloc.setCurrentUserId = firebaseUser.uid;
        appBloc.getAllCurrentUserData(currentUserId: firebaseUser.uid).then((UserModel userModel){

          if (userModel != null){
            appBloc.addBackgroundImageToStream(userModel.profileThumb);
            appBloc.setCurrentUserData = userModel;
          }
        });
      }
    });


  }

  @override
  _HomeState createState() => new _HomeState();

}



class _HomeState extends State<Home> with TickerProviderStateMixin, WidgetsBindingObserver, AfterLayoutMixin<Home>{


  HomeBloc _bloc;
  AnimationController _animationController;
  PageController _pageController;
  ValueNotifier<int> _valueNotifier;


  OverlayState _overlayAvatarState;

  bool dynamicLinkIsLoaded = false;

  bool uiViewHelpIsShown = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _bloc = HomeBloc();

    _bloc.getFirebaseUser().then((FirebaseUser firebaseUser)async{
      if (firebaseUser != null){
        UserModel currentUserModel = await widget.appBloc.getAllCurrentUserData(currentUserId: firebaseUser.uid);
        if (currentUserModel != null){
          _bloc.addShowPublicPostFeedToStream(currentUserModel.showPublicPosts);
        }
      }
    });




    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _pageController = PageController();
    _valueNotifier = ValueNotifier(_pageController.initialPage);

    _valueNotifier.addListener((){});



    /*
    // take care of showing indicator
    _bloc.addShowPageIndicatorToStream(true);
    Timer(Duration(seconds: 5), (){
      _bloc.addShowPageIndicatorToStream(false);
    });
    */



    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      if (user == null){
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.splash_screen, (Route<dynamic> route) => false);
      }
      else{
        SharedPreferences.getInstance().then((SharedPreferences prefs){

          // if account_setup_complete is null which is assigned in sms verification view,
          // that means the user is not a fresh new user
          // checking for account_setup_complete not equal null implies user is a new user and its value not being true implies account setup was not complete
          // This will help solve the problem of overwitting the user data with same phone number when user uninstalls the app and installs it back
          // The user when reinstalling the app will have to skip the account setup process if he did not sign out

          print(prefs.getBool(app_constants.SharedPrefsKeys.account_setup_complete + user.uid));

          if (prefs.getBool(app_constants.SharedPrefsKeys.account_setup_complete + user.uid) == null
              || prefs.getBool(app_constants.SharedPrefsKeys.account_setup_complete + user.uid) == false)
          {

            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.account_setup_screen, (Route<dynamic> route) => false);
          }
          else{

            // WE ARE IN THE HOME PAGE

            _pageController.position.addListener((){
              _bloc.addPageViewIndexToStream(_pageController.page.round());
              _valueNotifier.value = _pageController.page.round();
            });


            AppHandler.getHomeMainPage().then((String homeMainPage){
              if (homeMainPage == HomeMainPages.post_feed_page){
                _pageController.jumpToPage(0);
              }
              else if (homeMainPage == HomeMainPages.notifications_page){
                _pageController.jumpToPage(1);
              }
              else if (homeMainPage == HomeMainPages.private_chat_page){
                _pageController.jumpToPage(2);
              }
              else if (homeMainPage == HomeMainPages.friends_page){
                _pageController.jumpToPage(3);
              }
              else if (homeMainPage == HomeMainPages.friends_post_feed_page){
                _pageController.jumpToPage(4);
              }
              else{
                _pageController.jumpToPage(2);
              }
            });


          }
        });
      }
    });

    /*
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {

      },
      onBackgroundMessage: (Map<String, dynamic> message) async {

      },
      onLaunch: (Map<String, dynamic> message) async {

      },
      onResume: (Map<String, dynamic> message) async {

      },
    );
    */

  }



  @override
  void dispose() {
    // TODO: implement dispose

    //_overlayAvatarState?.dispose();

    _bloc.dispose();
    _animationController?.dispose();
    _pageController?.dispose();
    _valueNotifier.removeListener((){});

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    switch(state){
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:

        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }

  }



  @override
  void didChangeDependencies(){
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();


    // Page controller UNEXPECTEDLY stops listening when you move to another page
    // The below code adds back the listener

    Timer(Duration(seconds: 1), (){

      _pageController.position.addListener((){
        _bloc.addPageViewIndexToStream(_pageController.page.round());
        _valueNotifier.value = _pageController.page.round();
      });
    });



    /*
    _overlayAvatarState = Overlay.of(context);
    Timer(Duration(seconds: 2), (){

      HomeViewHandlers.showAvatar(bloc: _bloc, overlayAvatarState: _overlayAvatarState);
    });
    */


    // Pop Up dynamic link after



  }




  Future<void> initDynamicLinks() async {

    AppBlocProvider.of(context).appDynamicLinksHandlers.launchInviteDynamicLinkHandler(pageContext: context,);

    AppBlocProvider.of(context).appDynamicLinksHandlers.launchSharedPostDynamicLink(pageContext: context);


    /*
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      Share.share(deepLink.path);
      //Navigator.pushNamed(context, deepLink.path);
    }
    */



    /*
     // This timer may help in ios
    Timer(Duration(seconds: 1), (){

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {

            if (deepLink != null) {
              //Share.share(deepLink.path);
              //Navigator.pushNamed(context, deepLink.path);
            }
          },
          onError: (OnLinkErrorException e) async {
            print('onLinkError');
            print(e.message);

            Share.share("error");
          }
      );

    });
    */

  }


  @override
  void afterFirstLayout(BuildContext context) {


    _bloc.getFirebaseUser().then((FirebaseUser firebaseUser){
      if (firebaseUser != null){


        AppBloc appBloc = AppBlocProvider.of(context).bloc;
        appBloc.getNewDayTimestampInMilliseconds().then((int newDayTimestamp){
          if (newDayTimestamp == null){

            appBloc.setNewDayTimestampInMilliseconds();
            appBloc.increaseUserPoints(
                userId: firebaseUser.uid,
                points: achievements_services.RewardsTypePoints.opening_app_each_day_reward_point
            ).then((_){
              appBloc.setNewDayTimestampInMilliseconds();
            });

          }
          else{
            bool hasNewDayElapsed = appBloc.getHasNewDayElapsed(lastTimestampInMilliseconds: newDayTimestamp);
            if (hasNewDayElapsed){
              appBloc.increaseUserPoints(
                  userId: firebaseUser.uid,
                  points: achievements_services.RewardsTypePoints.opening_app_each_day_reward_point
              ).then((_){
                appBloc.setNewDayTimestampInMilliseconds();
              });
            }
          };
        });




        AppHandler.getIfAppHasNewUpdateVersion().then((bool hasNewUpdate)async{

          if (hasNewUpdate){

            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            bool shouldShowUpdateAppDialogStoredValue = sharedPreferences.getBool(app_constants.SharedPrefsKeys.show_update_app_dialog);

            if (shouldShowUpdateAppDialogStoredValue  == null){

              bool shouldUpdateApp = await HomeViewHandlers.showUpdateAppDialog(context: context);

              if (shouldUpdateApp != null){
                sharedPreferences.setBool(app_constants.SharedPrefsKeys.show_update_app_dialog, shouldUpdateApp);
              }

              if (shouldUpdateApp && (await url_launcher.canLaunch(dynamic_links_services.app_package_google_playstore_link))){
                url_launcher.launch(dynamic_links_services.app_package_google_playstore_link);
              };
            }

          }


        });


        initDynamicLinks();

        Timer(Duration(seconds: 1), (){
          SharedPreferences.getInstance().then((sharedPrefs)async{
            bool quitShowingGuideStoredValue = sharedPrefs.getBool(app_constants.SharedPrefsKeys.show_home_screen_ui_guide);
            if (quitShowingGuideStoredValue == null){
              bool quitShowingGuide = await HomeViewHandlers.showHelpDialogAndGetShouldPopAgain(context: context);
              sharedPrefs.setBool(app_constants.SharedPrefsKeys.show_home_screen_ui_guide, quitShowingGuide);
            }
          });
        });

      }

    });
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return HomeBlocProvider(
      bloc: _bloc,
      animationController: _animationController,
      child: Scaffold(
        body: GestureDetector(
          onLongPress: (){
            HomeViewHandlers.showModelPopupMenu(homeContext: context, bloc: _bloc);
          },
          child: CupertinoPageScaffold(

            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[




                PageView(

                  controller: _pageController,

                  children: <Widget>[


                    GetPostFeedWidget(),

                    Notifications(currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,),

                    ChatRoom(),

                    Friends(currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,),

                    FriendsPostFeed()
                  ],

                ),

                StreamBuilder<bool>(
                    stream: _bloc.getShowPageIndicatorStream,
                    builder: (context, snapshot) {

                      if (snapshot.data == false){
                        return Container();
                      }

                      return Container(
                        child: StreamBuilder<int>(
                            stream: _bloc.getPageViewIndexStream,
                            builder: (context, snapshot) {

                              return PageViewIndicator(

                                currentPage: _valueNotifier.value,
                                pageIndexNotifier: _valueNotifier,
                                length: 5,
                                normalBuilder: (animationController, index) =>
                                    _getNormalPageIndicatorWidget(
                                        context: context,
                                        page: _valueNotifier.value
                                    ),
                                highlightedBuilder: (animationController, index) => ScaleTransition(
                                    scale: CurvedAnimation(
                                      parent: animationController,
                                      curve: Curves.ease,
                                    ),
                                    child: _getHighlightedPageIndicatorWidget(
                                        context: context,
                                        page: _valueNotifier.value
                                    )
                                ),
                              );
                            }
                        ),
                      );
                    }
                ),


                StreamBuilder<bool>(
                  stream: AppBlocProvider.of(context).bloc.getIsChristmasPeriodStream,
                  builder: (context, snapshot) {

                    if (snapshot.hasData && snapshot.data){

                      return AnimatedBackground(
                        behaviour: RandomParticleBehaviour(
                            options: ParticleOptions(
                                particleCount: 10,
                                baseColor: CupertinoTheme.of(context).primaryColor
                            )
                        ),
                        vsync: this,
                        child: Container(),
                      );
                    }
                    else{
                      return Container();
                    }

                  }
                ),

              ],
            ),


          )
        ),


        /*
        bottomNavigationBar: CurvedNavigationBar(
          height: 60.0,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          color: CupertinoTheme.of(context).primaryColor,
          animationDuration: Duration(milliseconds: 300),
          items: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
                child: Icon(Icons.add, color: Colors.white,)
            ),
            Container(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.list, color: Colors.white,)
            ),
            Container(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.compare_arrows, color: Colors.white,)
            ),
          ],
          onTap: (index) {
            //Handle button tap
          },
        ),
        */

      )


    );
  }





  Widget _getHighlightedPageIndicatorWidget({@required BuildContext context, @required int page}){

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    Widget parent = Container(
      width: screenWidth * scaleFactor * 1.2,
      height: screenWidth * scaleFactor * 1.2,
      decoration: BoxDecoration(
        color: _themeData.primaryColor.withOpacity(0.85),
        shape: BoxShape.circle,
      ),
      child: Icon( _getPageIndicatorIconData(page: page), color: Colors.white,) ,
    );


    return parent;
  }



  Widget _getNormalPageIndicatorWidget({@required BuildContext context, @required int page}){

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    Widget parent = Container(
      width: screenWidth * scaleFactor * 0.25,
      height: screenWidth * scaleFactor * 0.25,
      decoration: BoxDecoration(
        color: _themeData.primaryColor.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      //child: Icon( _getPageIndicatorIconData(page: page), color: Colors.white,),
    );

    return parent;
  }


  IconData _getPageIndicatorIconData({@required int page}){

    if (page == 0){
      return Icons.view_module;
    }
    else if(page == 1){
      return Icons.notifications;
    }
    else if (page == 2){
      return FontAwesomeIcons.solidComment;
    }
    else if (page == 3){
      return FontAwesomeIcons.userFriends;
    }
    else if (page == 4){
      return Icons.view_module;
    }
    else{
      return null;
    }
  }

}






