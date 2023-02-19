package com.iris.socialnetwork;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.provider.ContactsContract;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;



public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {




  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);



    new MethodChannel(getFlutterView(), PlatformChannelConstants.contacts_channel).setMethodCallHandler(this);

  }


  @Override
  public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
    if (methodCall.method.equals(PlatformChannelMethods.get_contacts)){

      result.success(getContacts(this));

    }
    else {
      result.notImplemented();;
    }
  }









  // Get contacts from user address book
  public List<HashMap<String, String>> getContacts(Context ctx) {

    ArrayList<HashMap<String, String>> contactsList = new ArrayList<>();
    ContentResolver contentResolver = ctx.getContentResolver();
    Cursor cursor = contentResolver.query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);


    if (cursor != null){

      if (cursor.getCount() > 0) {
        while (cursor.moveToNext()) {
          String id = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts._ID));

          if (cursor.getInt(cursor.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER)) > 0) {

            Cursor cursorInfo = contentResolver.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,
                    ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = ?", new String[]{id}, null);

            if (cursorInfo != null){

              while (cursorInfo.moveToNext()) {

                HashMap<String, String> contactMap = new HashMap<String, String>();
                contactMap.put(ContactsDocumentFieldName.user_id, id);
                contactMap.put(ContactsDocumentFieldName.display_name, cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME)));
                contactMap.put(ContactsDocumentFieldName.phone_number, cursorInfo.getString(cursorInfo.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)));

                contactsList.add(contactMap);
              }

              cursorInfo.close();
            }
          }
        }
        cursor.close();
      }
    }

    return contactsList;
  }



}










class PlatformChannelConstants{

  private static String app_package_name = "com.iris.socialnetwork/";

  static  String contacts_channel = app_package_name + "contacts";
}


class PlatformChannelMethods{

  static String get_contacts = "get_contacts";
}





class ContactsDocumentFieldName{
  static final String user_id = "user_id";
  static final String display_name = "display_name";
  static final String phone_number = "phone_number";
  static final String thumb = "thumb";
}


