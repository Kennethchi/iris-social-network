import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:meta/meta.dart';
import 'dart:core';





class OptimisedPostModel implements Comparable<OptimisedPostModel>{
  String p_id;
  int t;
  int nL;
  int nC;
  int nS;
  int nV;
  int nLis;
  
  OptimisedPostModel({
    this.p_id,
    @required this.t,
    this.nL = 0,
    this.nC = 0,
    this.nS = 0,
    this.nV = 0,
    this.nLis = 0,
  });

  OptimisedPostModel.fromJson(Map<dynamic, dynamic> json){

    this.p_id = json[PostFieldNamesOptimised.p_id];
    this.t = json[PostFieldNamesOptimised.t];
    this.nL = json[PostFieldNamesOptimised.nL];
    this.nC = json[PostFieldNamesOptimised.nC];
    this.nS = json[PostFieldNamesOptimised.nS];
    this.nV = json[PostFieldNamesOptimised.nV];
    this.nLis = json[PostFieldNamesOptimised.nLis];

  }


  Map<dynamic, dynamic> toJson(){

    Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

    data[PostFieldNamesOptimised.p_id] = this.p_id;
    data[PostFieldNamesOptimised.t] = this.t;
    data[PostFieldNamesOptimised.nL] = this.nL;
    data[PostFieldNamesOptimised.nC] = this.nC;
    data[PostFieldNamesOptimised.nS] = this.nS;
    data[PostFieldNamesOptimised.nV] = this.nV;
    data[PostFieldNamesOptimised.nLis] = this.nLis;

    return data;
  }

  @override
  int compareTo(OptimisedPostModel other) {


    /*
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
     */

    // enables sort in descending other
    if (this.p_id.compareTo(other.p_id) < 0){
      return 1;
    }
    else if(this.p_id.compareTo(other.p_id) > 0){
      return -1;
    }
    else{
      return 0;
    }


  }



}




