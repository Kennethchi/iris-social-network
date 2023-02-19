import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/app/app_handlers.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'notifications_bloc.dart';
import 'notifications_bloc_provider.dart';
import 'notifications_view.dart';




class Notifications extends StatefulWidget {

  String currentUserId;

  Notifications({@required this.currentUserId});


  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  NotificationsBloc _bloc;

  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = NotificationsBloc(currentUserId: widget.currentUserId);
    _scrollController = ScrollController();
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    AppHandler.setHomeMainPage(mainPage: HomeMainPages.notifications_page);
  }


  @override
  Widget build(BuildContext context) {

    return NotificationsBlocProvider(
      bloc: _bloc,
      scrollController: _scrollController,
      child: Scaffold(
        body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("Notifications", style: TextStyle(
                color: Colors.black.withOpacity(0.6),

                fontSize: Theme.of(context).textTheme.title.fontSize,
                fontWeight: FontWeight.bold)
              ,),
            border: Border.all(style: BorderStyle.none),
          ),
          child: NotificationsView(),
        ),
      ),
    );
  }
}
