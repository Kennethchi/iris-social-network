import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/modules/achievements/achievements.dart';
import 'package:iris_social_network/modules/entertaitement/entertaitement.dart';
import 'package:iris_social_network/modules/entertaitement/entertaitement_features/image_classification_challenge/image_classification_challenge.dart';
import 'package:iris_social_network/modules/profile/profile.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/modules/splash_screen/splash_screen.dart';
import 'package:iris_social_network/modules/account_setup/account_setup.dart';
import 'package:iris_social_network/modules/chat_room/chat_room.dart';
import 'package:iris_social_network/modules/home/home.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat_dependency_injection.dart';
import 'package:iris_social_network/modules/registration/phone_auth/auth_dependency_injection.dart';
import 'package:iris_social_network/modules/account_setup/account_setup_dependency_injection.dart';
import 'package:iris_social_network/modules/home/home_dependency_injection.dart';
import 'package:iris_social_network/modules/profile/profile_dependency_injection.dart';
import 'package:iris_social_network/modules/chat_room/private_chat_room/private_chat_room_dependency_injection.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:iris_social_network/modules/search/search.dart';
import 'package:iris_social_network/widgets/games/bubble_smash/bubble_smash.dart';
import 'package:iris_social_network/widgets/particles/snow_particles.dart';

import 'app_bloc.dart';
import 'app_bloc_provider.dart';

import 'package:iris_social_network/modules/camera/camera.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import "package:iris_social_network/widgets/avatar_image_generator/avatar_image_generator.dart";



class App extends StatefulWidget{

  @override
  _AppState createState() => _AppState();

}


class _AppState extends State<App> with WidgetsBindingObserver {

  AppBloc _bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _bloc = AppBloc();

    // PRIORITY
    // DONT transfer this code into the AppBloc construct bc it will freeze the UI
    _bloc.getSavedAppThemeColorValue().then((int colorValue){
      _bloc.addAppThemeColorValueToStream(colorValue);
    });


    // initialises background color value for the different post types
    _bloc.addBackgroundColorValueToStream(Colors.white.value);
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);


    switch (state) {
      
      case AppLifecycleState.resumed:

        FirebaseDatabase.instance.goOnline().then((_){

          print("Firebase online");
        }).then((_){

          FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
            if (user != null) {
              FirebaseDatabase.instance.reference().child(
                  RootReferenceNames.users).child(user.uid).child(
                  UsersFieldNamesOptimised.o).set(1);
            }
          });
          print("resumed");
        });

        break;

      case AppLifecycleState.inactive:

        FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
          if (user != null) {
            FirebaseDatabase.instance.reference().child(
                RootReferenceNames.users).child(user.uid).child(
                UsersFieldNamesOptimised.o).set(Timestamp.now().millisecondsSinceEpoch);
          }
        });

        print("inactive");
        break;


      case AppLifecycleState.paused:

        FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
          if (user != null) {
            FirebaseDatabase.instance.reference().child(
                RootReferenceNames.users).child(user.uid).child(
                UsersFieldNamesOptimised.o).set(Timestamp.now().millisecondsSinceEpoch);
          }
        }).then((_){

          /*
          FirebaseDatabase.instance.goOffline().then((_){

            print("Firebase offline");
          });
          */
        });
        print("paused");
        break;


      case AppLifecycleState.detached:
        FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
          if (user != null) {
            FirebaseDatabase.instance.reference().child(
                RootReferenceNames.users).child(user.uid).child(
                UsersFieldNamesOptimised.o).set(Timestamp
                .now()
                .millisecondsSinceEpoch);
          }
        }).then((_){

          /*
          FirebaseDatabase.instance.goOffline().then((_){

            print("Firebase offline");
          });
          */
        });
        print("suspending");
        break;

    }

  }









  @override
  Widget build(BuildContext context) {


    return AppBlocProvider(
      bloc: _bloc,

      child: StreamBuilder<int>(
        stream: _bloc.getAppThemeColorValueStream,
        builder: (context, snapshot) {

          switch(snapshot.connectionState){
            case ConnectionState.none: case ConnectionState.waiting:
              return Container(
                color: Colors.white,
              );
            case ConnectionState.active: case ConnectionState.done:

              return CupertinoApp(
                debugShowCheckedModeBanner: false,

                localizationsDelegates: [
                  // ... app-specific localization delegate[s] here
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale("en", "US"), // English
                  const Locale("fr", "FR"), // French
                  const Locale('he', 'IL'), // Hebrew
                  // ... other locales the app supports
                ],

                routes: AppRoutes.getAppRoutes,

                theme: CupertinoThemeData(
                  primaryColor: snapshot.hasData? Color(snapshot.data): RGBColors.default_primary_color,
                  primaryContrastingColor: RGBColors.white,
                ),


                home: Home(appBloc: _bloc,),

                //home: ChatRoom(),

                //home: PrivateChat(),

                //home: Search(),

                //home: Achievements(),

                //home: BubbleSmash(),

                //home: Entertaitement(),

                //home: ImageClassificationChallenge(),

              );

          }



        }
      ),
    );
  }



}