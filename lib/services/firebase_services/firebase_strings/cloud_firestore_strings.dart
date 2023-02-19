import 'package:iris_social_network/services/constants/platform_channel_constants.dart';


// Collection names at the Root Directory
class RootCollectionNames{
  static const String users = "users";
}


// SubCollection names of Documents
class SubCollectionNames{

  static const String comments = "comments";
  static const String private_messages = "private_messages";
  static const String public_messages = "public_messages";
  static const String followers = "followers";
  static const String followings = "followings";
  static const String chats = "chats";
  static const String private_chats = "private_chats";
  static const String public_chats = "public_chats";
  static const String contacts = "contacts";
  static const String videos = "videos";

  static const String user_posts = "user_posts";
}


// This field is linked to the platform channels in android
// Please if you change this, also change that in android and later ios, when it is implemented
//
//
class ContactsDocumentFieldName{
  static const String user_id = "user_id";
  static const String display_name = "display_name";
  static const String phone_number = "phone_number";
  static const String thumb = "thumb";
}




// Field names attributes of documents
class UsersDocumentFieldNames{

  static const String user_id = "user_id";
  static const String username = "username";
  static const String phone_number = "phone_number";
  static const String phone_code = "phone_code";
  static const String profile_name = "profile_name";
  static const String gender_type = "gender_type";
  static const String profile_status = "profile_status";
  static const String profile_image = "profile_image";
  static const String profile_thumb = "profile_thumb";
  static const String profile_audio = "profile_audio";
  static const String device_token = "device_token";
  static const String num_followers = "num_followers";
  static const String num_followings = "num_followings";
  static const String num_posts = "num_posts";
  static const String user_location = "user_location";
  static const String timestamp = "timestamp";
  static const String verified_user = "verified_user";
  static const String fcm_token = "fcm_token";
  static const String iris_points = "iris_points";


  static const String blocked_users = "blocked_users";
  static const String blocked_posts = "blocked_posts";
  static const String geo_point = "geo_point";
  static const String friends = "friends";
  static const String birthday = "birthday";

  static const String receive_friendrequest = "receive_friendrequest";

  static const String show_public_posts = "show_public_posts";

//static const String language = "language";
  //static const String search_key = "search_key";
  //static const String setup_complete = "setup_complete";

}


class VideosDocumentFieldName{

  static const String video_id = "video_id";
  static const String video_image = "video_image";
  static const String video_thumb = "video_thumb";
  static const String video_url = "video_url";
  static const String timestamp = "timestamp";
  static const String num_likes = "num_likes";
  static const String num_comments = "num_comments";
  static const String num_shares = "num_shares";
  static const String num_views = "num_views";
  static const String talent_type = "talent_type";
  static const String video_category = "video_category";
  static const String duration = "duration";
}


class PostDocumentFieldName{

  static const String post_id = "post_id";
  static const String user_id = "user_id";
  static const String post_type = "post_type";
  static const String post_caption = "post_caption";
  static const String post_audience = "post_audience";
  static const String post_data = "post_data";
  static const String timestamp = "timestamp";
  static const String user_name = "user_name";
  static const String user_thumb = "user_thumb";
  static const String user_profile_name = "user_profile_name";
  static const String verified_user = "verified_user";
  static const String blocked_post = "blocked_post";

  static const String friends = "friends";
}


class ImageDocumentFieldNames{

  static const String image_id = "image_id";
  static const String images_url = "images_url";
  static const String images_thumbs_url = "images_thumbs_url"; // change this before production
  static const String timestamp = "timestamp";
  static const String num_likes = "num_likes";
  static const String num_comments = "num_comments";
  static const String num_shares = "num_shares";
}


class AudioDocumentFieldNames{

  static const String audio_id = "audio_id";
  static const String audio_image = "audio_image";
  static const String audio_thumb = "audio_thumb";
  static const String audio_url = "audio_url";
  static const String timestamp = "timestamp";
  static const String num_likes = "num_likes";
  static const String num_comments = "num_comments";
  static const String num_shares = "num_shares";
  static const String num_listens = "num_listens";
  //static const String talent_type = "talent_type";
  //static const String video_category = "video_category";
  static const String duration = "duration";
}




class CommentsDocumentFieldName{

  static const String user_profile_name = "user_profile_name";
  static const String user_profile_image = "user_profile_image";
  static const String comment = "comment";
  static const String timestamp = "timestamp";

}



class FFDocumentFieldName{

  static const String name = "name";
  static const String user_id = "user_id";
  static const String thumb = "thumb";
  static const String t = "t";

}




// Need to carefully examine below field names
class ChatsDocumentFieldName{

  static const String chat_user_id = "chat_user_id";
  static const String name = "name";
  static const String thumb = "thumb";
  static const String phone_num = "phone_num";
  static const String sender_id = "sender_id";
  static const String timestamp = "timestamp";
  static const String images = "images";
  static const String video = "video;";
  static const String message = "message";
  static const String m_type = "m_type"; // message type
  static const String seen = "seen";

}



class MessageImageDocumentFieldNames{
  static const String images_url = "images_url";
  static const String images_thumbs_url = "images_thumbs_url";
}

class MessageAudioDocumentFieldNames{
  static const String audio_image = "audio_image";
  static const String audio_thumb = "audio_thumb";
  static const String audio_url = "audio_url";
  static const String duration = "duration";
}


class MessageVideoDocumentFieldNames{
  static const String video_image = "video_image";
  static const String video_thumb = "video_thumb";
  static const String video_url = "video_url";
  static const String duration = "duration";
}



class ChallengesDocumentFieldName{

  static const String name = "name";
  static const String image = "image";
  static const String thumb = "thumb";
  static const String timestamp = "timestamp";
  static const String winner_id = "winner_id";
  static const String winning_video_id = "winning_video_id";
  static const String status = "status";
  static const String info = "info";
  static const String top_winners_Id = "top_winners_id";
}



class FriendMapFieldNames{
  static const String user_id = "use_id";
  static const String timestamp = "timestamp";
}




