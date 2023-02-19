import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'routes/routes.dart';
import 'modules/splash_screen/splash_screen.dart';
import 'modules/account_setup/account_setup.dart';
import 'modules/chat_room/chat_room.dart';
import 'modules/home/home.dart';
import 'modules/chat/private_chat/private_chat.dart';
import 'modules/chat/private_chat/private_chat_dependency_injection.dart';
import 'modules/registration/phone_auth/auth_dependency_injection.dart';
import 'modules/account_setup/account_setup_dependency_injection.dart';
import 'modules/home/home_dependency_injection.dart';
import 'modules/profile/profile_dependency_injection.dart';
import 'modules/chat_room/private_chat_room/private_chat_room_dependency_injection.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';


import 'app/app.dart';
import 'app/data/app_dependency_injection.dart';

import 'package:iris_social_network/modules/comment_space/comment_space_dependency_injection.dart';
import 'package:iris_social_network/modules/followers_and_followings/followers_and_followings_dependency_injection.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:iris_social_network/utils/basic_utils.dart';
import 'package:iris_social_network/modules/profile_settings/profile_settings_dependency_injection.dart';
import 'package:iris_social_network/modules/post/post_dependency_injection.dart';
import 'package:iris_social_network/modules/post_feed/post_feed_dependency_injection.dart';
import 'package:iris_social_network/modules/post_room/post_room_dependency_injection.dart';
import 'package:iris_social_network/modules/search/search_dependency_injection.dart';
import 'package:iris_social_network/modules/menu/menu_dependency_injection.dart';
import 'package:iris_social_network/modules/create_message/create_message_dependency_injection.dart';
import 'package:iris_social_network/modules/friends/friends_dependency_injection.dart';
import 'package:iris_social_network/modules/notifications/notifications_dependency_injection.dart';
import 'package:iris_social_network/modules/friends_post_feed/friends_post_feed_dependency_injection.dart';
import 'package:iris_social_network/modules/achievements/achievements_dependency_injection.dart';

import 'package:iris_social_network/modules/entertaitement/entertaitement_features/image_classification_challenge/image_classification_challenge_dependency_injection.dart';

import 'package:iris_social_network/modules/users_suggestion/users_suggestion_dependency_injection.dart';

import 'package:data_connection_checker/data_connection_checker.dart';



import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';





void main(){

  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();


  // Initialise Firestore settings
  Firestore.instance.settings(cacheSizeBytes: 100000000);
  
  // Initialise firebase realtime database
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  //FirebaseDatabase.instance.setPersistenceCacheSizeBytes(100000000);
  


  FirebaseAuth.instance.currentUser().then((FirebaseUser user){
    if (user != null) {

      FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(user.uid).child(UsersFieldNamesOptimised.o).set(1);
      FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(user.uid).child(UsersFieldNamesOptimised.o).onDisconnect().set(Timestamp.now().millisecondsSinceEpoch);
    }
  });



  // Cache Manager Settings





  // App Dependency
  AppDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Phone Authentication dependency
  AuthDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Account Setup dependency
  AccountSetupDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Home dependency
  HomeDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Profile dependency
  ProfileDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Private chat room dependency
  PrivateChatRoomDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Private chat dependency
  PrivateChatDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);


  // Comment Space Dependency
  CommentSpaceDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  //Followers and Followings dependency
  FollowersAndFollowingsDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  //Profile settings dependency
  ProfileSettingsDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Post dependency
  PostDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Post feeds dependency
  PostFeedDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Post Room dependency
  PostRoomDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Search dependency
  SearchDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Menu dependency
  MenuDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Create Message Dependency
  CreateMessageDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  // Friends Dependency
  FriendsDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  NotificationsDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  FriendsPostFeedDependencyInjector.configure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  AchievementsDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  ImageClassificationChallengeDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);

  UsersSuggestionDependencyInjector.confgure(repository_dependency: REPOSITORY_DEPENDENCY.PRODUCTION);


  runApp(new App());

  //FirebaseAuth.instance.signOut();
  //FacebookLogin().logOut();
  //GoogleSignIn().signOut();

}





