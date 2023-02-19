import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:meta/meta.dart';


class OptimisedUserModel{


  String userId; // user id
  String username;
  String name; // user profile name
  String thumb;
  int nFr; // number of followers
  int nFg; // number of followings
  int nP;
  String s; // search key
  int o; // online
  String fcm_token;
  bool v_user;
  int pts;

  bool receive_friendreq;


  OptimisedUserModel({
    @required this.userId,
    @required this.username,
    @required this.name,
    @required this.thumb,
    this.nFr = 0,
    this.nFg = 0,
    this.nP = 0,
    @required this.s,
    this.fcm_token,
    this.o,
    this.v_user,
    this.pts = 0,
    this.receive_friendreq
});


  OptimisedUserModel.fromJson({@required Map<dynamic, dynamic> json}){

    this.userId = json[UsersFieldNamesOptimised.user_id];
    this.username = json[UsersFieldNamesOptimised.username];
    this.name = json[UsersFieldNamesOptimised.name];
    this.thumb = json[UsersFieldNamesOptimised.thumb];
    this.nFr = json[UsersFieldNamesOptimised.nFr];
    this.nFg = json[UsersFieldNamesOptimised.nFg];
    this.nP = json[UsersFieldNamesOptimised.nP];
    this.s = json[UsersFieldNamesOptimised.s];
    this.fcm_token = json[UsersFieldNamesOptimised.fcm_token];
    this.o = json[UsersFieldNamesOptimised.o];
    this.v_user = json[UsersFieldNamesOptimised.v_user];
    this.pts = json[UsersFieldNamesOptimised.pts];
    this.receive_friendreq = json[UsersFieldNamesOptimised.receive_friendreq];
  }




  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[UsersFieldNamesOptimised.user_id] = this.userId;
    data[UsersFieldNamesOptimised.username] = this.username;
    data[UsersFieldNamesOptimised.name] = this.name;
    data[UsersFieldNamesOptimised.thumb] = this.thumb;
    data[UsersFieldNamesOptimised.nFr] = this.nFr;
    data[UsersFieldNamesOptimised.nFg] = this.nFg;
    data[UsersFieldNamesOptimised.nP] = this.nP;
    data[UsersFieldNamesOptimised.s] = this.s;
    data[UsersFieldNamesOptimised.fcm_token] = this.fcm_token;
    data[UsersFieldNamesOptimised.o] = this.o;
    data[UsersFieldNamesOptimised.v_user] = this.v_user;
    data[UsersFieldNamesOptimised.pts] = this.pts;
    data[UsersFieldNamesOptimised.receive_friendreq] = this.receive_friendreq;

    return data;
  }


}









