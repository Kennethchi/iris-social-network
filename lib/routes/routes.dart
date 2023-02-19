import 'package:flutter/material.dart';
import 'package:iris_social_network/modules/menu/menu.dart';
import 'package:iris_social_network/modules/splash_screen/splash_screen.dart';
import 'package:iris_social_network/modules/registration/signup.dart';
import 'package:iris_social_network/modules/account_setup/account_setup.dart';
import 'package:iris_social_network/modules/home/home.dart';
import 'package:iris_social_network/modules/profile/profile.dart';
import 'package:iris_social_network/modules/chat_room/chat_room.dart';

import 'package:iris_social_network/modules/chat_room/private_chat_room/private_chat_room.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat.dart';
import 'package:iris_social_network/modules/post/post.dart';
import 'package:iris_social_network/modules/search/search.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';



class AppRoutes{

  static const String splash_screen = "/splash_screen";
  static const String signup_screen = "/signup_screen";
  static const String account_setup_screen = "/account_setup_screen";
  static const String home_screen = "/home_screen";
  static const String profile_screen = "/profile_screen";
  static const String chat_room_screen = "/chat_room_screen";

  static const String private_chat_room_screen = "/private_chat_room_screen";

  static const String private_chat_screen = "/private_chat_screen";

  static const String video_feed_screen = "/video_feed_screen";

  static const String post_screen = "/post_screen";

  static const String search_screen = "/search_screen";

  static const String menu_screen = "/menu_screen";

  // Contains all routes in the app
  static Map<String, WidgetBuilder> get getAppRoutes => {

    splash_screen: (BuildContext context) => SplashScreen(),
    signup_screen: (BuildContext context) => SignUp(),
    account_setup_screen: (BuildContext context) => AccountSetup(),
    home_screen: (BuildContext context) => Home(appBloc: AppBlocProvider.of(context).bloc,),
    profile_screen: (BuildContext context) => Profile(),
    chat_room_screen: (BuildContext context) => ChatRoom(),

    private_chat_room_screen: (BuildContext context) => PrivateChatRoom(currentUserId: AppBlocProvider.of(context).bloc.getCurrentUserId,),
    private_chat_screen: (BuildContext context) => PrivateChat(),

    post_screen: (BuildContext context) => Post(),

    search_screen: (BuildContext context) => Search(),

    menu_screen: (BuildContext context) => Menu()
  };



}
