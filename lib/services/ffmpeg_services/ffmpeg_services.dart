import 'dart:io';
//import 'dart:ui';
import 'dart:typed_data';

//import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';




class FFmpegService{


  /*
  static Future<String> convertVideoFormat({@required String videoPath})async{

    //Directory srcDir = await getTemporaryDirectory();

    //String srcFilename = path.basename(videoPath);

    String desFilename = DateTime.now().microsecondsSinceEpoch.toString() + ".mkv";

    FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();

    int success = await flutterFFmpeg.executeWithArguments(["-i", videoPath, desFilename ]);

    if (success == 0){
      String outputPath = await flutterFFmpeg.getLastCommandOutput();
      return outputPath;
    }
    else{
      return null;
    }

  }
  */



  /*
  static Future<String> compressVideo({@required String videoPath, int videoWidth = 480})async{


    Directory desDir = await getExternalStorageDirectory();

    String desFilename = desDir.path + "/" + DateTime.now().microsecondsSinceEpoch.toString() + ".mkv";

    FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();


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

    if (permision == null && status == PermissionStatus.granted || permision[PermissionGroup.storage] == PermissionStatus.granted) {


      int success = await flutterFFmpeg.execute("-i,${videoPath},-vf,scale=${videoWidth}:-1,-c:v,mpeg4,${desFilename}", ",");

      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa      ${desFilename}");

      if (success == 0){
        return desFilename;
      }
      else{
        return null;
      }

    }


    return null;
  }
  */





  /*

  static Future<List<SplittedVideoModel>> getSplittedVideoParts({@required String videoPath, @required int videoTotalDuration, @required int trimmedVideoDuration})async{

    FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();


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

    
    if (permision == null && status == PermissionStatus.granted || permision[PermissionGroup.storage] == PermissionStatus.granted) {

      // if video total time is less than or equal to trimmed video time,
      // it returns a split video model with the original video path but no thumb
      if (videoTotalDuration <= trimmedVideoDuration){
        SplittedVideoModel splittedVideoModel = SplittedVideoModel(videoPath: videoPath, videoThumbPath: null);
        List<SplittedVideoModel> splittedVideoModelList = List<SplittedVideoModel>();
        splittedVideoModelList.add(splittedVideoModel);
        return splittedVideoModelList;
      }


      Directory desDir = await getExternalStorageDirectory();


      String desFilename = desDir.path + "/aaa/";
      Directory(desFilename).createSync();

      int numSplitVideos = (videoTotalDuration / trimmedVideoDuration).ceil();

      List<SplittedVideoModel> outputPathsList = List<SplittedVideoModel>(numSplitVideos);
      for (int index = 0; index < outputPathsList.length; ++index){

        outputPathsList[index] = SplittedVideoModel(videoPath: null, videoThumbPath: null);
        outputPathsList[index].videoPath = desFilename + "split_video_${index}.mkv";
      }

      String seperator = "<===@@@===>";
      String executionCommand= "-i" + seperator + "${videoPath}";



      // Execution command to split video into parts
      for (int i = 0, j = 0; i < outputPathsList.length; ++i, j += trimmedVideoDuration){

        if (i == 0){
          executionCommand += seperator + "-t" + seperator + "${trimmedVideoDuration}" +
              seperator + "-codec" + seperator + "copy" +
              seperator + "-y" + seperator +"${outputPathsList[i].videoPath}";
        }
        else{

          executionCommand += seperator + "-ss"+ seperator+ "${j}" +
              seperator + "-t" + seperator + "${trimmedVideoDuration}" +
              seperator + "-codec" + seperator + "copy" +
              seperator + "-y" + seperator + "${outputPathsList[i].videoPath}";
        }
      }


      //int success = await flutterFFmpeg.execute("-i input.mp4 -t 00:00:30 -c copy part1.mp4 -ss 00:00:30 -codec copy part2.mp4");
      int success = await flutterFFmpeg.execute(executionCommand, seperator);



      if (success == 0){

        // GEt thumbnail for splitted videos
        for (int index = 0; index < outputPathsList.length; ++index){

          Uint8List thumbUint8List = await FlutterVideoCompress().getThumbnail(outputPathsList[index].videoPath, quality: 75,);



          String imagePath = desFilename + "splitted_video_thumbnail_${index}.img";
          File imageFile = File(imagePath);
          imageFile.writeAsBytesSync(thumbUint8List);
          outputPathsList[index].videoThumbPath = imageFile.path;

        }

        return outputPathsList;
      }else{

        return null;
      }


    }


    return new List<SplittedVideoModel>();
  }

  */

}








class SplittedVideoModel{

  String videoPath;
  String videoThumbPath;

  SplittedVideoModel({
    @required this.videoPath,
    @required this.videoThumbPath
});

  File getVideoThumbFile(){

    File file = new File(this.videoThumbPath);

    return file;
  }

}


