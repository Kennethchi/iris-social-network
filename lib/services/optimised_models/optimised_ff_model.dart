import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:meta/meta.dart';



class OptimisedFFModel implements Comparable<OptimisedFFModel>{

  String id;


   String name;
   String username;
   String user_id;
   String thumb;
   int t;
   bool v_user;

   OptimisedFFModel({
     this.name,
     this.username,
     @required this.user_id,
     this.thumb,
     @required this.t,
     this.v_user
});


   OptimisedFFModel.fromJson(Map<dynamic, dynamic> json){

     this.name = json[FFFieldNamesOptimised.name];
     this.username = json[FFFieldNamesOptimised.username];
     this.user_id = json[FFFieldNamesOptimised.user_id];
     this.thumb = json[FFFieldNamesOptimised.thumb];
     this.t = json[FFFieldNamesOptimised.t];
     this.v_user = json[FFFieldNamesOptimised.v_user];
   }


   Map<dynamic, dynamic> toJson(){

     Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();


     data[FFFieldNamesOptimised.name] = this.name;
     data[FFFieldNamesOptimised.username] = this.username;
     data[FFFieldNamesOptimised.user_id] = this.user_id;
     data[FFFieldNamesOptimised.thumb] = this.thumb;
     data[FFFieldNamesOptimised.t] = this.t;
     data[FFFieldNamesOptimised.v_user] = this.v_user;

     return data;
   }





   @override
   int compareTo(OptimisedFFModel other) {
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


   /*
  @override
  int compareTo(OptimisedFFModel other) {
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
  */

}

