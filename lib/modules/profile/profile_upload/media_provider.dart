import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';




class MediaProvider{



  static Future<MediaInfo> getMediaInfo({@required String mediaPath})async{

    return await FlutterVideoCompress().getMediaInfo(mediaPath);
  }

  static Future<String> compressVideo({@required String videoPath})async{

    FlutterVideoCompress flutterVideoCompress = FlutterVideoCompress();

    MediaInfo mediaInfo = await flutterVideoCompress.compressVideo(videoPath, quality: VideoQuality.MediumQuality);

    return mediaInfo.path;
    //return await FFmpegService.compressVideo(videoPath: videoPath, videoWidth: 480);
  }



  static Future<String> getVideoThumbnail({@required File videoFile, @required int quality}) async{


    /*
    if (Platform.isAndroid){

      PermissionStatus status =  await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

      Map<PermissionGroup, PermissionStatus> permision;

      switch(status){
        case PermissionStatus.denied:
          permision = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
          break;
        case PermissionStatus.disabled:
          permision = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
          break;
        case PermissionStatus.granted:
          break;
        case PermissionStatus.restricted:
          permision = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
          break;
        case PermissionStatus.unknown:
          permision = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
          break;
      }

      if (permision == null && status == PermissionStatus.granted || permision[PermissionGroup.storage] == PermissionStatus.granted){
        //Directory tempDir = await getTemporaryDirectory();
        //String pathTemp = tempDir.path + "/" + DateTime.now().microsecondsSinceEpoch.toString() + "/.jpg";

        String path = await Thumbnails.getThumbnail(
            videoFile: videoFile.path,
            //thumbnailFolder: pathTemp,
            imageType: ThumbFormat.JPEG,
            quality: quality
        );

        return path;
      }

      return null;
    }
    else{
      throw Exception("Thumbnails package is only applicable on Android");
    }

    */


    return (await FlutterVideoCompress().getThumbnailWithFile(videoFile.path, quality: quality)).path;
  }

}