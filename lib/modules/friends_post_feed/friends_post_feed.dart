import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/app/app_handlers.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'friends_post_feed_bloc.dart';
import 'friends_post_feed_bloc_provider.dart';
import 'friends_post_feed_views.dart';
import 'friends_post_feed_handlers.dart';
import 'package:after_layout/after_layout.dart';



class FriendsPostFeed extends StatefulWidget {
  @override
  _FriendsPostFeedState createState() => _FriendsPostFeedState();
}

class _FriendsPostFeedState extends State<FriendsPostFeed> with AutomaticKeepAliveClientMixin, AfterLayoutMixin<FriendsPostFeed> {


  FriendsPostFeedBloc _bloc;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController();

    _bloc = FriendsPostFeedBloc();
  }

  @override
  bool get wantKeepAlive {
    return true;
  }


  @override
  void afterFirstLayout(BuildContext context) {

    _bloc.getFirebaseUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){

        SharedPreferences.getInstance().then((sharedPrefs)async{

          bool quitShowingInfoStoredValue = sharedPrefs.getBool(SharedPrefsKeys.show_friends_feed_info);

          if (quitShowingInfoStoredValue == null){
            bool quitShowingInfo = await FriendsPostFeedHandlers.showFriendsFeedInfo(context: context);;
            sharedPrefs.setBool(SharedPrefsKeys.show_friends_feed_info, quitShowingInfo);
          }

        });
      }

    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    AppHandler.setHomeMainPage(mainPage: HomeMainPages.friends_post_feed_page);
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _scrollController.dispose();
    _bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FriendsPostFeedBlocProvider(

      bloc: _bloc,
      scrollController: _scrollController,

      child: Scaffold(

        backgroundColor: Colors.transparent,

        body: CupertinoPageScaffold(

          backgroundColor: Colors.white,

          child: FriendsPostFeedView(),
        ),
      ),

    );
  }

}
