import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'settings_view.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_contants;
import 'settings_bloc.dart';
import 'settings_bloc_provider.dart';




class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  SettingsBloc _bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = SettingsBloc();
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }






  @override
  Widget build(BuildContext context) {



    return SettingsBlocProvider(
      bloc: _bloc,
      
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

                  backgroundColor: Colors.black.withOpacity(0.0),
                  
                  navigationBar: CupertinoNavigationBar(
                    middle: GestureDetector(

                      onTap: (){

                        _bloc.addMonitoredTapCountToStream();
                      },

                        child: Text("My Settings", style: TextStyle(color: Colors.white.withOpacity(0.5)),)
                    ),
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),

                  child: SettingsView()
                ),
              ),
            );
          }
        ),

      ),
    );
  }
}
