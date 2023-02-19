import 'package:iris_social_network/services/optimised_models/optimised_comment_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:firebase_database/firebase_database.dart';



class RealtimeDatabaseProvider{


  static Future<void> sendFeedBack({@required String feedback})async{
    await FirebaseDatabase.instance.reference().child(RootReferenceNames.feedbacks).push().set(feedback);
  }

  static Future<void> sendBugReport({@required String bugReport})async{
    await FirebaseDatabase.instance.reference().child(RootReferenceNames.bug_reports).push().set(bugReport);
  }

}