import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/modules/profile/profile.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'search_bloc.dart';
import 'search_bloc_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';



class SearchTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SearchBloc _bloc = SearchBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      padding:  EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
      width: screenWidth,
      child: Card(
        color: Colors.white.withOpacity(0.2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.5),
        ),

        child: TextField(
          controller: SearchBlocProvider.of(context).searchTextEditingController,
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
          cursorColor: _themeData.primaryColor,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(screenHeight * scaleFactor * scaleFactor),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            border: InputBorder.none,
            suffixIcon: SearchButtonWidget(),
            hintText: "Search User by username e.g  iris",
            isDense: true

          ),

          onChanged: (String text){

            _bloc.addSearchTextToStream(searchText: text);
          },

        ),

      ),
    );
  }
}




class UserModelViewHolder extends StatelessWidget {

  UserModel userModel;

  UserModelViewHolder({@required this.userModel});


  @override
  Widget build(BuildContext context) {

    SearchBloc _bloc = SearchBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return GestureDetector(
      
      onTap: (){

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Profile(profileUserId: userModel.userId,)));
      },
      
      child: Container(
        child: ListTile(
          leading: Hero(
            tag: userModel.profileImage,
            child: CircleAvatar(
              backgroundColor: RGBColors.light_grey_level_1,
              backgroundImage: CachedNetworkImageProvider(userModel.profileThumb),
              child: userModel.profileThumb == null
                  ? Text(userModel.profileName.substring(0, 1).toUpperCase(),style: TextStyle(
                  color: _themeData.primaryColor,
                  fontWeight: FontWeight.bold
              ),)
                  : Container(),
            ),
          ),
          
          title: Row(
            children: <Widget>[

              Flexible(
                child: Text(userModel.profileName,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),),
              ),

              if (userModel.verifiedUser != null && userModel.verifiedUser)
                SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

              Container(
                child: userModel.verifiedUser != null && userModel.verifiedUser
                    ? Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.3,)
                    : Container(),
              )
            ],
          ),

          subtitle: Text("@" + userModel.username,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
            ),),
        ),

      ),
    );
  }
}






class SearchButtonWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    SearchBloc _bloc = SearchBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<String>(
      stream: _bloc.getSearchTextStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){

        return IconButton(
            color: RGBColors.white,
            disabledColor: RGBColors.white.withOpacity(0.5),
            icon: Icon(FontAwesomeIcons.solidPaperPlane),

            onPressed: snapshot.hasData && snapshot.hasError == false? (){


              AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection)async{

                if (hasInternetConnection != null && hasInternetConnection){

                  SearchBlocProvider.of(context).searchTextEditingController.clear();

                  _bloc.addSearchTextToStream(searchText: null);
                  _bloc.addIsSearchSuccessfull(null);

                  _bloc.getSearchUser(searchUser: snapshot.data).then((UserModel userModel){

                    _bloc.addSearchUserModelToStream(userModel);
                    if (userModel != null){
                      _bloc.addIsSearchSuccessfull(true);
                    }
                    else{
                      _bloc.addIsSearchSuccessfull(false);
                    }
                  });


                }
                else{

                  BasicUI.showSnackBar(
                      context: context,
                      message: "No Internet Connection",
                      textColor:  CupertinoColors.destructiveRed,
                      duration: Duration(seconds: 1)
                  );
                }

              });


            }: null
        );

      },
    );
  }
}








class SearchFoundIndicatorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    SearchBloc _bloc = SearchBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(
      padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
        child: StreamBuilder(
          stream: _bloc.getIsSearchSuccessfullStream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){


            switch(snapshot.connectionState){
              case ConnectionState.none:
                return Container();
              case ConnectionState.waiting:
                return SpinKitChasingDots(color: _themeData.primaryColor,);
              case ConnectionState.active: case ConnectionState.done:

                if (snapshot.data == null){

                  return SpinKitChasingDots(color: _themeData.primaryColor);
                }
                else{

                  if (snapshot.data){
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * 0.5),
                      child: Text("User Found",
                        style: TextStyle(fontSize: Theme.of(context).textTheme.subhead.fontSize, color: _themeData.primaryColor),
                      ),
                    );
                  }
                  else{
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * 0.5),
                      child: Text("No User Found",
                        style: TextStyle(fontSize: Theme.of(context).textTheme.subhead.fontSize, color: _themeData.primaryColor),
                      ),
                    );
                  }


                }
            }

          },
        )
    );


  }



}






