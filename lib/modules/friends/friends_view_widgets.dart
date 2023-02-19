import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'friends_bloc.dart';
import 'friends_bloc_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class NumberOfFriendsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    FriendsBlocProvider _provider = FriendsBlocProvider.of(context);
    FriendsBloc _bloc = FriendsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return Container(
      child: StreamBuilder<int>(
        stream: _bloc.getNumberOfFriendsStream,
        builder: (context, snapshot) {

          switch(snapshot.connectionState){

            case ConnectionState.none: case ConnectionState.waiting:
              return Container(
                child: Text(""),
              );
            case ConnectionState.active:case ConnectionState.done:
              if (snapshot.hasData){
                return Container(
                  child: Text("${snapshot.data} / ${AppFeaturesMaxLimits.MAX_NUMBER_OF_FRIENDS}",
                    style: TextStyle(
                        color: _themeData.primaryColor,
                        fontSize: Theme.of(context).textTheme.subtitle.fontSize,
                        fontWeight: FontWeight.bold
                    ),),
                );
              }
              else{
                return Container(
                  child: Text(""),
                );
              }
          }



        }
      ),
    );
  }
}
