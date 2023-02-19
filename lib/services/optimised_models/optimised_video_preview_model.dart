import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:meta/meta.dart';
import 'dart:core';





class OptimisedVideoPreviewModel implements Comparable<OptimisedVideoPreviewModel>{
   String v_id;
   String caption;
   String v_thumb;
   int t;
   int nL;
   int nC;
   int nS;
   int nV;
   String t_type;
   String v_category;
   String username;

   OptimisedVideoPreviewModel({
     this.v_id,
     @required this.caption,
     @required this.v_thumb,
     @required this.t,
     this.nL = 0,
     this.nC = 0,
     this.nS = 0,
     this.nV = 0,
     @required this.t_type,
     @required this.v_category,
     @required this.username,
});

   OptimisedVideoPreviewModel.fromJson(Map<dynamic, dynamic> json){

     this.v_id = json[VideosPreviewFieldNamesOptimised.v_id];
     this.caption = json[VideosPreviewFieldNamesOptimised.caption];
     this.v_thumb = json[VideosPreviewFieldNamesOptimised.v_thumb];
     this.t = json[VideosPreviewFieldNamesOptimised.t];
     this.nL = json[VideosPreviewFieldNamesOptimised.nL];
     this.nC = json[VideosPreviewFieldNamesOptimised.nC];
     this.nS = json[VideosPreviewFieldNamesOptimised.nS];
     this.nV = json[VideosPreviewFieldNamesOptimised.nV];
     this.t_type = json[VideosPreviewFieldNamesOptimised.t_type];
     this.v_category = json[VideosPreviewFieldNamesOptimised.v_category];
     this.username = json[VideosPreviewFieldNamesOptimised.username];

   }


   Map<dynamic, dynamic> toJson(){

     Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();

     data[VideosPreviewFieldNamesOptimised.v_id] = this.v_id;
     data[VideosPreviewFieldNamesOptimised.caption] = this.caption;
     data[VideosPreviewFieldNamesOptimised.v_thumb] = this.v_thumb;
     data[VideosPreviewFieldNamesOptimised.t] = this.t;
     data[VideosPreviewFieldNamesOptimised.nL] = this.nL;
     data[VideosPreviewFieldNamesOptimised.nC] = this.nC;
     data[VideosPreviewFieldNamesOptimised.nS] = this.nS;
     data[VideosPreviewFieldNamesOptimised.nV] = this.nV;
     data[VideosPreviewFieldNamesOptimised.t_type] = this.t_type;
     data[VideosPreviewFieldNamesOptimised.v_category] = this.v_category;
     data[VideosPreviewFieldNamesOptimised.username] = this.username;

     return data;
   }

   @override
   int compareTo(OptimisedVideoPreviewModel other) {


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
     if (this.v_id.compareTo(other.v_id) < 0){
       return 1;
     }
     else if(this.v_id.compareTo(other.v_id) > 0){
       return -1;
     }
     else{
       return 0;
     }


   }



}




