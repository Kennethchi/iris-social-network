import 'dart:async';
import 'package:iris_social_network/utils/string_utils.dart';


mixin AccountSetupValidators {


  StreamTransformer<String, String> profileNameTransformer = new StreamTransformer<String, String>.fromHandlers(
      handleData: (profileName, sink){
        String transformedProfileName = StringUtils.toUpperCaseLower(profileName.trim());

        sink.add(transformedProfileName);
      }
  );




  StreamTransformer<String, String> userNameTransformer = new StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink){

        String cleaned_username = StringUtils.removeAllSpaces(username).toLowerCase();

        RegExp regExp = new RegExp(r"^[A-Za-z0-9_]+$");

        if (regExp.hasMatch(cleaned_username)){
          sink.add(cleaned_username);
        }
        else{
          sink.add(null);
        }

      }
  );


}











