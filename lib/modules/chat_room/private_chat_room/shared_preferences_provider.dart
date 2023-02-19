import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/contact_model.dart';


class SharedPreferencesProvider{

  static Future<List<String>> getPhoneNumberListFromSharedPrefs() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(SharedPrefsKeys.phone_number_list);
  }



  // Stores phone numbers
  static Future<List<ContactModel>> savePhoneNumbersToSharedPrefs({@required List<ContactModel> contacts}) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    //print(contacts.length);

    List<String> storedPhoneNumberList = prefs.getStringList(SharedPrefsKeys.phone_number_list);
    List<ContactModel> contactsToStore = new List<ContactModel>();

    if (storedPhoneNumberList == null){
      storedPhoneNumberList = new List<String>();
    }

    for (ContactModel contact in contacts){

      if(storedPhoneNumberList.contains(contact.phoneNumber)){
        continue;
      }
      else{
        storedPhoneNumberList.add(contact.phoneNumber);
        contactsToStore.add(contact);
      }


    }

    await prefs.setStringList(SharedPrefsKeys.phone_number_list, storedPhoneNumberList);

    return contacts;
    //return contacts;
  }


}









