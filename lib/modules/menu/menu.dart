import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iris_social_network/app/app_handlers.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'menu_views.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_contants;
import 'menu_bloc.dart';
import 'menu_bloc_provider.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/modules/home/home_bloc_provider.dart';





class Menu extends StatefulWidget {

  static String routeName = AppRoutes.menu_screen;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {


  MenuBloc _bloc;

  TextEditingController _feedBackTextEditingController;
  TextEditingController _reportBugTextEditingController;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = MenuBloc();

    _feedBackTextEditingController = TextEditingController();
    _reportBugTextEditingController = TextEditingController();

    AppHandler.getIfAppHasNewUpdateVersion().then((bool appHasNewVersion){
      _bloc.addAppHasNewVersionUpdateToStream(appHasNewVersion);
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _feedBackTextEditingController.dispose();
    _reportBugTextEditingController.dispose();

    super.dispose();
  }






  @override
  Widget build(BuildContext context) {



    return MenuBlocProvider(
      bloc: _bloc,
      feedBackTextEditingController: this._feedBackTextEditingController,
      reportBugTextEditingController: this._reportBugTextEditingController,
      child: Scaffold(

        body: StreamBuilder<String>(
            stream: AppBlocProvider.of(context).bloc.getBackgroundImageStream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(

                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                decoration: BoxDecoration(
                  image: DecorationImage(image: CachedNetworkImageProvider(
                      snapshot.hasData? snapshot.data: ""
                  ),
                      fit: BoxFit.cover
                  ),
                ),


                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: app_contants.WidgetsOptions.blurSigmaX,
                      sigmaY: app_contants.WidgetsOptions.blurSigmaY
                  ),
                  child: CupertinoPageScaffold(

                      backgroundColor: Colors.black.withOpacity(0.1),

                      navigationBar: CupertinoNavigationBar(
                        middle: Text("Menu", style: TextStyle(color: RGBColors.white.withOpacity(0.5)),),
                        backgroundColor: Colors.white.withOpacity(0.2),
                      ),

                      child: MenuView()
                  ),
                ),
              );
            }
        ),

      ),
    );
  }
}
