//import 'package:iris_social_network/services/platform_channels/phone_contacts.dart';

import 'package:iris_social_network/services/contact_service/contact_service.dart';
import 'package:iris_social_network/services/models/contact_model.dart';



class ConstactsProvider{

  static Future<List<ContactModel>> getContactsFromMobile() async{

    return await ContactService.getContacts();
  }


}