import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/app/app_handlers.dart';
import 'package:iris_social_network/modules/post_feed/post_feed_handlers.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_feed_bloc.dart';
import 'post_feed_bloc_provider.dart';
import 'post_feed_views.dart';
import 'package:after_layout/after_layout.dart';



class PostFeed extends StatefulWidget {
  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> with AutomaticKeepAliveClientMixin, AfterLayoutMixin<PostFeed>{


  PostFeedBloc _bloc;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController();
    _bloc = PostFeedBloc();
  }

  @override
  bool get wantKeepAlive {
    return true;
  }


  @override
  void afterFirstLayout(BuildContext context) {


    FirebaseAuth.instance.currentUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){

        SharedPreferences.getInstance().then((sharedPrefs)async{
          bool quitShowingInfoStoredValue = sharedPrefs.getBool(SharedPrefsKeys.show_public_feed_info);

          if (quitShowingInfoStoredValue == null){
            bool quitShowingInfo = await PostFeedHandlers.showPostFeedInfo(context: context);;
            sharedPrefs.setBool(SharedPrefsKeys.show_public_feed_info, quitShowingInfo);
          }
        });

      }

    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    AppHandler.setHomeMainPage(mainPage: HomeMainPages.post_feed_page);
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
    return PostFeedBlocProvider(
      bloc: _bloc,
      scrollController: _scrollController,

      child: Scaffold(

        backgroundColor: Colors.transparent,

        body: CupertinoPageScaffold(

          backgroundColor: Colors.white,

          child: PostFeedView(),
        ),
      ),

    );
  }

}
