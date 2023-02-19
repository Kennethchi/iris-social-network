import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/widgets/image_viewer/image_viewer.dart';
import 'friends_bloc.dart';
import 'friends_bloc_provider.dart';



class FriendsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: FriendsListView()
    );
  }
}




class FriendsListView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    FriendsBlocProvider _provider = FriendsBlocProvider.of(context);
    FriendsBloc _bloc = FriendsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<List<FriendModel>>(
      stream: _bloc.getFriendsListStream,
      builder: (BuildContext context, AsyncSnapshot<List<FriendModel>> snapshots){

        switch(snapshots.connectionState){

          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            return Center(
              child: SpinKitFadingCircle(color: RGBColors.light_grey_level_1,),
            );
          case ConnectionState.active: case ConnectionState.done:

          if (snapshots.hasData && snapshots.data.length > 0){


            return ListView.builder(
              padding: EdgeInsets.only(bottom: screenHeight * scaleFactor),
              controller: _provider.scrollController,
              itemCount: snapshots.data.length,
              itemBuilder: (BuildContext context, int index){


                return FriendModelViewHolder(friendModel: snapshots.data[index]);
              },
            );

          }
          else{
            return Center(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * scaleFactor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ScaleAnimatedTextKit(
                      text: ["No Friends"],
                      textStyle: TextStyle(
                        fontSize: Theme.of(context).textTheme.headline.fontSize,
                        color: _themeData.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * scaleFactor * 0.25,),
                    Text("Go to Search Page to search users and send them a Friend Request", style: TextStyle(
                      color: Colors.black.withOpacity(0.5)
                    ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

              ),
            );
          }

        }



      },
    );
  }

}






class FriendModelViewHolder extends StatelessWidget {

  FriendModel friendModel;

  FriendModelViewHolder({@required this.friendModel});


  @override
  Widget build(BuildContext context) {


    FriendsBlocProvider _provider = FriendsBlocProvider.of(context);
    FriendsBloc _bloc = FriendsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return GestureDetector(

      onTap: (){

        _provider.handlers.showfriendsOptionModalDialog(friendsContext: context, friendModel: friendModel);

      },

      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: RGBColors.light_grey_level_1,
            backgroundImage: CachedNetworkImageProvider(friendModel.userModel.profileThumb),
            child: friendModel.userModel.profileThumb == null? Text(friendModel.userModel.profileName[0]): null,

          ),

          title: Row(

            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Flexible(
                  child: Text(
                    friendModel.userModel.profileName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.bold),
                  )
              ),

              if (friendModel.userModel.verifiedUser != null && friendModel.userModel.verifiedUser)
                SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

              Container(
                child: friendModel.userModel.verifiedUser != null && friendModel.userModel.verifiedUser
                    ? Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.3,)
                    : Container(),
              )
            ],
          ),


          subtitle: Container(
              child: Text("@" + friendModel.userModel.username,
                overflow: TextOverflow.ellipsis,
              )
          )

      ),
    );
  }
}

