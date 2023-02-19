import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';

import 'notifications_bloc.dart';
import 'notifications_view_handlers.dart';

class NotificationsBlocProvider extends InheritedWidget{

  final NotificationsBloc bloc;
  final Key key;
  final Widget child;

  ScrollController scrollController;

  NotificatiosViewHandlers handlers;

  NotificationsBlocProvider({@required this.bloc, @required this.scrollController, this.key, this.child}): super(key: key, child: child){

    handlers = NotificatiosViewHandlers();

    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 0.0;


      if (maxScroll == currentScroll){


        if ((bloc.getHasLoadedNotifications == false || bloc.getHasLoadedNotifications == null)
            && bloc.getHasMoreNotifications
            && bloc.getNotificationsList.length < AppFeaturesMaxLimits.MAX_NUMBER_OF_NOTIFICATIONS_TO_LOAD){

          bloc.setHasLoadedNotifications = true;

          bloc.loadMoreNotifications(
              currentUserId: bloc.getCurrentUserId,
              queryLimit: bloc.getNotificationsQueryLimit,
              endAtKey: bloc.getQueryEndAtKey,
              notificationType: bloc.getNotificationType).then((_){

            bloc.setHasLoadedNotifications = false;
          });

        }
      }

    });

  }


  static NotificationsBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(NotificationsBlocProvider) as NotificationsBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;


}