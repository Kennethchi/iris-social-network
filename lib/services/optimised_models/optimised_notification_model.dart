import 'package:iris_social_network/services/constants/constants.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';



class OptimisedNotificationModel implements Comparable<OptimisedNotificationModel>{

  String id;
  String userFromName;
  String userFromUserName;
  bool userFromIsVerified;



  String from;
  String n_type;
  int t;
  bool load;


  OptimisedNotificationModel({
    @required this.from,
    @required this.n_type,
    @required this.t,
  }){
    if (n_type == NotificationType.friend_req
        || n_type == NotificationType.friend_req_accepted
    ){
      this.load == true;
    }
    else{
      this.load == null;
    }

  }


  OptimisedNotificationModel.fromJson(Map<dynamic, dynamic> json){

    this.from = json[NotificationsFieldNamesOptimised.from];
    this.n_type = json[NotificationsFieldNamesOptimised.n_type];
    this.t = json[NotificationsFieldNamesOptimised.t];
    this.load = json[NotificationsFieldNamesOptimised.load];

    /*
    this.name = json[NotificationsFieldNamesOptimised.name];
    this.token = json[NotificationsFieldNamesOptimised.token];
    this.m_type = json[NotificationsFieldNamesOptimised.m_type];
    this.msg_id = json[NotificationsFieldNamesOptimised.msg_id];
    this.msg = json[NotificationsFieldNamesOptimised.msg];
    */

  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[NotificationsFieldNamesOptimised.from] = this.from;
    data[NotificationsFieldNamesOptimised.n_type] = this.n_type;
    data[NotificationsFieldNamesOptimised.t] = this.t;
    data[NotificationsFieldNamesOptimised.load] = this.load;

    return data;
  }




  @override
  int compareTo(OptimisedNotificationModel other) {
    // TODO: implement compareTo


    // sorts in descending order
    if (this.id.compareTo(other.id) < 0){
      return 1;
    }
    else if (this.id.compareTo(other.id) > 0){
      return -1;
    }
    else{
      return 0;
    }
  }


}





