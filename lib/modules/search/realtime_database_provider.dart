import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_user_model.dart';



class RealtimeDatabaseProvider{


  static Future<OptimisedUserModel> searchUser({@required String searchUser})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.users)
        .orderByKey()
        .equalTo(searchUser.toLowerCase())
        .limitToLast(1)
        .once();


    if (dataSnapshot.value == null){
      return null;
    }
    else{
      return await OptimisedUserModel.fromJson(json: dataSnapshot.value);
    }
  }


}