import 'dart:async';
import 'package:iris_social_network/utils/string_utils.dart';

mixin AuthValidators{

  static RegExp regExp = RegExp(r"/^[0-9]*$/");



  var phoneNumberValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (phoneNumber, sink){

      // checks if phone number input is an integer and number is greater than 3
      if (int.tryParse(phoneNumber) != null && phoneNumber.length > 3){

        sink.add(phoneNumber);

      }
      else{
        sink.addError("Invalid Phone Number");
      }

    }
  );


}