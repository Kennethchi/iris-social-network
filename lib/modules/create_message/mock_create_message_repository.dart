import 'dart:async';
import 'dart:io';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:meta/meta.dart';

import 'create_message_repository.dart';


class MockCreateMessageRepository extends CreateMessageRepository{


  @override
  Future<File> getVideoThumbNailFile({@required File videoFile})async {

  }

  @override
  Future<File> compressVideo({@required String videoPath})async {

  }

  @override
  Future<MediaInfo> getMediaInfo({@required String mediaPath}) async {

  }
}