import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/message_models/message_audio_model.dart';
import 'package:iris_social_network/services/models/message_models/message_image_model.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/services/models/message_models/message_video_model.dart';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/widgets/avatar_image_generator/avatar_image_generator.dart';
import 'package:iris_social_network/widgets/option_menu/option_menu.dart';
import 'package:iris_social_network/widgets/paint_board/paint_board.dart';
import 'create_message_bloc.dart';
import 'create_message_bloc_provider.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/services/constants/app_constants.dart' as app_contants;




class CreateMessageViewsHandlers{


  Future<File> getImageFromGallery() async{
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery,
        maxWidth: ImageOptions.maxWidthHigh.toDouble(),
        maxHeight: ImageOptions.maxWidthHigh.toDouble(),
      imageQuality: ImageOptions.qualityHigh

    );
    return imageFile;
  }

  Future<File> getImageFromCamera() async{
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera,
        maxWidth: ImageOptions.maxWidthHigh.toDouble(),
        maxHeight: ImageOptions.maxWidthHigh.toDouble(),
      imageQuality: ImageOptions.qualityHigh
    );
    return imageFile;
  }



  Stream<bool> getMessageSetupCompleteObservable({@required BuildContext createMessageContext}){

    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(createMessageContext).bloc;

    String messageType = CreateMessageBlocProvider.of(createMessageContext).messageType;

    if (messageType == constants.MessageType.image){
      return _bloc.getIsMessageImageSetupCompleteObservable;
    }
    else if(messageType == constants.MessageType.video){
      return _bloc.getIsMessageVideoSetupCompleteObservable;
    }
    else if (messageType == constants.MessageType.audio){
      return _bloc.getIsMessageAudioSetupCompleteObservable;
    }
    else{
      return null;
    }

  }



  Future<void> showUploadImageOptionDialog({@required BuildContext createMessageContext}){

    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(createMessageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(createMessageContext);
    double screenwidth = MediaQuery.of(createMessageContext).size.width;
    double screenHeight = MediaQuery.of(createMessageContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: createMessageContext,
        builder: (BuildContext context){

          return Center(
            child: OptionMenu(
              width: screenwidth * 0.75,
              height: screenwidth * 0.75,
              backgroundColor: Colors.white,
              foregroundColor: _themeData.primaryColor,

              topStart: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: CupertinoIcons.switch_camera_solid,
                    label: "Take a Photo",
                    mini: false,
                    optionItemPosition: OptionItemPosition.TOP_START,
                    returnItemPostionState: false,
                    onTap: ()async {

                      File imageFile = await getImageFromCamera();

                      if (imageFile != null){

                        _bloc.getMessageImagesPaths.add(imageFile.path);
                        _bloc.addImagesPathToStream(_bloc.getMessageImagesPaths);

                        // Change background image when image is received
                        // and scrolls to image
                        _bloc.addMessageBackgroundImageToStream(imageFile.path);
                        CreateMessageBlocProvider.of(createMessageContext).imagesSwiperController.move(_bloc.getMessageImagesPaths.length - 1);

                        if (_bloc.getMessageImagesPaths.length == app_contants.AppMessageFeaturesLimits.IMAGES_PER_MESSAGE_LIMIT){
                          _bloc.addIsMessageImagesLimitReachedToStream(true);
                        }

                        Navigator.pop(context);

                      }else{

                        Navigator.of(context);
                      }

                    }
                ),
              ),

              topEnd: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: Icons.image,
                    label: "Gallery",
                    mini: false,
                    returnItemPostionState: false,
                    onTap: () async{

                      File imageFile = await getImageFromGallery();

                      if (imageFile != null){

                        _bloc.getMessageImagesPaths.add(imageFile.path);
                        _bloc.addImagesPathToStream(_bloc.getMessageImagesPaths);

                        // Change background image when image is received
                        // and scrolls to image
                        _bloc.addMessageBackgroundImageToStream(imageFile.path);
                        CreateMessageBlocProvider.of(createMessageContext).imagesSwiperController.move(_bloc.getMessageImagesPaths.length - 1);


                        if (_bloc.getMessageImagesPaths.length == app_contants.AppMessageFeaturesLimits.IMAGES_PER_MESSAGE_LIMIT){
                          _bloc.addIsMessageImagesLimitReachedToStream(true);
                        }

                        Navigator.pop(context);

                      }
                      else{
                        Navigator.of(context);
                      }

                    },
                    optionItemPosition: OptionItemPosition.TOP_END

                ),
              ),




              bottomStart: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: FontAwesomeIcons.paintBrush,
                    label: "Paint",
                    mini: false,
                    returnItemPostionState: false,
                    onTap: () async{

                      File imageFile = await showPaintBoard(chatContext: createMessageContext);

                      if (imageFile != null){
                        _bloc.getMessageImagesPaths.add(imageFile.path);
                        _bloc.addImagesPathToStream(_bloc.getMessageImagesPaths);

                        // Change background image when image is received
                        // and scrolls to image
                        _bloc.addMessageBackgroundImageToStream(imageFile.path);
                        CreateMessageBlocProvider.of(createMessageContext).imagesSwiperController.move(_bloc.getMessageImagesPaths.length - 1);


                        if (_bloc.getMessageImagesPaths.length == app_contants.AppMessageFeaturesLimits.IMAGES_PER_MESSAGE_LIMIT){
                          _bloc.addIsMessageImagesLimitReachedToStream(true);
                        }

                        Navigator.pop(context);
                      }
                      else{
                        Navigator.of(context);
                      }


                    },
                    optionItemPosition: OptionItemPosition.BOTTOM_START

                ),
              ),





              bottomEnd: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: CupertinoIcons.person_solid,
                    label: "Avatar",
                    mini: false,
                    returnItemPostionState: false,
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
                        _bloc.getMessageImagesPaths.add(imageFile.path);
                        _bloc.addImagesPathToStream(_bloc.getMessageImagesPaths);

                        // Change background image when image is received
                        // and scrolls to image
                        _bloc.addMessageBackgroundImageToStream(imageFile.path);
                        CreateMessageBlocProvider.of(createMessageContext).imagesSwiperController.move(_bloc.getMessageImagesPaths.length - 1);


                        if (_bloc.getMessageImagesPaths.length == app_contants.AppMessageFeaturesLimits.IMAGES_PER_MESSAGE_LIMIT){
                          _bloc.addIsMessageImagesLimitReachedToStream(true);
                        }

                        Navigator.pop(context);
                      }
                      else{
                        Navigator.of(context);
                      }


                    },
                    optionItemPosition: OptionItemPosition.BOTTOM_END

                ),
              ),



            ),
          );

        }
    );
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


  Future<void> showChangeSelectedUploadImageOptionDialog({@required BuildContext createMessageContext, @required int imageToChangeIndexInList}){


    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(createMessageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(createMessageContext);
    double screenwidth = MediaQuery.of(createMessageContext).size.width;
    double screenHeight = MediaQuery.of(createMessageContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: createMessageContext,
        builder: (BuildContext context){

          return Center(
            child: OptionMenu(
              width: screenwidth * 0.75,
              height: screenwidth * 0.75,
              backgroundColor: Colors.white,
              foregroundColor: _themeData.primaryColor,

              topStart: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: CupertinoIcons.switch_camera_solid,
                    label: "Take a Photo",
                    mini: false,
                    optionItemPosition: OptionItemPosition.TOP_START,
                    returnItemPostionState: false,
                    onTap: ()async {

                      File imageFile = await getImageFromCamera();

                      if (imageFile != null){

                        _bloc.getMessageImagesPaths.remove(_bloc.getMessageImagesPaths.removeAt(imageToChangeIndexInList));
                        _bloc.getMessageImagesPaths.insert(imageToChangeIndexInList, imageFile.path);
                        _bloc.addImagesPathToStream(_bloc.getMessageImagesPaths);


                        // Change background image when image is received
                        _bloc.addMessageBackgroundImageToStream(imageFile.path);


                        if (_bloc.getMessageImagesPaths.length == app_contants.AppMessageFeaturesLimits.IMAGES_PER_MESSAGE_LIMIT){
                          _bloc.addIsMessageImagesLimitReachedToStream(true);
                        }

                        Navigator.pop(context);
                      }
                      else{

                        Navigator.of(context);
                      }

                    }
                ),
              ),

              topEnd: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                  iconData: Icons.image,
                  label: "Gallery",
                  mini: false,
                  returnItemPostionState: false,
                  optionItemPosition: OptionItemPosition.TOP_END,
                  onTap: () async{

                    File imageFile = await getImageFromGallery();

                    if (imageFile != null){


                      _bloc.getMessageImagesPaths.remove(_bloc.getMessageImagesPaths.removeAt(imageToChangeIndexInList));
                      _bloc.getMessageImagesPaths.insert(imageToChangeIndexInList, imageFile.path);
                      _bloc.addImagesPathToStream(_bloc.getMessageImagesPaths);


                      // Change background image when image is received
                      _bloc.addMessageBackgroundImageToStream(imageFile.path);


                      if (_bloc.getMessageImagesPaths.length == app_contants.AppMessageFeaturesLimits.IMAGES_PER_MESSAGE_LIMIT){
                        _bloc.addIsMessageImagesLimitReachedToStream(true);
                      }

                      Navigator.pop(context);
                    }
                    else{
                      Navigator.of(context);
                    }

                  },

                ),
              ),


              bottomCenter: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: Icons.delete,
                    label: "Remove Image",
                    mini: false,
                    returnItemPostionState: false,
                    onTap: () async{


                      _bloc.getMessageImagesPaths.removeAt(imageToChangeIndexInList);
                      _bloc.addImagesPathToStream(_bloc.getMessageImagesPaths);


                      if (_bloc.getMessageImagesPaths.length < app_contants.AppMessageFeaturesLimits.IMAGES_PER_MESSAGE_LIMIT){
                        _bloc.addIsMessageImagesLimitReachedToStream(false);
                      }

                      if (_bloc.getMessageImagesPaths.length <= 0){

                        _bloc.addMessageBackgroundImageToStream(null);
                        _bloc.addImagesPathToStream(null);
                      }

                      Navigator.pop(context);
                    },
                    optionItemPosition: OptionItemPosition.BOTTOM_CENTER

                ),
              ),


            ),
          );

        }
    );
  }





  Future<void> showVideoThumbNailView({@required BuildContext createMessageContext, @required String videoThumbNailPath}){


    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(createMessageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(createMessageContext);
    double screenwidth = MediaQuery.of(createMessageContext).size.width;
    double screenHeight = MediaQuery.of(createMessageContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: createMessageContext,
        builder: (BuildContext context){

          return Center(
            child: Container(
              child: Image.file(File(videoThumbNailPath)),
            ),
          );

        }
    );
  }




  Future<void> showUploadAudioImageOptionDialog({@required BuildContext createMessageContext}){


    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(createMessageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(createMessageContext);
    double screenwidth = MediaQuery.of(createMessageContext).size.width;
    double screenHeight = MediaQuery.of(createMessageContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: createMessageContext,
        builder: (BuildContext context){

          return Center(
            child: OptionMenu(
              width: screenwidth * 0.75,
              height: screenwidth * 0.75,
              backgroundColor: Colors.white,
              foregroundColor: _themeData.primaryColor,

              centerStart: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: CupertinoIcons.switch_camera_solid,
                    label: "Take a Photo",
                    mini: false,
                    optionItemPosition: OptionItemPosition.CENTER_START,
                    returnItemPostionState: false,
                    onTap: ()async {

                      File imageFile = await getImageFromCamera();

                      if (imageFile != null){
                        _bloc.addAudioImagePathToStream(imageFile.path);
                        _bloc.addImagesPathToStream(_bloc.getMessageImagesPaths);

                        // Change background image when image is received
                        _bloc.addMessageBackgroundImageToStream(imageFile.path);

                        Navigator.pop(context);
                      }
                      else{
                        Navigator.of(context);
                      }


                    }
                ),
              ),

              centerEnd: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: Icons.image,
                    label: "Gallery",
                    mini: false,
                    returnItemPostionState: false,
                    onTap: () async{

                      File imageFile = await getImageFromGallery();

                      if (imageFile != null){

                        _bloc.addAudioImagePathToStream(imageFile.path);
                        _bloc.addImagesPathToStream(_bloc.getMessageImagesPaths);

                        // Change background image when image is received
                        _bloc.addMessageBackgroundImageToStream(imageFile.path);


                        Navigator.pop(context);
                      }else{
                        Navigator.of(context);
                      }

                    },
                    optionItemPosition: OptionItemPosition.CENTER_END

                ),
              ),


            ),
          );

        }
    );
  }




  Future<void> showChangeSelectedUploadAudioImageOptionDialog({@required BuildContext createMessageContext}){


    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(createMessageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(createMessageContext);
    double screenwidth = MediaQuery.of(createMessageContext).size.width;
    double screenHeight = MediaQuery.of(createMessageContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: createMessageContext,
        builder: (BuildContext context){

          return Center(
            child: OptionMenu(
              width: screenwidth * 0.75,
              height: screenwidth * 0.75,
              backgroundColor: Colors.white,
              foregroundColor: _themeData.primaryColor,

              topStart: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: CupertinoIcons.switch_camera_solid,
                    label: "Take a Photo",
                    mini: false,
                    optionItemPosition: OptionItemPosition.TOP_START,
                    returnItemPostionState: false,
                    onTap: ()async {

                      File imageFile = await getImageFromCamera();

                      if (imageFile != null){

                        _bloc.addAudioImagePathToStream(imageFile.path);

                        // Change background image when image is received
                        _bloc.addMessageBackgroundImageToStream(imageFile.path);

                        Navigator.pop(context);
                      }
                      else{
                        Navigator.of(context);
                      }


                    }
                ),
              ),

              topEnd: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                  iconData: Icons.image,
                  label: "Gallery",
                  mini: false,
                  returnItemPostionState: false,
                  optionItemPosition: OptionItemPosition.TOP_END,
                  onTap: () async{

                    File imageFile = await getImageFromGallery();

                    if (imageFile != null){

                      _bloc.addAudioImagePathToStream(imageFile.path);

                      // Change background image when image is received
                      _bloc.addMessageBackgroundImageToStream(imageFile.path);

                      Navigator.pop(context);
                    }
                    else{
                      Navigator.of(context);
                    }

                  },

                ),
              ),


              bottomCenter: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: Icons.delete,
                    label: "Remove Image",
                    mini: false,
                    returnItemPostionState: false,
                    onTap: () async{


                      _bloc.addMessageBackgroundImageToStream(null);
                      _bloc.addAudioImagePathToStream(null);

                      Navigator.pop(context);
                    },
                    optionItemPosition: OptionItemPosition.BOTTOM_CENTER

                ),
              ),


            ),
          );

        }
    );
  }


  
  Future<MessageModel> getMessageModelPlaceholderData({@required BuildContext createMessageContext})async{



    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(createMessageContext);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(createMessageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(createMessageContext);
    double screenwidth = MediaQuery.of(createMessageContext).size.width;
    double screenHeight = MediaQuery.of(createMessageContext).size.height;
    double scaleFactor = 0.125;


    MessageModel messageModelPlaceHolder = MessageModel(
        message_text: _provider.messageCaptionTextEditingController.text != null? _provider.messageCaptionTextEditingController.text: "".trim(),
        message_type: _bloc.getMessageType,
        sender_id: null,
        receiver_id: null,
        timestamp: null,
        seen: null,
        message_data: null,
        downloadable: _bloc.getIsMessageMediaDownloadable
    );


    if (_bloc.getMessageType == constants.MessageType.image){
      MessageImageModel messageImageModel = MessageImageModel(
        imagesUrl: _bloc.getMessageImagesPaths,
        imagesThumbsUrl: _bloc.getMessageImagesPaths,
      );
      messageModelPlaceHolder.message_data = messageImageModel.toJson();
    }
    else if(_bloc.getMessageType == constants.MessageType.video){

      MessageVideoModel messageVideoModel = MessageVideoModel(
          videoImage: _bloc.getVideoThumbPath,
          videoThumb: _bloc.getVideoThumbPath,
          videoUrl: _bloc.getVideoPath,
          duration: ((await _bloc.getMediaInfo(mediaPath: _bloc.getVideoPath)).duration / 1000).floor()
      );

      messageModelPlaceHolder.message_data = messageVideoModel.toJson();
    }
    else if(_bloc.getMessageType == constants.MessageType.audio){
      MessageAudioModel messageAudioModel = MessageAudioModel(
          audioImage: _bloc.getAudioImage,
          audioThumb: _bloc.getAudioImage,
          audioUrl: _bloc.getAudioPath,
          duration: _bloc.getAudioDuration
      );
      messageModelPlaceHolder.message_data = messageAudioModel.toJson();
    }
      

    return messageModelPlaceHolder;
  }

}