import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'followers_and_followings_bloc.dart';
import 'followers_and_followings_bloc_provider.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iris_social_network/modules/profile/profile.dart';





Widget getFollowersAndFollowingsAppBar({BuildContext context, @required profileUserId}){

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    

    return CupertinoNavigationBar(

      middle: FFAppbarTitleWidget(),
      backgroundColor: profileUserId == AppBlocProvider.of(context).bloc.getCurrentUserId? RGBColors.white.withOpacity(0.2): RGBColors.light_grey_level_1.withOpacity(0.8),
      border: Border.all(style: BorderStyle.none),
      
    );
  
}



class FFAppbarTitleWidget extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    FollowersAndFollowingsBlocProvider _provider = FollowersAndFollowingsBlocProvider.of(context);
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    FollowersAndFollowingsBloc _bloc = FollowersAndFollowingsBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    
    
    
    return StreamBuilder<bool>(
      stream: _bloc.getIsFollowersViewStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){


        switch(snapshot.connectionState){
          case ConnectionState.none: case ConnectionState.waiting:
            return Container();
          case ConnectionState.active: case ConnectionState.done:
            
            return Text(snapshot.data? "Followers": "Following",
              style: TextStyle(
                  color: _provider.profileUserId == AppBlocProvider.of(context).bloc.getCurrentUserId
                      ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5)
              ),
            );
        }

      },
    );
  }
}




class FFViewModelHolder extends StatelessWidget{
  
  OptimisedFFModel optimisedFFModel;
  
  
  
  FFViewModelHolder({@required this.optimisedFFModel});
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    FollowersAndFollowingsBlocProvider _provider = FollowersAndFollowingsBlocProvider.of(context);
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    FollowersAndFollowingsBloc _bloc = FollowersAndFollowingsBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return GestureDetector(

      onTap: (){

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> Profile(profileUserId: optimisedFFModel.user_id)));
      },

      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(optimisedFFModel.thumb),
          backgroundColor: RGBColors.light_grey_level_1,
        ),
        title: Row(
          children: <Widget>[

            Flexible(
                child: Text(optimisedFFModel.name,
                  style: TextStyle(
                      color: _provider.profileUserId == AppBlocProvider.of(context).bloc.getCurrentUserId? Colors.white: Colors.black.withOpacity(0.8),

                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                )
            ),

            if (optimisedFFModel.v_user != null && optimisedFFModel.v_user)
              SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

            Container(
              child: optimisedFFModel.v_user != null && optimisedFFModel.v_user
                  ? Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.3,)
                  : Container(),
            )
          ],
        ),
        subtitle: Text("@"+optimisedFFModel.username, style: TextStyle(
            color: _provider.profileUserId == AppBlocProvider.of(context).bloc.getCurrentUserId
                ? Colors.white.withOpacity(0.6): Colors.black.withOpacity(0.8)
        ),
        ),
        dense: true,

      ),
    );
  }
}



class FFListWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    FollowersAndFollowingsBloc _bloc = FollowersAndFollowingsBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);


    return StreamBuilder<List<OptimisedFFModel>>(
      stream: _bloc.getFFListStream,
      builder: (BuildContext context, AsyncSnapshot<List<OptimisedFFModel>> snapshot){


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

            if (snapshot.data.length == 0){

              return SliverList(delegate: SliverChildListDelegate(
                  <Widget>[

                    Container()
                  ]
              ));

            }
            else{

              return SliverList(delegate: SliverChildListDelegate(
                snapshot.data.map((OptimisedFFModel optimisedFFModel){

                  int index = snapshot.data.indexOf(optimisedFFModel);

                  return FFViewModelHolder(optimisedFFModel: snapshot.data[index]);
                }).toList(),
              ));

            }


        }
      },
    );

  }
}




class LoadingFFIndicatorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    FollowersAndFollowingsBloc _bloc = FollowersAndFollowingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return SliverList(
      delegate: SliverChildListDelegate(
          <Widget>[

            StreamBuilder(
              stream: _bloc.getIsFollowersViewStream,
              builder: (BuildContext context, AsyncSnapshot<bool> isFollowerViewsnapshot){

                if (isFollowerViewsnapshot.hasData){

                  return Container(
                      child: StreamBuilder(
                        stream: _bloc.getHasMoreFFStream,
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
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * 0.5),
                                  child: Center(
                                    child: Text(isFollowerViewsnapshot.data? "No Followers": "No Followings",
                                      style: TextStyle(fontSize: Theme.of(context).textTheme.subhead.fontSize, color: _themeData.primaryColor),
                                    ),
                                  ),
                                );
                              }
                          }

                        },
                      )
                  );

                }
                else{
                  return Container();
                }

              },

            ),



          ]
      ),
    );


  }



}



