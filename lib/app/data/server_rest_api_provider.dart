import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/message_models/message_audio_model.dart';
import 'package:iris_social_network/services/models/message_models/message_image_model.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/services/models/message_models/message_video_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:iris_social_network/services/server_services/server_rest_api.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'dart:async';
import 'package:iris_social_network/services/server_services/server_rest_api.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;





class ServerRestApiProvider{


  static Future<bool> _deleteFileInServer({@required String urlPath})async{

    return await ServerRestApi().deleteFile(urlPath: urlPath);
  }


  static Future<bool> deleteAllFilesInModelData({@required dynamic dynamicModel})async{

    if (dynamicModel == null){
      return false;
    }


    if (dynamicModel is PostModel){

      PostModel postModel = dynamicModel as PostModel;

      if (postModel.postType == constants.PostType.video){
        VideoModel videoModel = VideoModel.fromJson(postModel.postData);

        _deleteFileInServer(urlPath: videoModel.videoUrl);
        _deleteFileInServer(urlPath: videoModel.videoImage);
        _deleteFileInServer(urlPath: videoModel.videoThumb);
      }
      else if (postModel.postType == constants.PostType.image){
        ImageModel imageModel = ImageModel.fromJson(postModel.postData);

        for (int index = 0; index < imageModel.imagesUrl.length; ++index){
          _deleteFileInServer(urlPath: imageModel.imagesUrl[index]);
        }
        for (int index = 0; index < imageModel.imagesThumbsUrl.length; ++index){
          _deleteFileInServer(urlPath: imageModel.imagesThumbsUrl[index]);
        }
      }
      else if (postModel.postType == constants.PostType.audio){
        AudioModel audioModel = AudioModel.fromJson(postModel.postData);

        _deleteFileInServer(urlPath: audioModel.audioUrl);
        _deleteFileInServer(urlPath: audioModel.audioImage);
        _deleteFileInServer(urlPath: audioModel.audioThumb);
      }

    }
    else if (dynamicModel is MessageModel){
      MessageModel messageModel = dynamicModel as MessageModel;

      if (messageModel.message_type == constants.MessageType.video){
        MessageVideoModel messageVideoModel = MessageVideoModel.fromJson(messageModel.message_data);


        _deleteFileInServer(urlPath: messageVideoModel.videoUrl);
        _deleteFileInServer(urlPath: messageVideoModel.videoImage);
        _deleteFileInServer(urlPath: messageVideoModel.videoThumb);
      }
      else if (messageModel.message_type == constants.MessageType.image){

        MessageImageModel messageImageModel = MessageImageModel.fromJson(messageModel.message_data);

        for (int index = 0; index < messageImageModel.imagesUrl.length; ++index){
          _deleteFileInServer(urlPath: messageImageModel.imagesUrl[index]);
        }
        for (int index = 0; index < messageImageModel.imagesThumbsUrl.length; ++index){
          _deleteFileInServer(urlPath: messageImageModel.imagesThumbsUrl[index]);
        }
      }else if (messageModel.message_type == constants.MessageType.audio){
        MessageAudioModel messageAudioModel = MessageAudioModel.fromJson(messageModel.message_data);

        _deleteFileInServer(urlPath: messageAudioModel.audioUrl);
        _deleteFileInServer(urlPath: messageAudioModel.audioImage);
        _deleteFileInServer(urlPath: messageAudioModel.audioThumb);
      }
    }

    return true;
  }

}