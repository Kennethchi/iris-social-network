import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';



class OptimisedCommentModel implements Comparable<OptimisedCommentModel>{

  String id;
  String name;
  String username;
  String user_id;
  String thumb;
  String comment;
  bool v_user;
  int t;


  OptimisedCommentModel({
    this.id,
    this.name,
    this.username,
    @required this.user_id,
    this.thumb,
    @required this.comment,
    @required this.t,
    this.v_user
});


  OptimisedCommentModel.fromJson(Map<dynamic, dynamic> json){

    this.id = json[CommentFieldNamesOptimised.id];
    this.name = json[CommentFieldNamesOptimised.name];
    this.username = json[CommentFieldNamesOptimised.username];
    this.user_id = json[CommentFieldNamesOptimised.user_id];
    this.thumb = json[CommentFieldNamesOptimised.thumb];
    this.comment = json[CommentFieldNamesOptimised.comment];
    this.t = json[CommentFieldNamesOptimised.t];
    this.v_user = json[CommentFieldNamesOptimised.v_user];
  }


  Map<dynamic, dynamic> toJson(){

    Map<dynamic, dynamic> data = Map<dynamic, dynamic>();

    data[CommentFieldNamesOptimised.id] = this.id;
    data[CommentFieldNamesOptimised.name] = this.name;
    data[CommentFieldNamesOptimised.username] = this.username;
    data[CommentFieldNamesOptimised.user_id] = this.user_id;
    data[CommentFieldNamesOptimised.thumb] = this.thumb;
    data[CommentFieldNamesOptimised.comment] = this.comment;
    data[CommentFieldNamesOptimised.t] = this.t;
    data[CommentFieldNamesOptimised.v_user] = this.v_user;

    return data;
  }



  @override
  int compareTo(OptimisedCommentModel other) {
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