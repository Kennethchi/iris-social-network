import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:meta/meta.dart';


class OptimisedChatModel implements Comparable<OptimisedChatModel>{

  UserModel chatUserModel;
  String username;
  String name;
  String thumb;
  bool v_user;



  String chat_user_id;
  String sender_id;
  int t;
  String text;
  bool seen;
  bool tp;
  String msg_type;


  OptimisedChatModel({
    @required this.chat_user_id,
    @required this.sender_id,
    this.text,
    @required this.msg_type,
    @required this.seen,
    this.tp = false,
    @required this.t,
  }) :
        //assert(tp == true || tp == false),
        assert(chat_user_id != null),
        assert(sender_id != null),
        assert(t != null),
        assert(msg_type != null),
        assert(seen != null);



  OptimisedChatModel.fromJson(Map<dynamic, dynamic> json){
    this.chat_user_id = json[PrivateChatsFieldNamesOptimised.chat_user_id];
    this.v_user = json[PrivateChatsFieldNamesOptimised.v_user];
    this.username = json[PrivateChatsFieldNamesOptimised.username];
    this.name = json[PrivateChatsFieldNamesOptimised.name];
    this.thumb = json[PrivateChatsFieldNamesOptimised.thumb];

    this.sender_id = json[PrivateChatsFieldNamesOptimised.sender_id];
    this.text = json[PrivateChatsFieldNamesOptimised.text];
    this.msg_type = json[PrivateChatsFieldNamesOptimised.msg_type];
    this.seen = json[PrivateChatsFieldNamesOptimised.seen];
    this.tp = json[PrivateChatsFieldNamesOptimised.tp];
    this.t = json[PrivateChatsFieldNamesOptimised.t];
  }


  Map<dynamic, dynamic> toJson() {

    Map<dynamic, dynamic> data = new Map<String, dynamic>();

    data[PrivateChatsFieldNamesOptimised.chat_user_id] = this.chat_user_id;
    data[PrivateChatsFieldNamesOptimised.v_user] = this.v_user;
    data[PrivateChatsFieldNamesOptimised.username] = this.username;
    data[PrivateChatsFieldNamesOptimised.name] = this.name;
    data[PrivateChatsFieldNamesOptimised.thumb] = this.thumb;
    data[PrivateChatsFieldNamesOptimised.sender_id] = this.sender_id;
    data[PrivateChatsFieldNamesOptimised.text] = this.text;
    data[PrivateChatsFieldNamesOptimised.msg_type] = this.msg_type;
    data[PrivateChatsFieldNamesOptimised.seen] = this.seen;
    data[PrivateChatsFieldNamesOptimised.tp] = this.tp;
    data[PrivateChatsFieldNamesOptimised.t] = this.t;


    return data;
  }




  @override
  int compareTo(OptimisedChatModel other) {
    // TODO: implement compareTo


    // sorts in descending order
    if (this.t < other.t){
      return 1;
    }
    else if (this.t > other.t){
      return -1;
    }
    else{
      return 0;
    }

  }



}



