import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


class AssetsAudioPickerHandlers{

  Future<File> generateFileFromAssets({@required BuildContext context, @required assetPath})async{


    Directory directory = await getTemporaryDirectory();
    String filePath = directory.path + "/" + "${DateTime.now().microsecondsSinceEpoch}";

    File file = File(filePath);

    ByteData byteData = await DefaultAssetBundle.of(context).load(assetPath);

    final buffer = byteData.buffer;
    return await File(filePath).writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  }

}