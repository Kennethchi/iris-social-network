import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/app/app_handlers.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/friend_model.dart';
import 'friends_bloc.dart';
import 'friends_bloc_provider.dart';
import 'friends_view.dart';
import 'friends_view_widgets.dart';




class Friends extends StatefulWidget {

  String currentUserId;

  Friends({@required this.currentUserId});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with AutomaticKeepAliveClientMixin{

  FriendsBloc _bloc;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = FriendsBloc(currentUserId: widget.currentUserId);
    _scrollController = ScrollController();
  }


  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    AppHandler.setHomeMainPage(mainPage: HomeMainPages.friends_page);
  }

  @override
  Widget build(BuildContext context) {
    return FriendsBlocProvider(
      bloc: _bloc,
      scrollController: _scrollController,
      child: Scaffold(
        body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("Friends",
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: Theme.of(context).textTheme.title.fontSize,
                fontWeight: FontWeight.bold),
            ),
            border: Border.all(style: BorderStyle.none),
            trailing: NumberOfFriendsWidget(),
          ),
          child: FriendsView(),
        ),
      ),
    );
  }
}
