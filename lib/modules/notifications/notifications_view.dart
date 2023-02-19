import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'notifications_bloc.dart';
import 'notifications_bloc_provider.dart';
import 'notifications_view_widgets.dart';







class NotificationsView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    NotificationsBloc _bloc = NotificationsBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.2),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.5)
          ),
          child: Column(
            children: <Widget>[


              Flexible(
                flex: 100,

                child: CustomScrollView(

                  controller: NotificationsBlocProvider.of(context).scrollController,

                  slivers: <Widget>[

                    NotificationsListWidget(),

                    LoadingNotificationsIndicatorWidget()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }



}




class NotificationsListWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    NotificationsBloc _bloc = NotificationsBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);


    return StreamBuilder<List<OptimisedNotificationModel>>(
      stream: _bloc.getNotificationsListStream,
      builder: (BuildContext context, AsyncSnapshot<List<OptimisedNotificationModel>> snapshot){


        switch(snapshot.connectionState){
          case ConnectionState.none:

            return SliverList(delegate: SliverChildListDelegate(
                <Widget>[

                  Container()
                ]
            ));

            return Container();
          case ConnectionState.waiting:

            return SliverList(delegate: SliverChildListDelegate(
                <Widget>[
                  SpinKitChasingDots(color: _themeData.primaryColor,)
                ]
            ));

          case ConnectionState.active: case ConnectionState.done:

          if (snapshot.hasData && snapshot.data.length > 0){

            return SliverList(delegate: SliverChildListDelegate(
              snapshot.data.map((OptimisedNotificationModel optimisedNotificationModel){

                int index = snapshot.data.indexOf(optimisedNotificationModel);

                return NotificationViewModelHolder(optimisedNotificationModel: snapshot.data[index]);
              }).toList(),
            ));

          }
          else{

            return SliverList(delegate: SliverChildListDelegate(
                <Widget>[

                  Container()
                ]
            ));


          }


        }
      },
    );

  }
}







class NotificationViewModelHolder extends StatelessWidget{

  OptimisedNotificationModel optimisedNotificationModel;



  NotificationViewModelHolder({@required this.optimisedNotificationModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    NotificationsBlocProvider _provider = NotificationsBlocProvider.of(context);
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    NotificationsBloc _bloc = NotificationsBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      child: _provider.handlers.getNotificationTypeWidget(notificationContext: context, optimisedNotificationModel: this.optimisedNotificationModel),
    );
  }
}








class LoadingNotificationsIndicatorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    NotificationsBloc _bloc = NotificationsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return SliverList(
      delegate: SliverChildListDelegate(
          <Widget>[


            Container(
                child: StreamBuilder(
                  stream: _bloc.getHasMoreNotificationsStream,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot){


                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                        return Container();
                      case ConnectionState.waiting:
                        return SpinKitChasingDots(color: _themeData.primaryColor,);
                      case ConnectionState.active: case ConnectionState.done:

                      if (snapshot.hasData && snapshot.data){
                        return SpinKitChasingDots(color: _themeData.primaryColor);
                      }
                      else{

                        //return Container();

                        return Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * scaleFactor * 0.25,
                              bottom: screenHeight * scaleFactor
                          ),
                          child: Center(
                            child: Text("No Notifications",
                              style: TextStyle(fontSize: Theme.of(context).textTheme.subhead.fontSize, color: _themeData.primaryColor),
                            ),
                          ),
                        );
                      }
                    }

                  },
                )
            )



          ]
      ),
    );


  }



}




