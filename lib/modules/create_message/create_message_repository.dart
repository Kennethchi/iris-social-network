import 'dart:async';
import 'dart:io';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:meta/meta.dart';


abstract class CreateMessageRepository{


  Future<File> getVideoThumbNailFile({@required File videoFile});

  Future<MediaInfo> getMediaInfo({@required String mediaPath});

  Future<File> compressVideo({@required String videoPath});
}