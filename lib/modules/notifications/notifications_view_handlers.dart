import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'notifications_bloc.dart';
import 'notifications_bloc_provider.dart';
import 'notifications_view_widgets.dart';


class NotificatiosViewHandlers{



  Widget getNotificationTypeWidget({@required BuildContext notificationContext, @required OptimisedNotificationModel optimisedNotificationModel}){

    NotificationsBloc _bloc = NotificationsBlocProvider.of(notificationContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(notificationContext);
    double screenwidth = MediaQuery.of(notificationContext).size.width;
    double screenHeight = MediaQuery.of(notificationContext).size.height;
    double scaleFactor = 0.125;



    switch(optimisedNotificationModel.n_type){
      case NotificationType.msg:
        return Text("Message");
      case NotificationType.friend_req:
        return NotificationFriendRequestWidget(optimisedNotificationModel: optimisedNotificationModel);
      case NotificationType.friend_req_accepted:
        return NotificationFriendRequestAcceptedWidget(optimisedNotificationModel: optimisedNotificationModel);
      default:
        return Container();
    }

  }








  Future<void> showDeleteNotificationDialogOption({@required BuildContext pageContext, @required OptimisedNotificationModel optimisedNotificationModel})async{

    NotificationsBlocProvider _provider = NotificationsBlocProvider.of(pageContext);
    NotificationsBloc _bloc = NotificationsBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;


    await showDialog(
        context: pageContext,
        builder: (BuildContext context){


          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              duration: Duration.zero,

              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoAlertDialog(

                    title: Center(
                      child: Text("Do you want to Delete Notification?", style: TextStyle(
                          fontSize: Theme.of(context).textTheme.subhead.fontSize
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    actions: <Widget>[


                      CupertinoDialogAction(
                        child: Text("YES",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: ()async{

                          _bloc.deleteNotification(
                              userId: _bloc.getCurrentUserId,
                              notificationId: optimisedNotificationModel.id
                          );

                          _bloc.getNotificationsList.remove(optimisedNotificationModel);
                          _bloc.addNotificationsListToStream((_bloc.getNotificationsList));

                          Navigator.of(context).pop();

                        },
                      ),


                      CupertinoDialogAction(
                        child: Text("NO",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: (){

                          Navigator.of(context).pop();
                        },
                      ),

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