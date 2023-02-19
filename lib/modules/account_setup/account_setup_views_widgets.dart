import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/modules/account_setup/account_setup_strings.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'account_setup_bloc.dart';
import 'account_setup_bloc_provider.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';




class ProfileNameViewNextButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    double topSpaceHeight = screenHeight * scaleFactor;


    return Container(
      child: StreamBuilder(
          stream: _bloc.getProfileNameStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){

            return AnimatedBuilder(
              animation: AccountSetupBlocProvider.of(context).animationController,
              builder: (BuildContext context, Widget child){
                return FadeTransition(
                  opacity: AccountSetupBlocProvider.of(context).fadeAnimation,

                  child:   FlatButton(

                    onPressed: snapshot.hasData && snapshot.data.length > 0? (){

                      _bloc.getUserModel.profileName = snapshot.data;

                      AccountSetupBlocProvider.of(context).profileNameTextFieldFocusNode.unfocus();
                      AccountSetupBlocProvider.of(context).pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOutBack);
                    }: null,

                    child: Text("Next", style: TextStyle(
                        color: snapshot.hasData && snapshot.data.length > 0? _themeData.primaryColor: Colors.black.withOpacity(0.2)
                    ),),
                  ),

                );
              },
            );


          }
      ),
    );
  }
}




class UsernameCheckButtonWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<String>(
      stream: _bloc.getUserNameStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){

        bool validateUsernameFormat = snapshot.hasData && snapshot.hasError == false;

        return CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Check",
            style: TextStyle(
                color: validateUsernameFormat? _themeData.primaryColor: Colors.black.withOpacity(0.2),
                fontWeight: FontWeight.bold
            ),
          ),
          onPressed: validateUsernameFormat?()async{

            String userNameTrial = AccountSetupBlocProvider.of(context).usernameEditTextController.text.toLowerCase();
            bool isUsernameTaken = await _bloc.checkUsernameIsTaken(
              userNameTrial: userNameTrial,
            );

            if (isUsernameTaken){
              _bloc.addUserNameResult(null);
            }
            else{
              _bloc.addUserNameResult(userNameTrial);
            }

          }: null,

        );

      },
    );
  }
}





class UsernameResultWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<String>(
      stream: _bloc.getUserNameResultStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){

        switch(snapshot.connectionState){
          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            return SpinKitPulse(color: _themeData.primaryColor,);
          case ConnectionState.active:case ConnectionState.done:

            if (snapshot.hasData){

              return Column(
                children: <Widget>[

                  Text("Username is Available:", ),
                  SizedBox(height: screenHeight * scaleFactor * 0.125,),

                  Text("@" + snapshot.data, style: TextStyle(
                    color: _themeData.primaryColor,
                    fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                  )),
                ],
              );
            }
            else{
              return Text("Username is Taken", style: TextStyle(color: Colors.pink),);
            }

        }
      },
    );
  }
}







class UserNameViewNextButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    double topSpaceHeight = screenHeight * scaleFactor;


    return Container(
      child: StreamBuilder(
          stream: _bloc.getUserNameResultStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){

            return AnimatedBuilder(
              animation: AccountSetupBlocProvider.of(context).animationController,
              builder: (BuildContext context, Widget child){
                return FadeTransition(
                  opacity: AccountSetupBlocProvider.of(context).fadeAnimation,

                  child:   FlatButton(

                    onPressed: snapshot.hasData && snapshot.data.length > 0? (){


                      _bloc.getUserModel.username = snapshot.data;

                      AccountSetupBlocProvider.of(context).userNameTextFieldFocusNode.unfocus();
                      AccountSetupBlocProvider.of(context).pageController.nextPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOutBack
                      );

                    }: null,

                    child: Text("Next", style: TextStyle(
                        color: snapshot.hasData && snapshot.data.length > 0? _themeData.primaryColor: Colors.black.withOpacity(0.2)
                    ),),
                  ),

                );
              },
            );


          }
      ),
    );
  }
}





class GenderTypeViewNextButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    double topSpaceHeight = screenHeight * scaleFactor;


    return Container(
      child: StreamBuilder(
          stream: _bloc.getGenderTypeStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){

            return AnimatedBuilder(
              animation: AccountSetupBlocProvider.of(context).animationController,
              builder: (BuildContext context, Widget child){
                return FadeTransition(
                  opacity: AccountSetupBlocProvider.of(context).fadeAnimation,

                  child:   FlatButton(

                    onPressed: snapshot.hasData && snapshot.data.length > 0? (){

                      _bloc.getUserModel.genderType = snapshot.data;
                      AccountSetupBlocProvider.of(context).pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOutBack);

                    }: null,

                    child: Text("Next", style: TextStyle(
                        color: snapshot.hasData && snapshot.data.length > 0? _themeData.primaryColor: Colors.black.withOpacity(0.2)
                    ),),
                  ),

                );
              },
            );


          }
      ),
    );
  }
}







class AccountSetupCompleteButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    double topSpaceHeight = screenHeight * scaleFactor;


    return Container(
      child: StreamBuilder<bool>(
          stream: _bloc.accountSetupCompleteObeservable,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

            return AnimatedBuilder(
              animation: AccountSetupBlocProvider.of(context).animationController,
              builder: (BuildContext context, Widget child){
                return FadeTransition(
                  opacity: AccountSetupBlocProvider.of(context).fadeAnimation,

                  child: FlatButton(

                    onPressed: snapshot.hasData && snapshot.data? (){


                      AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection){

                        if (hasInternetConnection != null && hasInternetConnection){
                           AccountSetupBlocProvider.of(context).handlers.saveAccountSetupChanges(accountSetupContext: context);
                        }
                        else{
                          BasicUI.showSnackBar(
                            context: context,
                            message: "No Internet Connection",
                            textColor:  CupertinoColors.destructiveRed,
                          );
                        }

                      });




                    }: null,



                    child: Text("DONE", style: TextStyle(
                        color: snapshot.hasData && snapshot.data? _themeData.primaryColor: Colors.black.withOpacity(0.2)
                    ),),
                  ),

                );
              },
            );


          }
      ),
    );
  }
}

