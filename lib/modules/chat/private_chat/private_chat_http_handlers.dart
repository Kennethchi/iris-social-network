



import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat_bloc.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat_bloc_provider.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/models/message_models/message_audio_model.dart';
import 'package:iris_social_network/services/models/message_models/message_image_model.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/services/models/message_models/message_video_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/utils/image_utils.dart';




class PrivateChatHttpHandlers{


  static Future<void> publishMessageImageData({@required BuildContext chatContext, @required MessageModel messageModelPlaceholder})async{

    MessageImageModel messageImageModelPlaceholder = MessageImageModel.fromJson(messageModelPlaceholder.message_data);


    PrivateChatBlocProvider _provider = PrivateChatBlocProvider.of(chatContext);
    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(chatContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(chatContext);
    double screenWidth = MediaQuery.of(chatContext).size.width;
    double screenHeight = MediaQuery.of(chatContext).size.height;
    double scaleFactor = 0.125;


    if (messageImageModelPlaceholder.imagesUrl != null && messageImageModelPlaceholder.imagesUrl.length > 0){

      List<String> messageImagesUrlList = List<String>();
      List<String> messageImagesThumbsUrlList = List<String>();

      bool uploadError = false;

      for (int index = 0; index < messageImageModelPlaceholder.imagesUrl.length; ++index){

        File imageFile = File(messageImageModelPlaceholder.imagesUrl[index]);

        File imageThumbFile = await ImageUtils.getCompressedImageFile(
            imageFile: imageFile,
            maxWidth: ImageOptions.maxWidthMedium,
            quality: ImageOptions.qualityLow
        );


        FileModel imageFileModel = await _bloc.uploadFile(
            sourceFile: imageFile,
            filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            progressSink: _bloc.getProgressTransferDataSink,
            totalSink: _bloc.getTotalTransferDataSink
        );

        //_bloc.addPercentRatioProgress(0.0);

        FileModel imageThumbFileModel = await _bloc.uploadFile(
            sourceFile: imageThumbFile,
            filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            progressSink: _bloc.getProgressTransferDataSink,
            totalSink: _bloc.getTotalTransferDataSink
        );


        if (imageFileModel == null || imageThumbFileModel == null){
          BasicUI.showSnackBar(context: chatContext, message: "An error occured during upload", textColor: Colors.red);

          uploadError = true;
          break;
        }
        else{

          messageImagesUrlList.add(imageFileModel.fileUrl);
          messageImagesThumbsUrlList.add(imageThumbFileModel.fileUrl);
        }

      }


      if (uploadError){

        BasicUI.showSnackBar(context: chatContext, message: "An error occured during upload", textColor: Colors.red);
        return;
      }
      else{

        // get current user data
        UserModel currentUserModel = await AppBlocProvider.of(chatContext).bloc.getAllCurrentUserData(
            currentUserId: AppBlocProvider.of(chatContext).bloc.getCurrentUserId
        );



        MessageImageModel messageImageModel = MessageImageModel(
          imagesUrl: messageImagesUrlList,
          imagesThumbsUrl: messageImagesThumbsUrlList
        );

        MessageModel messageModel = MessageModel(
            message_text: messageModelPlaceholder.message_text != null? messageModelPlaceholder.message_text: "",
            message_type: messageModelPlaceholder.message_type,
            sender_id: currentUserModel.userId,
            receiver_id: _bloc.getChatUserModel.userId,
            timestamp: Timestamp.now(),
            seen: false,
            message_data: messageImageModel.toJson(),
            downloadable: messageModelPlaceholder.downloadable
        );


          // For chat user receving the message, the current user info is found also here
          OptimisedChatModel chatUserChattersModel = OptimisedChatModel(
              chat_user_id: currentUserModel.userId,
              sender_id: currentUserModel.userId,
              t: Timestamp.now().millisecondsSinceEpoch,
              text: messageModelPlaceholder.message_text != null? messageModelPlaceholder.message_text: "",
              seen: false,
              tp: false,
              msg_type: messageModelPlaceholder.message_type,
          );


          // For The current user sending the message, the chat user info is found also here
          OptimisedChatModel currentUserChattersModel = OptimisedChatModel(
              chat_user_id: _bloc.getChatUserModel.userId,
              sender_id: currentUserModel.userId,
              t: Timestamp.now().millisecondsSinceEpoch,
              text: messageModelPlaceholder.message_text != null? messageModelPlaceholder.message_text: "",
              seen: false,
              tp: false,
              msg_type: messageModelPlaceholder.message_type,
          );


          // add messageData to firestore for both users
        _bloc.addMessageData(
            messageModel: messageModel,
            currentUserId: currentUserModel.userId,
            chatUserId: _bloc.getChatUserModel.userId
        ).then((String messageId){

          if (messageId != null){
            _bloc.setCurrentUserSentMessageState(
                messageState: MessageState.sent, messageId: messageId, currentUserId: currentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId
            );
          }
        });


        _bloc.addChatsData(chatUserChatterModel: chatUserChattersModel, currentUserChatterModel: currentUserChattersModel);


        // send message notification here


        // delete cache for flutter video compress library
        FlutterVideoCompress().deleteAllCache();

        _provider.scrollController.jumpTo(_provider.scrollController.position.minScrollExtent);
      }
    }
    else{

      BasicUI.showSnackBar(context: chatContext, message: "No images were Selected", textColor: Colors.red);
    }


  }









  static Future<void> publishMessageAudioData({@required BuildContext chatContext, @required MessageModel messageModelPlaceholder})async{

    MessageAudioModel messageAudioModelPlaceholder = MessageAudioModel.fromJson(messageModelPlaceholder.message_data);


    PrivateChatBlocProvider _provider = PrivateChatBlocProvider.of(chatContext);
    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(chatContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(chatContext);
    double screenWidth = MediaQuery.of(chatContext).size.width;
    double screenHeight = MediaQuery.of(chatContext).size.height;
    double scaleFactor = 0.125;


    if (messageAudioModelPlaceholder.audioUrl != null){

      File audioFile = File(messageAudioModelPlaceholder.audioUrl);
      File imageFile;
      File imageThumbFile;

      FileModel imageFileModel;
      FileModel imageThumbFileModel;

      if (messageAudioModelPlaceholder.audioImage != null){

        imageFile = File(messageAudioModelPlaceholder.audioImage);

        imageThumbFile = await ImageUtils.getCompressedImageFile(
            imageFile: imageFile,
            maxWidth: ImageOptions.maxWidthMedium,
            quality: ImageOptions.qualityLow
        );


        // audio image file model
        imageFileModel = await _bloc.uploadFile(
            sourceFile: imageFile,
            filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            progressSink: _bloc.getProgressTransferDataSink,
            totalSink: _bloc.getTotalTransferDataSink
        );

        // audio image thumb file model
        imageThumbFileModel = await _bloc.uploadFile(
            sourceFile: imageThumbFile,
            filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            progressSink: _bloc.getProgressTransferDataSink,
            totalSink: _bloc.getTotalTransferDataSink
        );

      }


      // audio file model
      FileModel audioFileModel = await _bloc.uploadFile(
          sourceFile: audioFile,
          filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.mp3,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );



      if (audioFileModel == null
          || (messageAudioModelPlaceholder.audioImage != null && imageFileModel == null)
          || (messageAudioModelPlaceholder.audioImage != null && imageThumbFileModel == null)){
        BasicUI.showSnackBar(context: chatContext, message: "An error occured during upload", textColor: Colors.red);

        return;
      }
      else{

        // get current user data
        UserModel currentUserModel = await AppBlocProvider.of(chatContext).bloc.getAllCurrentUserData(
            currentUserId: AppBlocProvider.of(chatContext).bloc.getCurrentUserId
        );

        MessageAudioModel messageAudioModel = MessageAudioModel(
            audioUrl: audioFileModel.fileUrl,
            audioImage: imageFileModel != null? imageFileModel.fileUrl: null,
            audioThumb: imageThumbFileModel != null? imageThumbFileModel.fileUrl: null,
            duration: messageAudioModelPlaceholder.duration
        );

        MessageModel messageModel = MessageModel(
            message_text: messageModelPlaceholder.message_text != null? messageModelPlaceholder.message_text: "",
            message_type: messageModelPlaceholder.message_type,
            sender_id: currentUserModel.userId,
            receiver_id: _bloc.getChatUserModel.userId,
            timestamp: Timestamp.now(),
            seen: false,
            message_data: messageAudioModel.toJson(),
            downloadable: messageModelPlaceholder.downloadable
        );


        // For chat user receving the message, the current user info is found also here
        OptimisedChatModel chatUserChattersModel = OptimisedChatModel(
          chat_user_id: currentUserModel.userId,
          sender_id: currentUserModel.userId,
          t: Timestamp.now().millisecondsSinceEpoch,
          text: messageModelPlaceholder.message_text != null? messageModelPlaceholder.message_text: "",
          seen: false,
          tp: false,
          msg_type: messageModelPlaceholder.message_type,
        );


        // For The current user sending the message, the chat user info is found also here
        OptimisedChatModel currentUserChattersModel = OptimisedChatModel(
          chat_user_id: _bloc.getChatUserModel.userId,
          sender_id: currentUserModel.userId,
          t: Timestamp.now().millisecondsSinceEpoch,
          text: messageModelPlaceholder.message_text != null? messageModelPlaceholder.message_text: "",
          seen: false,
          tp: false,
          msg_type: messageModelPlaceholder.message_type,
        );


        // add messageData to firestore for both users
        _bloc.addMessageData(
            messageModel: messageModel,
            currentUserId: currentUserModel.userId,
            chatUserId: _bloc.getChatUserModel.userId
        ).then((String messageId){

          if (messageId != null){
            _bloc.setCurrentUserSentMessageState(
                messageState: MessageState.sent, messageId: messageId, currentUserId: currentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId
            );
          }
        });


        _bloc.addChatsData(chatUserChatterModel: chatUserChattersModel, currentUserChatterModel: currentUserChattersModel);


        // send message notification here


        // delete cache for flutter video compress library
        FlutterVideoCompress().deleteAllCache();

        _provider.scrollController.jumpTo(_provider.scrollController.position.minScrollExtent);
      }
    }
    else{

      BasicUI.showSnackBar(context: chatContext, message: "No images were Selected", textColor: Colors.red);
    }


  }





  static Future<void> publishMessageVideoData({@required BuildContext chatContext, @required MessageModel messageModelPlaceholder})async{

    MessageVideoModel messageVideoModelPlaceholder = MessageVideoModel.fromJson(messageModelPlaceholder.message_data);


    PrivateChatBlocProvider _provider = PrivateChatBlocProvider.of(chatContext);
    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(chatContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(chatContext);
    double screenWidth = MediaQuery.of(chatContext).size.width;
    double screenHeight = MediaQuery.of(chatContext).size.height;
    double scaleFactor = 0.125;


    if (messageVideoModelPlaceholder.videoUrl != null && messageVideoModelPlaceholder.videoImage != null){

      //File compressedVideoFile = await _bloc.compressVideo(videoPath: messageVideoModelPlaceholder.videoUrl);

      File videoFile = File(messageVideoModelPlaceholder.videoUrl);

      File imageFile = await ImageUtils.getCompressedImageFile(
          imageFile: File(messageVideoModelPlaceholder.videoImage),
          maxWidth: ImageOptions.maxWidthHigh ,
          quality: ImageOptions.qualityHigh
      );

      File imageThumbFile = await ImageUtils.getCompressedImageFile(
          imageFile: imageFile,
          maxWidth: ImageOptions.maxWidthMedium,
          quality: ImageOptions.qualityLow
      );


      // video file model
      FileModel videoFileModel = await _bloc.uploadFile(
          sourceFile: videoFile,
          filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.mp4,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );

      // video image file model
      FileModel imageFileModel = await _bloc.uploadFile(
          sourceFile: imageFile,
          filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );


      // video image thumb file model
      FileModel imageThumbFileModel = await _bloc.uploadFile(
          sourceFile: imageThumbFile,
          filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );


      if (videoFileModel == null || imageFileModel == null || imageThumbFileModel == null){
        BasicUI.showSnackBar(context: chatContext, message: "An error occured during upload", textColor: Colors.red);

        return;
      }
      else{

        // get current user data
        UserModel currentUserModel = await AppBlocProvider.of(chatContext).bloc.getAllCurrentUserData(
            currentUserId: AppBlocProvider.of(chatContext).bloc.getCurrentUserId
        );

        MessageVideoModel messageVideoModel = MessageVideoModel(
            videoImage: imageFileModel.fileUrl,
            videoThumb: imageThumbFileModel.fileUrl,
            videoUrl: videoFileModel.fileUrl,
            duration: messageVideoModelPlaceholder.duration
        );

        MessageModel messageModel = MessageModel(
            message_text: messageModelPlaceholder.message_text != null? messageModelPlaceholder.message_text: "",
            message_type: messageModelPlaceholder.message_type,
            sender_id: currentUserModel.userId,
            receiver_id: _bloc.getChatUserModel.userId,
            timestamp: Timestamp.now(),
            seen: false,
            message_data: messageVideoModel.toJson(),
            downloadable: messageModelPlaceholder.downloadable
        );


        // For chat user receving the message, the current user info is found also here
        OptimisedChatModel chatUserChattersModel = OptimisedChatModel(
          chat_user_id: currentUserModel.userId,
          sender_id: currentUserModel.userId,
          t: Timestamp.now().millisecondsSinceEpoch,
          text: messageModelPlaceholder.message_text != null? messageModelPlaceholder.message_text: "",
          seen: false,
          tp: false,
          msg_type: messageModelPlaceholder.message_type,
        );


        // For The current user sending the message, the chat user info is found also here
        OptimisedChatModel currentUserChattersModel = OptimisedChatModel(
          chat_user_id: _bloc.getChatUserModel.userId,
          sender_id: currentUserModel.userId,
          t: Timestamp.now().millisecondsSinceEpoch,
          text: messageModelPlaceholder.message_text != null? messageModelPlaceholder.message_text: "",
          seen: false,
          tp: false,
          msg_type: messageModelPlaceholder.message_type,
        );


        // add messageData to firestore for both users
        _bloc.addMessageData(
            messageModel: messageModel,
            currentUserId: currentUserModel.userId,
            chatUserId: _bloc.getChatUserModel.userId
        ).then((String messageId){

          if (messageId != null){
            _bloc.setCurrentUserSentMessageState(
                messageState: MessageState.sent, messageId: messageId, currentUserId: currentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId
            );
          }
        });


        _bloc.addChatsData(chatUserChatterModel: chatUserChattersModel, currentUserChatterModel: currentUserChattersModel);


        // send message notification here


        // delete cache for flutter video compress library
        FlutterVideoCompress().deleteAllCache();

        _provider.scrollController.jumpTo(_provider.scrollController.position.minScrollExtent);
      }
    }
    else{

      BasicUI.showSnackBar(context: chatContext, message: "No images were Selected", textColor: Colors.red);
    }


  }



}


