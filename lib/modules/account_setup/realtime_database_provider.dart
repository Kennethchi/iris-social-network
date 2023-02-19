import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_database_strings.dart';
import 'package:iris_social_network/services/optimised_models/optimised_user_model.dart';



class RealtimeDatabaseProvider{


  static Future<bool> checkUsernameIsTaken({@required String userNameTrial})async{

    DataSnapshot dataSnapshots = await FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.users)
        .orderByChild(UsersFieldNamesOptimised.username)
        .equalTo(userNameTrial)
        .limitToLast(1)
        .once();

    if (dataSnapshots.value == null){
      return false;
    }
    else{
      return true;
    }

  }



  static Future<void> addOptimisedUserData({@required OptimisedUserModel optimisedUserModel, @required String userId}) async{

    await FirebaseDatabase.instance.reference().child(RootReferenceNames.users).child(userId).set(optimisedUserModel.toJson());
  }



  static Future<void> addChatsData({@required OptimisedChatModel chatUserChatterModel, @required OptimisedChatModel currentUserChatterModel})async{

    FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(currentUserChatterModel.chat_user_id)
        .child(chatUserChatterModel.chat_user_id)
        .set(chatUserChatterModel.toJson());

    FirebaseDatabase.instance.reference()
        .child(RootReferenceNames.private_chats)
        .child(chatUserChatterModel.chat_user_id)
        .child(currentUserChatterModel.chat_user_id)
        .set(currentUserChatterModel.toJson());

  }


}