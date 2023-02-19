import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:iris_social_network/modules/home/home.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iris_social_network/services/firebase_services/firebase_auth_service.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'account_setup_views.dart';
import 'account_setup_bloc.dart';
import 'account_setup_bloc_provider.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'account_setup_views.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';





class AccountSetup extends StatefulWidget{

  static const routeName = AppRoutes.account_setup_screen;

  _AccountSetupState createState() => new _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> with SingleTickerProviderStateMixin{


  AccountSetupBloc _bloc;  // business logi
  PageController _pageController;  // page vip for account type

  TextEditingController _userNameEditTextController;
  TextEditingController _profileNameEditTextController;

  FocusNode _profileNameTextFieldFocusNode;
  FocusNode _userNameTextFieldFocusNode;

  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _profileNameTextFieldFocusNode = FocusNode();
    _userNameTextFieldFocusNode = FocusNode();

    FirebaseAuth.instance.currentUser().then((user){
      if (user == null){
        Navigator.of(context).pushReplacementNamed(AppRoutes.splash_screen);
      }
      else{


        SharedPreferences.getInstance().then((SharedPreferences prefs){

          bool setupComplete = prefs.getBool(SharedPrefsKeys.account_setup_complete + user.uid);

          if (setupComplete != null && setupComplete){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                Home(appBloc: AppBlocProvider.of(context).bloc,)
            ), (Route<dynamic> route) => false);
          }
          else if(setupComplete == null){

            _bloc.checkIfUserDataExists(userId: user.uid).then((bool userDataExists){


              if (userDataExists){

                SharedPreferences.getInstance().then((SharedPreferences prefs){

                  prefs.setBool(SharedPrefsKeys.account_setup_complete + user.uid, true);
                }).then((_){

                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>
                      Home(appBloc: AppBlocProvider.of(context).bloc,)
                  ), (Route<dynamic> route) => false);
                });

              }
              else{

                SharedPreferences.getInstance().then((SharedPreferences prefs){

                  prefs.setBool(SharedPrefsKeys.account_setup_complete + user.uid, false);
                });
              }

            });

          }

        });

      }
    });



    _bloc = AccountSetupBloc();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1, milliseconds: 500));

    _userNameEditTextController = TextEditingController();
    _profileNameEditTextController = TextEditingController();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _pageController.dispose();
    _animationController.dispose();

    _profileNameEditTextController.dispose();
    _profileNameTextFieldFocusNode.dispose();

    _userNameEditTextController.dispose();
    _userNameTextFieldFocusNode.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return AccountSetupBlocProvider(
      bloc: _bloc,
      pageController: _pageController,
      usernameEditTextController: _userNameEditTextController,
      profileNameEditTextController: this._profileNameEditTextController,
      profileNameTextFieldFocusNode: this._profileNameTextFieldFocusNode,
      userNameTextFieldFocusNode: this._userNameTextFieldFocusNode,
      animationController: _animationController,

      child: WillPopScope(

        onWillPop: ()async{

          await AppBlocProvider.of(context).handler.showQuitAppOption(
              pageContext: context,
            message: "Do you want to quit Account Setup?\nChanges will not be saved."
          );
        },

        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          //backgroundColor: RGBColors.white,
          body: AccountSetupView()
        ),
      ),
    );
  }

}











