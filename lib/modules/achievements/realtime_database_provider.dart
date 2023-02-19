import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';



class RealtimeDatabaseProvider{

  static Future<int> getTotalAchievedPoints({@required String userId})async{

    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child(RootReferenceNames.users)
        .child(userId)
        .child(UsersFieldNamesOptimised.pts).once();

    if (dataSnapshot != null && dataSnapshot.value != null){

      if (dataSnapshot.value < 0){
        return 0;
      }
      else{
        return dataSnapshot.value;
      }
    }

    return null;
  }


}