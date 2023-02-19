import 'package:iris_social_network/services/phone_service/phone_service.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/utils/string_utils.dart';





class PhoneNumberProvider {

  static List<String> _getPhoneCodes (){

    List<String> phoneCodes = new List<String>();
    for (Map<String, dynamic> countryMap in countriesList){
      phoneCodes.add(countryMap["phoneCode"]);
    }

    return phoneCodes;
  }



  static List<String> getPhoneNumberTrialsList({@required String phoneNumber}){

    List<String> phoneCodes = _getPhoneCodes();
    List<String> phoneTrials = new List<String>();



    for (String phoneCode in phoneCodes){

      for (String phoneFormat in _getPhoneNumberFormats(phoneNumber: phoneNumber, phoneCode: phoneCode)){

        phoneTrials.add(phoneFormat);
      }
    }

    return phoneTrials;
  }


  static List<String> _getPhoneNumberFormats({@required String phoneNumber, @required phoneCode}){


    String plus_character = "+";

    String firstForm = plus_character + phoneCode + StringUtils.removeAllSpaces(phoneNumber); 
    String secondForm = StringUtils.removeAllSpaces(phoneNumber);
    String thirdForm = plus_character + StringUtils.removeAllSpaces(phoneNumber);

    return [firstForm, secondForm, thirdForm];
  }





}










