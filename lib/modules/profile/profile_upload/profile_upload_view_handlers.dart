import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/widgets/option_menu/option_menu.dart';
import '../profile_bloc_provider.dart';
import '../profile_bloc.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import '../profile_views.dart';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:iris_social_network/modules/profile/profile_upload/profile_upload.dart';
import 'profile_upload_bloc.dart';
import 'profile_upload_bloc_provider.dart';
import 'package:iris_social_network/modules/profile/profile_bloc.dart';
import 'package:iris_social_network/modules/profile/profile_bloc_provider.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';
import 'package:iris_social_network/utils/image_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/constants/constants.dart';









class ProfileUploadViewHandlers{


  Future<File> getImageFromGallery() async{
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    return imageFile;
  }

  Future<File> getImageFromCamera() async{
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    return imageFile;
  }


  Future<void> showUploadImageOptionDialog({@required BuildContext uploadContext}){

    ProfileUploadBloc _bloc = ProfileUploadBlocProvider.of(uploadContext).uploadBloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(uploadContext);
    double screenwidth = MediaQuery.of(uploadContext).size.width;
    double screenHeight = MediaQuery.of(uploadContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: uploadContext,
        builder: (BuildContext context){

          return Center(
            child: OptionMenu(
              width: screenwidth * 0.75,
              height: screenwidth * 0.75,
              backgroundColor: RGBColors.white,
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
                      _bloc.addVideoThumbToStream(videoThumbPath: imageFile.path);
                      Navigator.pop(context);
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
                      _bloc.addVideoThumbToStream(videoThumbPath: imageFile.path);
                      Navigator.pop(context);
                    },
                    optionItemPosition: OptionItemPosition.TOP_END
                ),
              ),

            ),
          );

        }
    );
  }



  // Uploads video and other infomation
  Future<bool> uploadVideo({BuildContext context}) async{

    ProfileBloc profileBloc = ProfileUploadBlocProvider.of(context).profileBloc;
    ProfileUploadBloc uploadBloc = ProfileUploadBlocProvider.of(context).uploadBloc;


    String compressedVideoPath = await uploadBloc.compressVideo(videoPath: uploadBloc.getVideoFilePath);

    if (compressedVideoPath == null){
      throw Exception(["Compressed video path cannot be null"]);
    }

    File videoFile = File(compressedVideoPath);


    TextEditingController videoCaptionTextEditingController = ProfileUploadBlocProvider.of(context).videoCaptionTextEditingControlloer;

    if (videoCaptionTextEditingController.text.trim().length <= 0){
      return null;
    }


    File videoThumb = File(uploadBloc.getVideoThumbPath);
    File videoThumbCompressed = await ImageUtils.getCompressedImageFile(imageFile: videoThumb, maxWidth: 300, quality: 40);



    // Uploads video
    String videoUrl = await profileBloc.uploadFile(
        storagePath: RootStorageNames.users
            + profileBloc.getProfileUserId
            + StorageFilePaths.videos
            + Timestamp.now().millisecondsSinceEpoch.toString()
            + StorageFileExtensions.mp4,
        file: videoFile
    );

    // Uploads video image/thumb
    String videoThumbUrl = await profileBloc.uploadFile(
        storagePath: RootStorageNames.users
            + profileBloc.getCurrentUserId
            + StorageFilePaths.video_thumbs
            + Timestamp.now().millisecondsSinceEpoch.toString()
            + StorageFileExtensions.jpg,
        file: videoThumb
    );

    // Uploads video image thumbnail
    String videoThumbCompressedUrl = await profileBloc.uploadFile(
        storagePath: RootStorageNames.users
            + profileBloc.getCurrentUserId
            + StorageFilePaths.video_thumbs_thumbs
            + Timestamp.now().millisecondsSinceEpoch.toString()
            + StorageFileExtensions.jpg,
        file: videoThumbCompressed
    );



    VideoModel videoModel = VideoModel(
        videoThumb: videoThumbUrl,
        videoUrl: videoUrl,
        timestamp: Timestamp.now().millisecondsSinceEpoch,
        talentType: uploadBloc.getTalentType,
        videoCategory: VideoCategory.normal,
        duration: uploadBloc.getVideoDurationInSeconds,
      videoImage: videoThumbUrl
    );

    /*
    profileBloc.addVideoData(videoModel: videoModel, profileUserId: profileBloc.getProfileUserId).then((String videoDataId){


      OptimisedVideoPreviewModel optimisedVideoPreviewModel = OptimisedVideoPreviewModel(
        caption: uploadBloc.getCleanedVideoCaptionText,
        v_thumb: videoThumbCompressedUrl,
        t: Timestamp.now().millisecondsSinceEpoch,
        t_type: uploadBloc.getTalentType,
        v_category: VideoCategory.normal,
        username: profileBloc.getProfileUserModel.username
      );

      profileBloc.addVideoPreviewData(optimisedVideoPreviewModel: optimisedVideoPreviewModel, videoId: videoDataId, profileUserId: profileBloc.getProfileUserId);


      // manually adds video to profile video list stream
      videoModel.videoId = videoDataId;
      //profileBloc.getVideosList.insert(0, videoModel);
      //profileBloc.addVideosListToStream(profileBloc.getVideosList);

    });
    */




    return true;
  }





  Future<void> onCaptionTextChanged({@required BuildContext uploadContext, String text})async{

    ProfileUploadBloc _bloc = ProfileUploadBlocProvider.of(uploadContext).uploadBloc;


    if (text.trim().length > 0){
      _bloc.addVideoCaptionToStream(videoCaption: text);
    }
    else{
      //await _bloc.getVideoCaptionTextEditingStream.drain();
    }

  }


  void onTalentTypeSelected({@required BuildContext uploadContext, String talentType}){

    ProfileUploadBloc _bloc = ProfileUploadBlocProvider.of(uploadContext).uploadBloc;
    _bloc.addTalentTypeToStream(talentType: talentType);
  }



}