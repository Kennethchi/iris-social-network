import 'dart:async';
import 'package:iris_social_network/utils/string_utils.dart';


mixin PrivateChatValidators{


  StreamTransformer<String, String> textValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (text, sink){

        String cleanedText = StringUtils.cleanTextSpaces(text);

        if (cleanedText.length > 0){
          sink.add(cleanedText);
        }
        else{
          sink.addError("Message needs CLeaning");
        }


  });





}