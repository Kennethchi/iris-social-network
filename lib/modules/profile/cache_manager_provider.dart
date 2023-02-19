import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';


class CacheManagerProvider{


  static Future<File> getCachedNetworkFile({@required String urlPath})async{

    DefaultCacheManager defaultCacheManager = DefaultCacheManager();

    return await defaultCacheManager.getSingleFile(urlPath);
  }

}