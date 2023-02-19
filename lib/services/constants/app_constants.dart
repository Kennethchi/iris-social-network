enum REPOSITORY_DEPENDENCY{
  MOCK,
  PRODUCTION
}

enum POST_QUERY_TYPE{
  MOST_RECENT,
}

enum SEARCH_TYPE{
  USERNAME,
  PROFILE_NAME,
}


class SharedPrefsKeys{

  static const String account_setup_complete = "account_setup_complete";

  static const String country_phone_code = "country_phone_code";

  static const String phone_number_list = "phone_number_list";

  // Game Keys
  static const String bubble_smash_score = "bubble_smash_score";

  static const String show_home_screen_ui_guide = "show_home_screen_ui_guide";
  static const String show_profile_screen_ui_guide = "show_profile_screen_ui_guide";
  static const String show_comment_screen_ui_guide = "show_comment_screen_ui_guide";

  static const String show_friends_feed_info = "show_friends_feed_info";
  static const String show_public_feed_info = "show_public_feed_info";
  static const String show_chat_info = "show_chat_info";
  static const String home_main_page = "home_main_page";

  static const String show_update_app_dialog = "show_update_app_dialog";

  static const String app_theme_color_value = "app_theme_color_value";

  static const String image_classification_challenge_model_string = "image_classification_challenge_model_string";

  static const String new_day_timestamp_in_milliseconds = "new_day_timestamp_in_milliseconds";
}



class ProfileState{

  static const String follow = "follow";
  static const String unfollow = "unfollow";
  static const String admin = "admin";
}


class PostAudience{
  static const String only_me = "only_me";
  static const String private = "private";
  static const String public = "public";
}





class AppFeaturesLimits{
  static int UPLOAD_VIDEO_SIZE_IN_BYTES_LIMIT = 50000000; // in Bytes
  static int VIDEO_DURATION_IN_SECONDS_LIMIT = 90;  // int Seconds
  static int IMAGES_PER_POST_LIMIT = 5;

  static int UPLOAD_AUDIO_SIZE_IN_BYTES_LIMIT = 10000000; // in Bytes
  //static int AUDIO_DURATION_IN_SECONDS_LIMIT = 3;

}



class AppMessageFeaturesLimits{

  static int UPLOAD_MESSAGE_VIDEO_SIZE_IN_BYTES_LIMIT = 50000000; // in Bytes
  static int MESSAGE_VIDEO_DURATION_IN_SECONDS_LIMIT = 1500;  // int Seconds
  static int IMAGES_PER_MESSAGE_LIMIT = 5;

  static int UPLOAD_MESSAGE_AUDIO_SIZE_IN_BYTES_LIMIT = 10000000; // in Bytes
//static int MESSAGE_AUDIO_DURATION_IN_SECONDS_LIMIT = 3;
}



class AppFeaturesMaxLimits{
  static double DELTA_PAGINATION = 50.0;
  static int MAX_NUMBER_OF_FRIENDS = 100;
  static int MAX_NUMBER_OF_NOTIFICATIONS_TO_LOAD = 100;

  static int MAX_NUMBER_OF_MESSAGES_TO_LOAD = 200;

  static int MAX_NUMBER_OF_SUGGESTED_USERS_TO_LOAD = 50;
}




class DatabaseQueryLimits{
  static const int POSTS_QUERY_LIMIT = 10;
  static const int COMMENTS_QUERY_LIMIT = 15;
  static const int MESSAGES_QUERY_LIMIT = 15;
  static const int FOLLOWERS_AND_FOLLOWINGS_QUERY_LIMIT = 15;
  static const int CHATS_QUERY_LIMIT = 15;
  static const int NOTIFICATIONS_QUERY_LIMIT = 15;

  static const int FRIENDS_QUERY_LIMITS = 15;

  static const int SUGGESTED_USERS_QUERY_LIMIT = 5;

}



class WidgetsOptions{

  static const double blurSigmaX = 10.0;
  static const double blurSigmaY = 10.0;
}



class AppStoragePaths{

  static const String _root = "/Iris"; // slash should be left infront of root
  static const String _media_directory_name = "Media";

  static const String _images_directory_name = "Iris Images";
  static const String _audios_directory_name = "Iris Audios";
  static const String _videos_directory_name = "Iris Videos";


  static String get _getMediaDirectoryPath => _root + "/$_media_directory_name";
  static String get getImagesDirectoryPath => _getMediaDirectoryPath + "/$_images_directory_name/";
  static String get getAudioDirectoryPath => _getMediaDirectoryPath + "/$_audios_directory_name/";
  static String get getVideoDirectoryPath => _getMediaDirectoryPath + "/$_videos_directory_name/";
}


class Contacts{

  static const String mtn_cameroon_number = "+237677919086";
  static const String orange_cameroon_number = "+237691395288";
}



class HomeMainPages{
  static const String friends_post_feed_page = "friends_post_feed_page";
  static const String post_feed_page= "post_feed_page";
  static const String private_chat_page = "private_chat_page";
  static const String friends_page = "friends_page";
  static const String notifications_page = "notifications_page";
}




class HiddenUsers{
  static  List<String> getHiddenUsersUsernamesList () => [
    "shurri",
    "ayong",
    "zerox",
    "berox",
  ];
}


String get getServiceUserId{
  return "ObOyipTBjVR4JF92pcdz7cAxOyx1";
}



