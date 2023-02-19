import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat.dart';
import 'package:iris_social_network/modules/chat_room/chat_room.dart';
import 'package:iris_social_network/modules/profile/profile.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'notifications_bloc.dart';
import 'notifications_bloc_provider.dart';
import 'package:time_ago_provider/time_ago_provider.dart';


class NotificationFriendRequestWidget extends StatelessWidget {

  OptimisedNotificationModel optimisedNotificationModel;

  NotificationFriendRequestWidget({@required this.optimisedNotificationModel});

  @override
  Widget build(BuildContext context) {


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return InkWell(

      onTap: (){

        Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context)=> Profile(profileUserId: optimisedNotificationModel.from,)));
      },

      child: ListTile(
        title: RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[

                  TextSpan(
                      text: "@" + optimisedNotificationModel.userFromUserName,
                      style: TextStyle(fontWeight: FontWeight.bold, color: DefaultTextStyle.of(context).style.color)
                  ),

                  TextSpan(
                    text: "  SENT",
                    style: TextStyle(color: _themeData.primaryColor, fontWeight: FontWeight.bold),
                  ),

                  TextSpan(text: " you a FriendRequest")
                ]
            )
        ),
        subtitle: Text("Click! to go to User Profile", style: TextStyle(fontSize: Theme.of(context).textTheme.overline.fontSize, color: Colors.black.withOpacity(0.5)),),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Flexible(
              child: IconButton(
                onPressed: (){

                  NotificationsBlocProvider.of(context).handlers.showDeleteNotificationDialogOption(
                      pageContext: context,
                    optimisedNotificationModel: this.optimisedNotificationModel
                  );

                },
                  icon: Icon(Icons.more_vert)
              ),
            ),
            SizedBox(height: 5.0,),

            Text(TimeAgo.getTimeAgo(optimisedNotificationModel.t), style: TextStyle(fontSize: Theme.of(context).textTheme.overline.fontSize),),

          ],
        ),
        dense: true,
      ),
    );
  }
}





class NotificationFriendRequestAcceptedWidget extends StatelessWidget {

  OptimisedNotificationModel optimisedNotificationModel;

  NotificationFriendRequestAcceptedWidget({@required this.optimisedNotificationModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[

                TextSpan(

                    text: "@" + optimisedNotificationModel.userFromUserName,
                    style: TextStyle(fontWeight: FontWeight.bold, color: DefaultTextStyle.of(context).style.color)
                ),
                TextSpan(
                  text: "  ACCEPTED",
                  style: TextStyle(color: CupertinoColors.activeGreen, fontWeight: FontWeight.bold),
                ),

                TextSpan(text: " your FriendRequest")

              ]
          )
      ),

      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[

          Flexible(
            child: IconButton(
                onPressed: (){

                  NotificationsBlocProvider.of(context).handlers.showDeleteNotificationDialogOption(
                      pageContext: context,
                    optimisedNotificationModel: this.optimisedNotificationModel
                  );
                },
                icon: Icon(Icons.more_vert)
            ),
          ),
          SizedBox(height: 5.0,),

          Text(TimeAgo.getTimeAgo(optimisedNotificationModel.t), style: TextStyle(fontSize: Theme.of(context).textTheme.overline.fontSize),)

        ],
      ),
      dense: true,
    );
  }
}