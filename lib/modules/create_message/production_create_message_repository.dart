import 'dart:async';
import 'dart:io';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:meta/meta.dart';
import 'create_message_repository.dart';
import 'media_provider.dart';


class ProductionCreateMessageRepository extends CreateMessageRepository{

  @override
  Future<File> getVideoThumbNailFile({@required File videoFile})async {
    return await MediaProvider.getVideoThumbNailFile(videoFile: videoFile);
  }

  @override
  Future<File> compressVideo({@required String videoPath})async {

    return await MediaProvider.compressVideo(videoPath: videoPath);
  }

  @override
  Future<MediaInfo> getMediaInfo({@required String mediaPath})async {

    return await MediaProvider.getMediaInfo(mediaPath: mediaPath);
  }
}