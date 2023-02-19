import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';




class MediaProvider{

  static Future<File> getVideoThumbNailFile({@required File videoFile})async{

    return await FlutterVideoCompress().getThumbnailWithFile(videoFile.path, quality: 100);
  }

  static Future<MediaInfo> getMediaInfo({@required String mediaPath})async{

    return await FlutterVideoCompress().getMediaInfo(mediaPath);
  }

  static Future<File> compressVideo({@required String videoPath})async{

    FlutterVideoCompress flutterVideoCompress = FlutterVideoCompress();

    MediaInfo mediaInfo = await flutterVideoCompress.compressVideo(videoPath, quality: VideoQuality.MediumQuality);

    return mediaInfo.file;
  }

}