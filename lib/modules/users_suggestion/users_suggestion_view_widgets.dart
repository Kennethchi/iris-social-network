import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/modules/profile/profile.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'users_suggestion_bloc.dart';
import 'users_suggestion_bloc_provider.dart';



class SuggestedUsersListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    UsersSuggestionBlocProvider _provider = UsersSuggestionBlocProvider.of(context);
    UsersSuggestionBloc _bloc = UsersSuggestionBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<List<UserModel>>(
      stream: _bloc.getUsersListStream,
      builder: (context, snapshot) {

        switch(snapshot.connectionState){
          case ConnectionState.none:case ConnectionState.waiting:
            return Animator(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              cycles: 1000000000,
              curve: Curves.elasticOut,
              duration: Duration(seconds: 1),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: Container(
                    height: screenHeight * 0.55,
                    child: AspectRatio(
                      aspectRatio: 10 / 16,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25),
                          color: RGBColors.light_grey_level_1,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          case ConnectionState.active:case ConnectionState.done:

            if (snapshot.hasData && snapshot.data.length > 0){
              return Container(
                height: screenHeight * 0.55,

                child: ListView(
                  controller: _provider.scrollController,
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data.map((UserModel userModel){
                    return Padding(
                      padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                      child: AspectRatio(
                          aspectRatio: 10 / 16,
                          child: SuggestedUserViewModel(userModel: userModel)
                      ),
                    );
                  }).toList()..add(Padding(
                      padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                    child: LoadingSuggestedUsersIndicatorWidget(),
                  ),),

                ),

              );
            }
            else{
              return Container();
            }


        }

        return Container();
      }
    );
  }
}





class SuggestedUserViewModel extends StatelessWidget {

  UserModel userModel;

  SuggestedUserViewModel({@required this.userModel});

  @override
  Widget build(BuildContext context) {


    UsersSuggestionBlocProvider _provider = UsersSuggestionBlocProvider.of(context);
    UsersSuggestionBloc _bloc = UsersSuggestionBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Animator(

      tween: Tween<double>(begin: 0.0, end: 1.0),
      //repeats: 1,
      curve: Curves.easeOutBack,
      duration: Duration(milliseconds: 1000),
      builder: (anim){
        return Transform.scale(
            scale: anim.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.33),
              decoration: BoxDecoration(
                  color: RGBColors.light_grey_level_1,
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  CircleAvatar(
                    radius: screenWidth * 0.2,
                    backgroundColor: Colors.black.withOpacity(0.1),
                    backgroundImage: CachedNetworkImageProvider(userModel.profileThumb != null? userModel.profileThumb : ""),
                  ),
                  SizedBox(height: screenHeight * scaleFactor * 0.25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                          child: Text(userModel.profileName != null? userModel.profileName: "",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: Theme.of(context).textTheme.title.fontSize
                            ),
                            textAlign: TextAlign.center,
                          )
                      ),

                      Container(
                        child: userModel.verifiedUser != null && userModel.verifiedUser? Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5.0,),
                              Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: 15.0,),
                            ],
                          ),
                        ): Container(),
                      )
                    ],
                  ),
                  Text("@" + userModel.username,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * scaleFactor * 0.5,),

                  CupertinoButton(
                    color: _themeData.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      borderRadius: BorderRadius.circular(50.0),
                      child: Text("View Profile",
                        style: TextStyle(
                            //color: _themeData.primaryColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: (){
                        Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context){
                          return Profile(profileUserId: userModel.userId,);
                        }));
                      }
                  )

                ],
              ),
            )
        );
      },
    );
  }
}






class LoadingSuggestedUsersIndicatorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    UsersSuggestionBlocProvider _provider = UsersSuggestionBlocProvider.of(context);
    UsersSuggestionBloc _bloc = UsersSuggestionBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(
        child: StreamBuilder(
          stream: _bloc.getHasMoreUsersStream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

            switch(snapshot.connectionState){
              case ConnectionState.none:
                return Container();
              case ConnectionState.waiting:
                return SpinKitChasingDots(color: _themeData.primaryColor,);
              case ConnectionState.active: case ConnectionState.done:

              if (snapshot.hasData && snapshot.data){
                return SpinKitChasingDots(color: _themeData.primaryColor,);
              }
              else{

                return Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * scaleFactor * 0.25,
                      bottom: screenHeight * scaleFactor
                  ),
                  child: Center(
                    child: Container(
                      child: Text("No Suggestions",
                        style: TextStyle(
                          color: _themeData.primaryColor,
                          fontSize: Theme.of(context).textTheme.title.fontSize
                        ),
                      ),
                    ),
                  ),
                );

              }
            }



          },
        )
    );
  }

}




