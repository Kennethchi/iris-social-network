import 'dart:ui';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat_http_handlers.dart';
import 'package:iris_social_network/modules/create_message/create_message.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'package:iris_social_network/services/models/message_models/message_audio_model.dart';
import 'package:iris_social_network/services/models/message_models/message_image_model.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/services/models/message_models/message_video_model.dart';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'package:iris_social_network/widgets/audio_viewer/audio_viewer.dart';
import 'package:iris_social_network/widgets/avatar_image_generator/avatar_image_generator.dart';
import 'package:iris_social_network/widgets/image_viewer/image_viewer.dart';
import 'package:iris_social_network/widgets/video_viewer/video_viewer.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';
import 'private_chat_bloc_provider.dart';
import 'private_chat_bloc.dart';
import 'package:iris_social_network/services/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:iris_social_network/widgets/paint_board/paint_board.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:iris_social_network/utils/image_utils.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'private_chat_views_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iris_social_network/widgets/option_menu/option_menu.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'private_chat_views.dart';


class PrivateChatViewsHandlers{


  // When the text in text field change. we set the current user istyping value based on whether the field is empty or not
  void onTextChange({@required BuildContext context, @required String text}){

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;

    _bloc.addTextToStream(text: text);

    if (text.trim().length > 0){
      _bloc.addCurrentUserTypingStatus(currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId, isTyping: true);
    }
    else{
      _bloc.addCurrentUserTypingStatus(currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId, isTyping: false);
    }


  }



  Future<void> sendMessageText({@required BuildContext context, @required String cleanedMessage}) async{

    PrivateChatBlocProvider _provider = PrivateChatBlocProvider.of(context);
    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    TextEditingController textEditingController = PrivateChatBlocProvider.of(context).textEditingController;


    MessageModel newMessageModel = MessageModel(
      message_text: cleanedMessage,
      sender_id: _bloc.getCurrentUserModel.userId,
      receiver_id: _bloc.getChatUserModel.userId,
      seen: false,
      timestamp: Timestamp.now(),
      message_type: MessageType.text,
      message_data: null,
      downloadable: null,
      referred_message: _bloc.getReferredMessageModel != null? _bloc.getReferredMessageModel.toJson(): null
    );


    // For chat user receving the message, the current user info is found also here
    OptimisedChatModel chatUserChattersModel = OptimisedChatModel(
      chat_user_id: _bloc.getCurrentUserModel.userId,
      sender_id: _bloc.getCurrentUserModel.userId,
      t: Timestamp.now().millisecondsSinceEpoch,
      text: cleanedMessage,
      seen: false,
      tp: false,
      msg_type: MessageType.text,
    );


    // For The current user sending the message, the chat user info is found also here
    OptimisedChatModel currentUserChattersModel = OptimisedChatModel(
      chat_user_id: _bloc.getChatUserModel.userId,
      sender_id: _bloc.getCurrentUserModel.userId,
      t: Timestamp.now().millisecondsSinceEpoch,
      text: cleanedMessage,
      seen: false,
      tp: false,
      msg_type: MessageType.text,
    );


    // add message to firestore and chats to realtime database and notification to chatUser notifications in realtime database
    _bloc.addMessageData(messageModel: newMessageModel, currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId).then((String messageId){

      if (messageId != null){
        _bloc.setCurrentUserSentMessageState(
            messageState: MessageState.sent, messageId: messageId, currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId
        );
      }
    });


    _bloc.addNotificationData(
      chatUserId: _bloc.getChatUserModel.userId,
      optimisedNotificationModel: OptimisedNotificationModel(
        from: _bloc.getCurrentUserModel.userId,
        n_type: NotificationType.msg,
        t: Timestamp.now().millisecondsSinceEpoch
      ),
    );

    _bloc.addChatsData(chatUserChatterModel: chatUserChattersModel, currentUserChatterModel: currentUserChattersModel);


    // clears textfield
    textEditingController.clear();

    // when text controller is cleared, set istyping to 0
    _bloc.addCurrentUserTypingStatus(currentUserId: _bloc.getCurrentUserModel.userId, chatUserId: _bloc.getChatUserModel.userId, isTyping: false);

    // adds null text to stream after text being sent
    _bloc.addTextToStream(text: null);

    _provider.scrollController.jumpTo(_provider.scrollController.position.minScrollExtent);

    _bloc.addReferredMessageModelToStream(null);
  }




