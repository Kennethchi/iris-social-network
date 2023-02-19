import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'dart:core';




final DynamicLinkParameters parameters = DynamicLinkParameters(
  uriPrefix: 'https://abc123.app.goo.gl',
  link: Uri.parse('https://example.com/'),
  androidParameters: AndroidParameters(
    packageName: 'com.example.android',
    minimumVersion: 16,
  ),
  iosParameters: IosParameters(
    bundleId: 'com.example.ios',
    minimumVersion: '1.0.1',
    appStoreId: '123456789',
  ),
  googleAnalyticsParameters: GoogleAnalyticsParameters(
    campaign: 'example-promo',
    medium: 'social',
    source: 'orkut',
  ),
  itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
    providerToken: '123456',
    campaignToken: 'example-promo',
  ),
  socialMetaTagParameters:  SocialMetaTagParameters(
    title: 'Example of a Dynamic Link',
    description: 'This link works whether app is installed or not!',
  ),
  navigationInfoParameters: NavigationInfoParameters()
);






Future<String> getDynamicLinkWithPostIdAndPostUserId({@required String postId, @required String postUserId})async{


  Map<String, dynamic> map = Map<String,dynamic> ();
  map.putIfAbsent(DYNAMIC_LINK_POST_ID_KEY, ()=> postId);
  map.putIfAbsent(DYNAMIC_LINK_POST_USER_ID_KEY, ()=> postUserId);

  String jsonEncodedMap = jsonEncode(map);

  /*
  String link = "https://irisnetwork.page.link/?link=https://www.iris.com?"
      + "${DYNAMIC_LINK_POST_ID_KEY}=${postId}"
      + "&" + "${DYNAMIC_LINK_POST_USER_ID_KEY}=${postUserId}"
      + "&apn=${_app_package_name}";
      */

  String link = "https://irisnetwork.page.link/?link=https://www.iris.com?"
      + "${DYNAMIC_LINK_POST_DATA_MAP_KEY}=${jsonEncodedMap}"
      + "&apn=${_app_package_name}";

  String encodedLink = Uri.encodeFull(link);

  ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
    Uri.parse(encodedLink),
    DynamicLinkParametersOptions(),
  );

  Uri shortUrl = shortenedLink.shortUrl;

  print(shortUrl.toString());

  return shortUrl.toString();
}



Future<String> getDynamicLinkWithUserInviteData({@required String userId, @required  int earnPoints})async{

  String inviteTitle = "Iris (A New Social Network)";
  String inviteDescription = "Come join me on Iris lets chat and have some Fun."
      + " Iris is a social platform where users come and express their passion and share the moment with their friends, family, and their audience."
      + " You will also get to earn Reward points for the activities you carry out on the App and unlock new Features."
      + " You will earn ${earnPoints} Reward Points when you download the app and signup through this Link";

  Map<String, dynamic> map = Map<String,dynamic> ();
  map.putIfAbsent(DYNAMIC_LINK_INVITE_USER_ID_KEY, ()=> userId);

  String jsonEncodedMap = jsonEncode(map);

  String link = "https://irisnetwork.page.link/?link=https://www.iris.com?"
      + "${DYNAMIC_LINK_INVITE_DATA_MAP_KEY}=${jsonEncodedMap}"
      + "&st=${inviteTitle}"
      + "&sd=${inviteDescription}"
      + "&apn=${_app_package_name}";

  String encodedLink = Uri.encodeFull(link);

  ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
    Uri.parse(encodedLink),
    DynamicLinkParametersOptions(),
  );

  Uri shortUrl = shortenedLink.shortUrl;

  print(shortUrl.toString());

  return shortUrl.toString();
}





const String app_dynamic_link = "https://irisnetwork.page.link/?link=https://www.iris.com&apn=com.iris.socialnetwork";

const String app_dynamic_short_link = "https://irisnetwork.page.link/tqgE";

const String _app_package_name = "com.iris.socialnetwork";


String DYNAMIC_LINK_POST_DATA_MAP_KEY = "post_data";
String DYNAMIC_LINK_POST_ID_KEY = "post_id";
String DYNAMIC_LINK_POST_USER_ID_KEY = "post_user_id";


String DYNAMIC_LINK_INVITE_DATA_MAP_KEY = "invite_data";
String DYNAMIC_LINK_INVITE_USER_ID_KEY = "invite_user_id";



const String app_package_google_playstore_link = "https://play.google.com/store/apps/details?id=com.iris.socialnetwork";