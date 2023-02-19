import 'package:firebase_database/firebase_database.dart';


class RootReferenceNames{

  static const String posts = "posts";
  static const String users = "users";

  static const String notifications = "notifications";
  static const String message_notifications = "message_notifications";
  static const String followers = "followers";
  static const String followings = "followings";

  static const String friend_requests = "friend_requests";

  static const String posts_comments = "posts_comments";
  static const String posts_likes = "posts_likes";

  static const String feedbacks = "feedbacks";
  static const String bug_reports = "bug_reports";

  static const String private_chats = "private_chats";

  static const String private_messages = "private_messages";

  static const String deleted_files_path = "deleted_files_path";
}



// Field names attributes of documents
class UsersFieldNamesOptimised{

  static const String user_id = "user_id"; // user id
  static const String username = "username";
  static const String name = "name"; // user profile name
  static const String thumb = "thumb";
  static const String nFr = "nFr"; // number of followers
  static const String nFg = "nFg"; // number of followings
  static const String nV = "nV"; // number of videos
  static const String nP = "nP";
  static const String s = "s"; // search key
  static const String o = "o"; // online
  static const String v_user = "v_user";
  static const String pts = "pts";
  static const String fcm_token = "fcm_token";
  static const String receive_friendreq = "receive_friendreq";
}



class FFFieldNamesOptimised{

  static const String name = "name";
  static const String username = "username";
  static const String user_id = "user_id";
  static const String thumb = "thumb";
  static const String t = "t";
  static const String v_user = "v_user";

}


class NotificationsFieldNamesOptimised{

  static const String from = "from"; // sender id
  static const String n_type = "n_type"; // notification type
  static const String t = "t";
  static const String load = "load";
}





class PrivateChatsFieldNamesOptimised{

  static const String chat_user_id = "chat_user_id"; // "chat_user_id"
  static const String username = "username";
  static const String name = "name";
  static const String v_user = "v_user";
  static const String thumb = "thumb";
  static const String sender_id = "sender_id";
  static const String t = "t";
  static const String text = "text";
  static const String msg_type = "msg_type";
  static const String seen = "seen";
  static const String tp = "tp"; // is typing
}

class PrivateMessagesFieldNamesOptimised{

  static const String msg_state = "msg_state";
}




class VideosPreviewFieldNamesOptimised{

  static const String v_id = "v_id";
  static const String caption = "caption";
  static const String v_thumb = "v_thumb";
  static const String v_image = "v_image";
  static const String t = "t";
  static const String v_url = "v_url";
  static const String nL = "nL";
  static const String nC = "nC";
  static const String nS = "nS";
  static const String nV = "nV";
  static const String t_type = "t_type";
  static const String v_category = "v_category";
  static const String duration = "duration";
  static const String u_id = "u_id";
  static const String u_thumb = "u_thumb";
  static const String username = "username";
  static const String p_name = "p_name";
}



class PostFieldNamesOptimised{
  static const String p_id = "p_id";
  static const String t = "t";
  static const String nL = "nL";
  static const String nC = "nC";
  static const String nS = "nS";
  static const String nV = "nV";
  static const String nLis = "nLis";
}




class CommentFieldNamesOptimised{

  static const String id = "id";
  static const String name = "name";
  static const String username = "username";
  static const String user_id = "user_id";
  static const String thumb = "thumb";
  static const String comment = "comment";
  static const String t = "t";
  static const String v_user = "v_user";

}


class FeedBackFieldNames{
  static const String fb = "fb";
}


class BugReportFieldNames{
  static const String bug = "bug";
}


class FriendRequestFieldNames{
  static const String req_status = "req_status";
}