  Future<File> showPaintBoard({@required BuildContext chatContext}) async{

    CupertinoThemeData _themeData = CupertinoTheme.of(chatContext);
    double screenwidth = MediaQuery.of(chatContext).size.width;
    double screenHeight = MediaQuery.of(chatContext).size.height;
    double scaleFactor = 0.125;


    File artImageFile = await showDialog(
      barrierDismissible: false,
      context: chatContext,
      builder: (BuildContext context){
        return SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenwidth * scaleFactor * 0.25)),

                  child: PaintBoard(),
                ),
              ),
            ),
          ),
        );
      }
    );

    return artImageFile;
  }





  static void onChangeAppLifecycleState({@required AppLifecycleState state, @required PrivateChatBloc bloc}){

    switch(state){
      case AppLifecycleState.resumed:
        bloc.getLoadMessagesListQuerySnapshotStreamSubscription?.resume();
        bloc.getLoadMoreMessagesListQuerySnapshotStreamSubscription?.resume();
        break;
      case AppLifecycleState.inactive:

        bloc.addCurrentUserTypingStatus(currentUserId: bloc.getCurrentUserModel.userId, chatUserId: bloc.getChatUserModel.userId, isTyping: false);
        break;
      case AppLifecycleState.paused:

        bloc.getLoadMessagesListQuerySnapshotStreamSubscription?.pause();
        bloc.getLoadMoreMessagesListQuerySnapshotStreamSubscription?.pause();

        bloc.addCurrentUserTypingStatus(currentUserId: bloc.getCurrentUserModel.userId, chatUserId: bloc.getChatUserModel.userId, isTyping: false);
        break;
      case AppLifecycleState.detached:

        bloc.addCurrentUserTypingStatus(currentUserId: bloc.getCurrentUserModel.userId, chatUserId: bloc.getChatUserModel.userId, isTyping: false);
        break;
      default:
        break;
    }
  }



  /*

  static showImageOptionsOverlay({@required BuildContext chatContext}){

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(chatContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(chatContext);
    double screenwidth = MediaQuery.of(chatContext).size.width;
    double screenHeight = MediaQuery.of(chatContext).size.height;
    double scaleFactor = 0.125;



    OverlayState overlayState = Overlay.of(chatContext);

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context){

        return StreamBuilder<bool>(
          stream: PrivateChatBlocProvider.of(chatContext).overlayBloc.getOverlayEntryActiveStream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
            if (snapshot.hasData && snapshot.data){
              return Center(
                child: SingleChildScrollView(
                  child: OptionMenu(
                    width: MediaQuery.of(chatContext).size.width * 0.75,
                    height: MediaQuery.of(chatContext).size.width * 0.75,

                    topStart: FloatingActionButton(
                      onPressed: (){},
                      backgroundColor: _themeData.primaryColor,
                      foregroundColor: RGBColors.white,
                      child: Icon(Icons.image),
                      
                    ),

                    topEnd: FloatingActionButton(
                      onPressed: (){},
                      backgroundColor: _themeData.primaryColor,
                      foregroundColor: RGBColors.white,
                      child: Icon(CupertinoIcons.photo_camera_solid),
                    ),

                  ),
                ),
              );
            }
            else{
              return Container();
            }
          },
        );

      }
    );


    overlayState.insert(overlayEntry);
    PrivateChatBlocProvider.of(chatContext).overlayBloc.addOverlayEntryActive(true);
  }
  */




  Future<File> getVideoFromGallery() async{
    File videoFile = await ImagePicker.pickVideo(source: ImageSource.gallery);
    return videoFile;
  }

  Future<File> getVideoFromCamera() async{
    File videoFile = await ImagePicker.pickVideo(source: ImageSource.camera);

    return videoFile;
  }


  Future<File> getImageFromGallery() async{
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: ImageOptions.maxWidthHigh.toDouble(),
        maxHeight: ImageOptions.maxWidthHigh.toDouble(),
      imageQuality: ImageOptions.qualityHigh

    );

    return imageFile;
  }

  Future<File> getImageFromCamera() async{
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: ImageOptions.maxWidthHigh.toDouble(),
        maxHeight: ImageOptions.maxWidthHigh.toDouble(),
      imageQuality: ImageOptions.qualityHigh
    );
    return imageFile;
  }

  Future<File> getAudioFromGallery()async{
    File audioFile = await FilePicker.getFile(type: FileType.AUDIO);
    return audioFile;
  }


  void showMediaOptionsModal({@required BuildContext chatContext}) async{

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(chatContext).bloc;

    CupertinoThemeData _themeData = CupertinoTheme.of(chatContext);
    double screenwidth = MediaQuery.of(chatContext).size.width;
    double screenHeight = MediaQuery.of(chatContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
      context: chatContext,
      builder: (BuildContext context){
        return Center(
          child: OptionMenu(
            width: screenwidth * 0.66,
            height: screenHeight * 0.5,


            topStart: OptionMenuItem(
              iconData: FontAwesomeIcons.solidImage,
              label: "Image",
              mini: false,
              optionItemPosition: OptionItemPosition.TOP_START,
              onTap: (){


                showDialog(
                    context: chatContext,
                    builder: (BuildContext context){

                      return BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 5.0,
                            sigmaY: 5.0
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[



                            OptionMenu(
                              width: screenwidth * 0.66,
                              height: screenHeight * 0.5,
                              backgroundColor: RGBColors.white,
                              foregroundColor: _themeData.primaryColor,



                              topStart: Container(
                                key: GlobalKey(),
                                child: OptionMenuItem(
                                  iconData: Icons.camera_alt,
                                  label: "Take a Photo",
                                  mini: false,
                                  returnItemPostionState: false,
                                  optionItemPosition: OptionItemPosition.TOP_START,

                                  onTap: () async{

                                    File imageFile = await getImageFromCamera();

                                    if (imageFile != null){

                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(chatContext).push(MaterialPageRoute(
                                          builder: (BuildContext context) => CreateMessage(
                                            messageFile: imageFile,
                                            messageType: constants.MessageType.image,
                                          )
                                      )).then((messageModelPlaceHolder){

                                        if (messageModelPlaceHolder is MessageModel){

                                          _bloc.addIsMediaUploadingToStream(true);

                                          PrivateChatHttpHandlers.publishMessageImageData(
                                              chatContext: chatContext,
                                              messageModelPlaceholder: messageModelPlaceHolder
                                          ).then((_){

                                            _bloc.addIsMediaUploadingToStream(false);
                                          });
                                        }

                                      });
                                    }
                                    else{
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },

                                ),
                              ),


                              topEnd: Container(
                                key: GlobalKey(),
                                child: OptionMenuItem(
                                  iconData: FontAwesomeIcons.solidImages,
                                  label: "Image Gallery",
                                  mini: false,
                                  returnItemPostionState: false,
                                  optionItemPosition: OptionItemPosition.TOP_END,
                                  onTap: () async{

                                    File imageFile = await getImageFromGallery();

                                    if (imageFile != null){


                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(chatContext).push(MaterialPageRoute(
                                          builder: (BuildContext context) => CreateMessage(
                                            messageFile: imageFile,
                                            messageType: MessageType.image,
                                          )
                                      )).then((messageModelPlaceHolder){

                                        if (messageModelPlaceHolder is MessageModel){

                                          _bloc.addIsMediaUploadingToStream(true);

                                          PrivateChatHttpHandlers.publishMessageImageData(
                                              chatContext: chatContext,
                                              messageModelPlaceholder: messageModelPlaceHolder
                                          ).then((_){

                                            _bloc.addIsMediaUploadingToStream(false);
                                          });
                                        }

                                      });
                                    }
                                    else{
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },

                                ),
                              ),





                              bottomStart: Container(
                                key: GlobalKey(),
                                child: OptionMenuItem(
                                  iconData: FontAwesomeIcons.paintBrush,
                                  label: "Art",
                                  mini: false,
                                  returnItemPostionState: false,
                                  optionItemPosition: OptionItemPosition.BOTTOM_START,
                                  onTap: () async{


                                    File imageFile = await showPaintBoard(chatContext: context);

                                    if (imageFile != null){

                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(chatContext).push(MaterialPageRoute(
                                          builder: (BuildContext context) => CreateMessage(
                                            messageFile: imageFile,
                                            messageType: MessageType.image,
                                          )
                                      )).then((messageModelPlaceHolder){

                                        if (messageModelPlaceHolder is MessageModel){

                                          _bloc.addIsMediaUploadingToStream(true);

                                          PrivateChatHttpHandlers.publishMessageImageData(
                                              chatContext: chatContext,
                                              messageModelPlaceholder: messageModelPlaceHolder
                                          ).then((_){

                                            _bloc.addIsMediaUploadingToStream(false);
                                          });
                                        }

                                      });
                                    }
                                    else{
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },

                                ),
                              ),






                              bottomEnd: Container(
                                key: GlobalKey(),
                                child: OptionMenuItem(
                                  iconData: CupertinoIcons.person_solid,
                                  label: "Avatar",
                                  mini: false,
                                  returnItemPostionState: false,
                                  optionItemPosition: OptionItemPosition.BOTTOM_END,
                                  onTap: () async{

                                    File imageFile = await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context){

                                          return CupertinoActionSheet(
                                            title: Text("Avatar Generator"),
                                            message: Container(
                                              width: screenwidth,
                                              height: screenHeight * 0.8,
                                              child: AvatarImageGenerator(),
                                            ),
                                          );
                                        }
                                    );

                                    if (imageFile != null){


                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(chatContext).push(MaterialPageRoute(
                                          builder: (BuildContext context) => CreateMessage(
                                            messageFile: imageFile,
                                            messageType: MessageType.image,
                                          )
                                      )).then((messageModelPlaceHolder){

                                        if (messageModelPlaceHolder is MessageModel){

                                          _bloc.addIsMediaUploadingToStream(true);

                                          PrivateChatHttpHandlers.publishMessageImageData(
                                              chatContext: chatContext,
                                              messageModelPlaceholder: messageModelPlaceHolder
                                          ).then((_){

                                            _bloc.addIsMediaUploadingToStream(false);
                                          });
                                        }

                                      });
                                    }
                                    else{
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },

                                ),
                              ),




                            ),
                          ],
                        ),
                      );

                    }
                );

              },

            ),

            topEnd: OptionMenuItem(
              iconData: FontAwesomeIcons.video,
              label: "Video",
              mini: false,
              optionItemPosition: OptionItemPosition.TOP_END,
              onTap: (){


                showDialog(
                    context: chatContext,
                    builder: (BuildContext context){

                      return BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 5.0,
                            sigmaY: 5.0
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[



                            OptionMenu(
                              width: screenwidth * 0.66,
                              height: screenHeight * 0.5,
                              backgroundColor: RGBColors.white,
                              foregroundColor: _themeData.primaryColor,

                              centerStart: Container(
                                key: GlobalKey(),
                                child: OptionMenuItem(
                                  iconData: FontAwesomeIcons.video,
                                  label: "Record Video",
                                  mini: false,
                                  optionItemPosition: OptionItemPosition.CENTER_START,
                                  returnItemPostionState: false,
                                  onTap: ()async{


                                    // It gets same video duration value used in post
                                    String message = "Recorded Video should be ${AppFeaturesLimits.VIDEO_DURATION_IN_SECONDS_LIMIT} seconds Max" +
                                        " and ${AppMessageFeaturesLimits.UPLOAD_MESSAGE_VIDEO_SIZE_IN_BYTES_LIMIT / 1000000} MB Max";

                                    bool proceed = await showMediaRestrictionInfoActionDialog(
                                        context: context,
                                        message: message
                                    );

                                    if (proceed != true){
                                      return;
                                    }

                                    File videoFile = await getVideoFromCamera();

                                    if (videoFile != null){

                                      int videoDurationInSeconds = await validateVideo(
                                          videoFile: videoFile,
                                          durationLimitInSeconds: 60,
                                          sizeLimitIntBytes: AppMessageFeaturesLimits.UPLOAD_MESSAGE_VIDEO_SIZE_IN_BYTES_LIMIT
                                      );
                                      if (videoDurationInSeconds == null){

                                        Navigator.pop(context);
                                        BasicUI.showSnackBar(
                                            context: chatContext,
                                            message: message,
                                            textColor: RGBColors.red
                                        );
                                      }
                                      else{

                                        Navigator.pop(context);


                                        Navigator.of(context).pop();
                                        Navigator.of(chatContext).push(MaterialPageRoute(
                                            builder: (BuildContext context) => CreateMessage(
                                              messageFile: videoFile,
                                              messageType: MessageType.video,
                                            )
                                        )).then((messageModelPlaceHolder){

                                          if (messageModelPlaceHolder is MessageModel){

                                            _bloc.addIsMediaUploadingToStream(true);

                                            PrivateChatHttpHandlers.publishMessageVideoData(
                                                chatContext: chatContext,
                                                messageModelPlaceholder: messageModelPlaceHolder
                                            ).then((_){

                                              _bloc.addIsMediaUploadingToStream(false);
                                            });
                                          }

                                        });


                                      }
                                    }else{
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),

                              centerEnd: Container(
                                key: GlobalKey(),
                                child: OptionMenuItem(
                                  iconData: FontAwesomeIcons.solidFileVideo,
                                  label: "Video Gallery",
                                  mini: false,
                                  returnItemPostionState: false,
                                  optionItemPosition: OptionItemPosition.CENTER_END,

                                  onTap: () async{


                                    String message = "Video File should be ${(AppMessageFeaturesLimits.MESSAGE_VIDEO_DURATION_IN_SECONDS_LIMIT / 60).floor()} minutes Max" +
                                        " and ${AppMessageFeaturesLimits.UPLOAD_MESSAGE_VIDEO_SIZE_IN_BYTES_LIMIT / 1000000} MB Max";


                                    bool proceed = await showMediaRestrictionInfoActionDialog(
                                        context: context,
                                        message: message
                                    );

                                    if (proceed != true){
                                      return;
                                    }

                                    File videoFile = await getVideoFromGallery();

                                    if (videoFile != null){

                                      int videoDurationInSeconds = await validateVideo(
                                          videoFile: videoFile,
                                        sizeLimitIntBytes: AppMessageFeaturesLimits.UPLOAD_MESSAGE_VIDEO_SIZE_IN_BYTES_LIMIT,
                                        durationLimitInSeconds: AppMessageFeaturesLimits.MESSAGE_VIDEO_DURATION_IN_SECONDS_LIMIT
                                      );

                                      if (videoDurationInSeconds == null){

                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        BasicUI.showSnackBar(
                                            context: chatContext,
                                            message: message,
                                            textColor: RGBColors.red
                                        );

                                      }
                                      else{

                                        Navigator.of(context).pop();

                                        Navigator.of(context).pop();
                                        Navigator.of(chatContext).push(MaterialPageRoute(
                                            builder: (BuildContext context) => CreateMessage(
                                              messageFile: videoFile,
                                              messageType: MessageType.video
                                            )
                                        )).then((messageModelPlaceHolder){

                                          if (messageModelPlaceHolder is MessageModel){

                                            _bloc.addIsMediaUploadingToStream(true);

                                            PrivateChatHttpHandlers.publishMessageVideoData(
                                                chatContext: chatContext,
                                                messageModelPlaceholder: messageModelPlaceHolder
                                            ).then((_){

                                              _bloc.addIsMediaUploadingToStream(false);
                                            });
                                          }

                                        });;
                                      }
                                    }
                                    else{
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },

                                ),
                              ),



                            ),
                          ],
                        ),
                      );

                    }
                );

              },

            ),

            bottomCenter: OptionMenuItem(
              iconData: FontAwesomeIcons.headphonesAlt,
              label: "Audio",
              mini: false,
              optionItemPosition: OptionItemPosition.BOTTOM_CENTER,
              onTap: (){



                showDialog(
                    context: chatContext,
                    builder: (BuildContext context){

                      return BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 5.0,
                            sigmaY: 5.0
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[



                            OptionMenu(
                              width: screenwidth * 0.66,
                              height: screenHeight * 0.5,
                              backgroundColor: RGBColors.white,
                              foregroundColor: _themeData.primaryColor,

                              bottomCenter: Container(
                                key: GlobalKey(),
                                child: OptionMenuItem(
                                  iconData: FontAwesomeIcons.solidFileAudio,
                                  label: "Audio Gallery",
                                  mini: false,
                                  returnItemPostionState: false,
                                  optionItemPosition: OptionItemPosition.BOTTOM_CENTER,
                                  onTap: () async{

                                    String message = "Audio File should be ${AppMessageFeaturesLimits.UPLOAD_MESSAGE_AUDIO_SIZE_IN_BYTES_LIMIT / 1000000} MB Max";

                                    bool proceed = await showMediaRestrictionInfoActionDialog(
                                        context: context,
                                        message: message
                                    );
                                    if (proceed != true){
                                      return;
                                    }


                                    File audioFile = await getAudioFromGallery();

                                    if (audioFile != null){


                                      int audioSize = await validateAudio(audioFile: audioFile);

                                      if (audioSize == null){

                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        BasicUI.showSnackBar(
                                            context: chatContext,
                                            message: message,
                                            textColor: RGBColors.red
                                        );

                                      }
                                      else{
                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        Navigator.of(chatContext).push(MaterialPageRoute(
                                            builder: (BuildContext context) => CreateMessage(
                                              messageFile: audioFile,
                                              messageType: MessageType.audio,
                                            )
                                        )).then((messageModelPlaceHolder){

                                          if (messageModelPlaceHolder is MessageModel){

                                            _bloc.addIsMediaUploadingToStream(true);

                                            PrivateChatHttpHandlers.publishMessageAudioData(
                                                chatContext: chatContext,
                                                messageModelPlaceholder: messageModelPlaceHolder
                                            ).then((_){

                                              _bloc.addIsMediaUploadingToStream(false);
                                            });
                                          }

                                        });
                                      }

                                    }
                                    else{
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },

                                ),
                              ),


                            ),
                          ],
                        ),
                      );

                    }
                );




              },

            ),


          ),
        );
      },
    );


  }





  Future<int> validateVideo({@required File videoFile, @required sizeLimitIntBytes, int durationLimitInSeconds}) async{

    VideoPlayerController videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController.initialize();


    Duration videoDuration = videoPlayerController.value.duration;
    int videoSize = videoFile.lengthSync();

    videoPlayerController.dispose();


    if (videoDuration.inSeconds <= durationLimitInSeconds&&
        videoSize <= sizeLimitIntBytes){
      return videoDuration.inSeconds;
    }

    return null;
  }




  Future<int> validateAudio({@required File audioFile}) async{

    int audioSize = audioFile.lengthSync();

    if (audioSize <= AppMessageFeaturesLimits.UPLOAD_MESSAGE_AUDIO_SIZE_IN_BYTES_LIMIT){
      return audioSize;
    }
    return null;
  }






  Future<bool> showMediaRestrictionInfoActionDialog({@required BuildContext context, @required String message})async{

    return await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            // title: Text("Info"),
            message: Text(message),
            actions: <Widget>[

              CupertinoActionSheetAction(

                child: Center(
                    child: Text("OK", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),)
                ),
                onPressed: (){

                  Navigator.pop(context, true);
                },
              ),

            ],


            cancelButton: CupertinoActionSheetAction(
              child: Center(
                child: Text("Cancel", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),),
              ),
              onPressed: () => Navigator.pop(context, null),
            ),


          );
        }
    );

  }



  Widget getMessageTypeWidget({@required BuildContext chatContext, @required MessageModel messageModel}){

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(chatContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(chatContext);
    double screenwidth = MediaQuery.of(chatContext).size.width;
    double screenHeight = MediaQuery.of(chatContext).size.height;
    double scaleFactor = 0.125;



    switch(messageModel.message_type){

      case MessageType.text:
        return MessageTextWidget(messageModel: messageModel);
      case MessageType.image:
        return MessageImageWidget(messageModel: messageModel);
      case MessageType.video:
        return MessageVideoWidget(messageModel: messageModel);
      case MessageType.audio:
        return MessageAudioWidget(messageModel: messageModel);

      default:
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * scaleFactor * 0.25,
            horizontal: screenwidth * scaleFactor
          ),
          child: Center(
            child: Text("No Data Found", style: TextStyle(
              fontSize: Theme.of(chatContext).textTheme.title.fontSize,
              fontWeight: FontWeight.bold,
              color: messageModel.sender_id == _bloc.getCurrentUserModel.userId? Colors.white: _themeData.primaryColor,
            ),),
          ),
        );

    }

  }



  Widget getMessageImagePreviewWidget({@required BuildContext context, @required MessageModel messageModel}){


    MessageImageModel messageImageModel = MessageImageModel.fromJson(messageModel.message_data);

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double borderRadius = screenWidth * scaleFactor * 0.33;

    double imagePadding  =  screenWidth * scaleFactor * scaleFactor * 0.25;


    if (messageImageModel.imagesThumbsUrl.length == 1){
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[0],),
                fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(borderRadius)
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: (){

              Navigator.of(context).push(
                  CupertinoPageRoute(
                      builder: (BuildContext context){
                        return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: 0, imageDownloadable: messageModel.downloadable,);
                        },
                  )
              );


            },
          ),
        ),
      );
    }else if(messageImageModel.imagesThumbsUrl.length == 2){
      return Row(
        children: <Widget>[

          for (int index = 0; index < 2; ++index)

            Flexible(
              child: Padding(
                padding: EdgeInsets.all(imagePadding),
                child: Container(

                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index],),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(borderRadius)
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(borderRadius),
                      onTap: (){

                        Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (BuildContext context){
                                return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index, imageDownloadable: messageModel.downloadable,);
                              },
                            )
                        );

                      },
                    ),
                  ),
                ),
              ),
            ),

        ],
      );
    }
    else if (messageImageModel.imagesThumbsUrl.length == 3){

      return Column(
        children: <Widget>[

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                for (int index = 0; index < 2; ++index)

                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.all(imagePadding),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index],),
                                  fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(borderRadius)
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: (){

                                Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (BuildContext context){
                                        return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index, imageDownloadable: messageModel.downloadable,);
                                      },
                                    )
                                );
                              },
                            ),
                          ),
                        )
                    ),
                  ),


              ],
            ),
          ),

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(imagePadding),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[2],),
                              fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.circular(borderRadius)
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(borderRadius),
                          onTap: (){

                            Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (BuildContext context){
                                    return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: 2, imageDownloadable: messageModel.downloadable,);
                                  },
                                )
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      );
    }
    else if(messageImageModel.imagesThumbsUrl.length >= 4){


      return Column(
        children: <Widget>[

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                for (int index = 0; index < 2; ++index)

                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.all(imagePadding),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index],),
                                  fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(borderRadius)
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: (){

                                Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (BuildContext context){
                                        return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index, imageDownloadable: messageModel.downloadable,);
                                      },
                                    )
                                );

                              },
                            ),
                          ),
                        )
                    ),
                  ),

              ],
            ),
          ),

          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                for (int index = 2; index < 4; ++index)

                  Container(
                    child: messageImageModel.imagesThumbsUrl.length > 4 && index == 3? Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(imagePadding),
                        child: Container(
                          decoration: BoxDecoration(

                            image: DecorationImage(
                                image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index]),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: (){

                                Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (BuildContext context){
                                        return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index, imageDownloadable: messageModel.downloadable,);
                                      },
                                    )
                                );

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  color: _themeData.primaryColor.withOpacity(0.3),
                                ),
                                child: Center(
                                  child: Text("+ ${messageImageModel.imagesThumbsUrl.length - 4}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context).textTheme.headline.fontSize,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ): Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(imagePadding),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[index]),
                                  fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(borderRadius)
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: (){

                                Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (BuildContext context){
                                        return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: index, imageDownloadable: messageModel.downloadable,);
                                      },
                                    )
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ) ,
                  ),

              ],
            ),
          )

        ],
      );

    }
    else{

      return Container(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(messageImageModel.imagesThumbsUrl[0],),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(borderRadius)
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: (){

                  Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (BuildContext context){
                          return ImageViewer(imageList: messageImageModel.imagesUrl.cast(), currentIndex: 0, imageDownloadable: messageModel.downloadable,);
                        },
                      )
                  );
                },
              ),
            ),
          )
      );
    }



  }







  Widget getMessageVideoPreviewWidget({@required BuildContext context, @required MessageModel messageModel}){

    MessageVideoModel messageVideoModel = MessageVideoModel.fromJson(messageModel.message_data);

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double borderRadius = screenWidth * scaleFactor * 0.33;

    double imagePadding  =  screenWidth * scaleFactor * scaleFactor * 0.25;


    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(messageVideoModel.videoThumb,),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),

            onTap: (){


            Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context){
                    return VideoViewer(videoUrl: messageVideoModel.videoUrl, videoDownloadable: messageModel.downloadable, videoImageUrl: messageVideoModel.videoImage, );
                  },
                )
            );

          },

          child: messageModel.downloadable != null && messageModel.downloadable? Container(

            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.eye, color: Colors.white),
                  SizedBox(height: screenHeight * scaleFactor * scaleFactor,),
                  Text("View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
            ),

          ): Container(
            child: Center(
              child: Icon(Icons.play_arrow, color: _themeData.primaryColor,),
            ),
          ),
        ),
      ),
    );

  }







  Widget getMessageAudioPreviewWidget({@required BuildContext context, @required MessageModel messageModel}){

    MessageAudioModel messageAudioModel = MessageAudioModel.fromJson(messageModel.message_data);

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double borderRadius = screenWidth * scaleFactor * 0.33;

    double imagePadding  =  screenWidth * scaleFactor * scaleFactor * 0.25;



    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          image: messageAudioModel.audioThumb != null? DecorationImage(
              image: CachedNetworkImageProvider(messageAudioModel.audioThumb != null? messageAudioModel.audioThumb: "",),
              fit: BoxFit.cover
          ): DecorationImage(
              image: AssetImage(AppBackgroundImages.audio_background_image_orion_nebula),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.pinkAccent, BlendMode.color)

          ),
          borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: Stack(
        children: <Widget>[


          Center(
            child: Icon(
              FontAwesomeIcons.music,
              color: Colors.white.withOpacity(0.2),
              size: MediaQuery.of(context).size.width * scaleFactor * 2,
            ),
          ),


          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),

                  onTap: (){


                    Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (BuildContext context){
                            return AudioViewer(audioUrl: messageAudioModel.audioUrl, audioDownloadable: messageModel.downloadable, audioImageUrl: messageAudioModel.audioImage, );
                          },
                        )
                    );

                },

                child: messageModel.downloadable != null && messageModel.downloadable? Container(

                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.headphonesAlt, color: Colors.white,),
                        SizedBox(height: screenHeight * scaleFactor * scaleFactor,),
                        Text("Listen", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize))

                      ],
                    ),
                  ),

                ): Container(
                  child: Center(
                    child: Icon(Icons.play_arrow, color: _themeData.primaryColor,),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }




  Future<void> showMessageDialogDeleteOption({@required BuildContext context, @required MessageModel messageModel})async{

    PrivateChatBlocProvider _provider = PrivateChatBlocProvider.of(context);
    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    await showDialog(
        context: context,
        builder: (BuildContext context){



          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              duration: Duration.zero,

              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoAlertDialog(

                    title: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.25),
                        child: Text("Do you want to Delete Message?", style: TextStyle( fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),


                    content: Column(
                      children: <Widget>[
                        Text(
                          "Message will only be removed For You",
                          textAlign: TextAlign.center,
                        ),

                        if (_bloc.getCurrentUserModel.userId == messageModel.sender_id
                            && (messageModel.message_type == MessageType.image
                                || messageModel.message_type == MessageType.audio
                                || messageModel.message_type == MessageType.video
                        ))
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: screenHeight * scaleFactor * 0.33),
                                Text(
                                  "Your Media File will also only be deleted For You.\nIf needed, download before deleting Message",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    actions: <Widget>[


                      CupertinoDialogAction(
                        child: Text("YES",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: ()async{

                          List<MessageModel> dummyMessageList = List<MessageModel>();
                          for (int index = 0; index < _bloc.getMessagesList.length; ++index){
                            dummyMessageList.add(_bloc.getMessagesList[index]);
                          }

                          for (int index = 0; index < dummyMessageList.length; ++index){
                            if (messageModel.message_id == dummyMessageList[index].message_id){
                              MessageModel messageModelToDelete = _bloc.getMessagesList[index];

                              if (messageModel.message_id == messageModelToDelete.message_id){

                                _bloc.removeMessageData(
                                    messageId: messageModel.message_id,
                                    currentUserId: _bloc.getCurrentUserModel.userId,
                                    chatUserId: _bloc.getChatUserModel.userId
                                );

                                _bloc.removeCurrentUserSentMessageState(
                                    messageId: messageModel.message_id,
                                    currentUserId: _bloc.getCurrentUserModel.userId,
                                    chatUserId: _bloc.getChatUserModel.userId
                                );


                                if (_bloc.getCurrentUserModel.userId == messageModel.sender_id){
                                  AppBlocProvider.of(context).bloc.deleteAllFilesInModelData(dynamicModel: messageModel);
                                }

                                _bloc.getMessagesList.removeAt(index);

                                _bloc.addMessagesListToStream(_bloc.getMessagesList);

                                break;
                              }

                              break;
                            }
                          }

                          Navigator.of(context).pop(true);
                        },
                      ),



                      CupertinoDialogAction(
                        child: Text("NO",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: (){

                          Navigator.of(context).pop();
                        },
                      ),

                    ],

                  ),
                );
              },
            ),
          );
        }
    );

  }











  static Future<bool> showChatInfo({@required BuildContext context})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){


          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(seconds: 1),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: CupertinoAlertDialog(

                    title: Center(
                      //child: Icon(Icons.info_outline)
                      child: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * scaleFactor * 0.25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Icon(Icons.info_outline),
                            SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                            Text("Chat Info", style: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),


                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Slide message from Left to Right to refer to the message",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * scaleFactor * 0.25,),
                        Text(
                          "Slide message from Right to Left to delete the message",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * scaleFactor * 0.25,),

                        Text(
                          "Perform a Long-press on your profile image to view your profile",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    actions: <Widget>[

                      CupertinoDialogAction(
                        child: Text("OK",
                          style: TextStyle(color: _themeData.primaryColor),),
                        onPressed: (){

                          Navigator.of(context).pop(true);
                        },
                      ),

                    ],

                  ),
                );
              },
            ),
          );
        }
    );

  }






  Widget getReferredMessageWidget({@required BuildContext pageContext, @required MessageModel referredMessageModel}){


    PrivateChatBlocProvider _provider = PrivateChatBlocProvider.of(pageContext);
    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;


    Widget referredMessageTitleText = Text(referredMessageModel.sender_id == _bloc.getChatUserModel.userId? _bloc.getChatUserModel.profileName: "Me",
      style: TextStyle(
          color: _themeData.primaryColor,
        fontWeight: FontWeight.bold
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );


    if (referredMessageModel.message_type == MessageType.text){

      return ListTile(
        title: referredMessageTitleText,
        subtitle: Text(referredMessageModel.message_text,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        dense: true
      );
    }
    else if (referredMessageModel.message_type == MessageType.image){
      return ListTile(
        title: referredMessageTitleText,
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.camera_alt, color: Colors.black.withOpacity(0.5)),
            SizedBox(width: 10.0,),
            Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Image",
              style: TextStyle(
                  fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Semantics(
          label: "FittedBox is needed here to make the render box not to overflow to unlimited bounds",
          child: FittedBox(
            fit: BoxFit.fill,
            child: CachedNetworkImage(
                imageUrl: MessageImageModel.fromJson(referredMessageModel.message_data).imagesThumbsUrl[0],
              imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider){
                  return Container(
                    width: screenWidth,
                    height: screenWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(60.0)
                    ),
                  );
              },
            ),
          ),
        ),
        dense: true,
      );
    }
    else if (referredMessageModel.message_type == MessageType.video){
      return ListTile(
        title: referredMessageTitleText,
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.videocam, color: Colors.black.withOpacity(0.5)),
            SizedBox(width: 10.0,),
            Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Video",
              style: TextStyle(
                  fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,

            ),
          ],
        ),
        trailing: Semantics(
          label: "FittedBox is needed here to make the render box not to overflow to unlimited bounds",
          child: FittedBox(
            fit: BoxFit.fill,
            child: CachedNetworkImage(
              imageUrl: MessageVideoModel.fromJson(referredMessageModel.message_data).videoThumb,
              imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider){
                return Container(
                  width: screenWidth,
                  height: screenWidth,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(60.0)
                  ),
                );
              },
            ),
          ),
        ),
        dense: true,
      );
    }
    else if(referredMessageModel.message_type == MessageType.audio){
      return ListTile(
        title: referredMessageTitleText,
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.headset, color: Colors.black.withOpacity(0.5),),
            SizedBox(width: 10.0,),
            Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Audio",
              style: TextStyle(
                  fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }
    else{
      return Container();
    }

  }









  Widget getLoadedMessageReferredMessageWidget({@required BuildContext pageContext, @required MessageModel referredMessageModel}){


    PrivateChatBlocProvider _provider = PrivateChatBlocProvider.of(pageContext);
    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;


    Widget referredMessageTitleText = Text(referredMessageModel.sender_id == _bloc.getChatUserModel.userId? _bloc.getChatUserModel.profileName: "Me",
      style: TextStyle(
          color: _themeData.primaryColor,
          fontWeight: FontWeight.bold
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );


    if (referredMessageModel.message_type == MessageType.text){

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          referredMessageTitleText,
          SizedBox(height: 5.0,),
          Text(referredMessageModel.message_text,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          )
        ],
      );

    }
    else if (referredMessageModel.message_type == MessageType.image){
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              referredMessageTitleText,
              SizedBox(height: 5.0,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.camera_alt, color: Colors.black.withOpacity(0.5)),
                  SizedBox(width: 10.0,),
                  Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Image",
                    style: TextStyle(
                      fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          SizedBox(width: screenWidth * scaleFactor * 0.5,),

          Flexible(
            child: CachedNetworkImage(
              imageUrl: MessageImageModel.fromJson(referredMessageModel.message_data).imagesThumbsUrl[0],
              imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider){
                return Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                );
              },
            ),
          )

        ],
      );

    }
    else if (referredMessageModel.message_type == MessageType.video){

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              referredMessageTitleText,
              SizedBox(height: 5.0,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.videocam, color: Colors.black.withOpacity(0.5)),
                  SizedBox(width: 10.0,),
                  Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Video",
                    style: TextStyle(
                      fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          SizedBox(width: screenWidth * scaleFactor * 0.5,),

          Flexible(
            child: CachedNetworkImage(
              imageUrl: MessageVideoModel.fromJson(referredMessageModel.message_data).videoThumb,
              imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider){
                return Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                );
              },
            ),
          )

        ],
      );

    }
    else if(referredMessageModel.message_type == MessageType.audio){

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              referredMessageTitleText,
              SizedBox(height: 5.0,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.headset, color: Colors.black.withOpacity(0.5)),
                  SizedBox(width: 10.0,),
                  Text(referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? referredMessageModel.message_text: "Audio",
                    style: TextStyle(
                      fontWeight: referredMessageModel.message_text != null && referredMessageModel.message_text.isNotEmpty? FontWeight.normal: FontWeight.bold
                    ),maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          SizedBox(width: screenWidth * scaleFactor * 0.5,),

        ],
      );

    }
    else{
      return Container();
    }

  }





  Future<void> showReferredMessageModal({@required BuildContext pageContext, @required MessageModel referredMessageModel})async{

    PrivateChatBlocProvider _provider = PrivateChatBlocProvider.of(pageContext);
    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;

    Widget messageTypeWidget;

    if (referredMessageModel.message_type == MessageType.image){
      messageTypeWidget = getMessageImagePreviewWidget(context: pageContext, messageModel: referredMessageModel);
    }
    else{
      messageTypeWidget = Container();
    }




    DateTime dateTimeNow = DateTime.now();
    DateTime dateTimeLastSeen = referredMessageModel.timestamp.toDate();

    String dateTimeDailyMessages;

    if (dateTimeNow.day == dateTimeLastSeen.day
        &&  dateTimeNow.month == dateTimeLastSeen.month
        && dateTimeNow.year == dateTimeLastSeen.year
    ){
      dateTimeDailyMessages = "Today, " + DateFormat.yMMMMd().add_jm().format(dateTimeLastSeen);
    }
    else if ((dateTimeNow.day  - dateTimeLastSeen.day) == 1
        &&  (dateTimeNow.month == dateTimeLastSeen.month
            || (dateTimeNow.month - dateTimeLastSeen.month) == 1
            || (dateTimeNow.month - dateTimeLastSeen.month) == -11
        )
        && dateTimeNow.year == dateTimeLastSeen.year
    ){
      dateTimeDailyMessages = "Yesterday, " + DateFormat.yMMMMd().add_jm().format(dateTimeLastSeen);
    }
    else{
      dateTimeDailyMessages = DateFormat.yMMMMEEEEd().add_jm().format(dateTimeLastSeen);
    }



    await showDialog(
        context: pageContext,
        builder: (BuildContext context){

          return Center(
            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeOutBack,
              duration: Duration(milliseconds: 500),

              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidth * 0.5,
                      maxWidth: screenWidth * 0.75,
                      maxHeight: screenHeight * 0.75,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      color: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? _themeData.primaryColor: Colors.white,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[

                              Row(
                                children: <Widget>[
                                  Text(referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? "Me": _bloc.getChatUserModel.profileName,
                                    style: TextStyle(
                                      color: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? Colors.white: _themeData.primaryColor,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                              if (referredMessageModel.message_data != null)
                                Flexible(
                                    child: Container(
                                      width: screenWidth * scaleFactor * 5,
                                        height: screenWidth * scaleFactor * 4,
                                        child: messageTypeWidget
                                    )
                                ),

                              if (referredMessageModel.message_text != null)
                                Container(
                                  padding: EdgeInsets.all( screenWidth * scaleFactor * scaleFactor),
                                  child: Text(referredMessageModel.message_text != null? "${referredMessageModel.message_text}": "",
                                    style: TextStyle(
                                        color: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? RGBColors.white: RGBColors.black,
                                        fontWeight: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId? FontWeight.w700: FontWeight.normal
                                    ),
                                  ),
                                ),

                              Padding(
                                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                                child: Text(dateTimeDailyMessages,
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.caption.fontSize,
                                    color: referredMessageModel.sender_id == _bloc.getCurrentUserModel.userId
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.black.withOpacity(0.5)
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
    );

  }




}











