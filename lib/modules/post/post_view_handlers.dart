import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/widgets/option_menu/option_menu.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:iris_social_network/widgets/marquee/marquee.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/modules/post/post.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/services/constants/app_constants.dart' as app_contants;
import 'package:file_picker/file_picker.dart';
import 'post_bloc.dart';
import 'post_bloc_provider.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:iris_social_network/services/server_services/constants.dart';


import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/utils/image_utils.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';

import 'package:iris_social_network/modules/profile/profile_bloc.dart';

import 'package:iris_social_network/services/optimised_models/optimised_post_model.dart';
import 'package:iris_social_network/modules/home/home_bloc_provider.dart';
import 'package:iris_social_network/services/server_services/constants.dart';




class PostViewHandlers{

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



  Future<void> showUploadImageOptionDialog({@required BuildContext postContext}){

    PostBloc _bloc = PostBlocProvider.of(postContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(postContext);
    double screenwidth = MediaQuery.of(postContext).size.width;
    double screenHeight = MediaQuery.of(postContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: postContext,
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

                      _bloc.getPostImagesPaths.add(imageFile.path);
                      _bloc.addImagesPathToStream(_bloc.getPostImagesPaths);

                      // Change background image when image is received
                      // and scrolls to image
                      _bloc.addPostBackgroundImageToStream(imageFile.path);
                      PostBlocProvider.of(postContext).imagesSwiperController.move(_bloc.getPostImagesPaths.length - 1);



                      if (_bloc.getPostImagesPaths.length == app_contants.AppFeaturesLimits.IMAGES_PER_POST_LIMIT){
                        _bloc.addIsPostImagesLimitReachedToStream(true);
                      }


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

                      _bloc.getPostImagesPaths.add(imageFile.path);
                      _bloc.addImagesPathToStream(_bloc.getPostImagesPaths);

                      // Change background image when image is received
                      // and scrolls to image
                      _bloc.addPostBackgroundImageToStream(imageFile.path);
                      PostBlocProvider.of(postContext).imagesSwiperController.move(_bloc.getPostImagesPaths.length - 1);


                      if (_bloc.getPostImagesPaths.length == app_contants.AppFeaturesLimits.IMAGES_PER_POST_LIMIT){
                        _bloc.addIsPostImagesLimitReachedToStream(true);
                      }

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




  Future<void> showChangeSelectedUploadImageOptionDialog({@required BuildContext postContext, @required int imageToChangeIndexInList}){


    PostBloc _bloc = PostBlocProvider.of(postContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(postContext);
    double screenwidth = MediaQuery.of(postContext).size.width;
    double screenHeight = MediaQuery.of(postContext).size.height;
    double scaleFactor = 0.125;


    showDialog(
        context: postContext,
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


                      _bloc.getPostImagesPaths.remove(_bloc.getPostImagesPaths.removeAt(imageToChangeIndexInList));
                      _bloc.getPostImagesPaths.insert(imageToChangeIndexInList, imageFile.path);
                      _bloc.addImagesPathToStream(_bloc.getPostImagesPaths);


                      // Change background image when image is received
                      _bloc.addPostBackgroundImageToStream(imageFile.path);


                      if (_bloc.getPostImagesPaths.length == app_contants.AppFeaturesLimits.IMAGES_PER_POST_LIMIT){
                        _bloc.addIsPostImagesLimitReachedToStream(true);
                      }

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
                    optionItemPosition: OptionItemPosition.TOP_END,
                    onTap: () async{

                      File imageFile = await getImageFromGallery();


                      _bloc.getPostImagesPaths.remove(_bloc.getPostImagesPaths.removeAt(imageToChangeIndexInList));
                      _bloc.getPostImagesPaths.insert(imageToChangeIndexInList, imageFile.path);
                      _bloc.addImagesPathToStream(_bloc.getPostImagesPaths);


                      // Change background image when image is received
                      _bloc.addPostBackgroundImageToStream(imageFile.path);


                      if (_bloc.getPostImagesPaths.length == app_contants.AppFeaturesLimits.IMAGES_PER_POST_LIMIT){
                        _bloc.addIsPostImagesLimitReachedToStream(true);
                      }

                      Navigator.pop(context);
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


                      _bloc.getPostImagesPaths.removeAt(imageToChangeIndexInList);
                      _bloc.addImagesPathToStream(_bloc.getPostImagesPaths);


                      if (_bloc.getPostImagesPaths.length < app_contants.AppFeaturesLimits.IMAGES_PER_POST_LIMIT){
                        _bloc.addIsPostImagesLimitReachedToStream(false);
                      }

                      if (_bloc.getPostImagesPaths.length <= 0){
                        _bloc.addPostBackgroundImageToStream(null);
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


  Future<void> showVideoThumbNailView({@required BuildContext postContext, @required String videoThumbNailPath}){


    PostBloc _bloc = PostBlocProvider.of(postContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(postContext);
    double screenWidth = MediaQuery.of(postContext).size.width;
    double screenHeight = MediaQuery.of(postContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: postContext,
        builder: (BuildContext context){

          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: StreamBuilder<String>(
                      stream: _bloc.getVideoThumbNailPathStream,
                      builder: (context, snapshot) {

                        if (snapshot.hasData){
                          return Image.file(File(snapshot.data));
                        }
                        else{
                          return Container();
                        }
                      }
                    ),
                  ),

                  GestureDetector(
                    onTap: (){

                      showDialog(
                          context: postContext,
                          builder: (BuildContext context){

                            return Center(
                              child: OptionMenu(
                                width: screenWidth * 0.75,
                                height: screenWidth * 0.75,
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

                                        _bloc.addVideoThumbNailPathToStream(imageFile.path);
                                        _bloc.setVideoThumbPath = imageFile.path;

                                        // Change background image when image is received
                                        _bloc.addPostBackgroundImageToStream(imageFile.path);

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
                                    optionItemPosition: OptionItemPosition.TOP_END,
                                    onTap: () async{

                                      File imageFile = await getImageFromGallery();

                                      _bloc.addVideoThumbNailPathToStream(imageFile.path);
                                      _bloc.setVideoThumbPath = imageFile.path;

                                      // Change background image when image is received
                                      _bloc.addPostBackgroundImageToStream(imageFile.path);

                                      Navigator.pop(context);
                                    },

                                  ),
                                ),


                              ),
                            );

                          }
                      );

                    },

                    child: Column(
                      children: <Widget>[

                        StreamBuilder<String>(
                          stream: _bloc.getVideoThumbNailPathStream,
                          builder: (context, snapshot) {
                            return Container(
                              width: screenWidth * scaleFactor,
                              height: screenWidth * scaleFactor,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.2),
                                  color: Colors.white.withOpacity(0.1),
                                  image: DecorationImage(
                                      image: FileImage(File(snapshot.hasData? snapshot.data: "")),
                                      fit: BoxFit.cover
                                  )
                              ),
                              child: Container(
                                  width: screenWidth * scaleFactor,
                                  height: screenWidth * scaleFactor,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.2),
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                  child: Icon(Icons.add, color: Colors.white,)
                              ),
                            );
                          }
                        ),
                        Container(
                          color: Colors.transparent,
                            child: SizedBox(height: 10.0,)
                        ),

                        Text("Change Thumbnail",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          );

        }
    );
  }







  Future<void> showUploadAudioImageOptionDialog({@required BuildContext postContext}){


    PostBloc _bloc = PostBlocProvider.of(postContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(postContext);
    double screenwidth = MediaQuery.of(postContext).size.width;
    double screenHeight = MediaQuery.of(postContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: postContext,
        builder: (BuildContext context){

          return Center(
            child: OptionMenu(
              width: screenwidth * 0.75,
              height: screenwidth * 0.75,
              backgroundColor: RGBColors.white,
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

                      _bloc.addAudioImagePathToStream(imageFile.path);
                      _bloc.addImagesPathToStream(_bloc.getPostImagesPaths);

                      // Change background image when image is received
                      _bloc.addPostBackgroundImageToStream(imageFile.path);


                      Navigator.pop(context);
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

                      _bloc.addAudioImagePathToStream(imageFile.path);
                      _bloc.addImagesPathToStream(_bloc.getPostImagesPaths);

                      // Change background image when image is received
                      _bloc.addPostBackgroundImageToStream(imageFile.path);


                      Navigator.pop(context);

                    },
                    optionItemPosition: OptionItemPosition.CENTER_END

                ),
              ),


            ),
          );

        }
    );
  }




  Future<void> showChangeSelectedUploadAudioImageOptionDialog({@required BuildContext postContext}){


    PostBloc _bloc = PostBlocProvider.of(postContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(postContext);
    double screenwidth = MediaQuery.of(postContext).size.width;
    double screenHeight = MediaQuery.of(postContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: postContext,
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


                      _bloc.addAudioImagePathToStream(imageFile.path);

                      // Change background image when image is received
                      _bloc.addPostBackgroundImageToStream(imageFile.path);



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
                  optionItemPosition: OptionItemPosition.TOP_END,
                  onTap: () async{

                    File imageFile = await getImageFromGallery();

                    _bloc.addAudioImagePathToStream(imageFile.path);

                    // Change background image when image is received
                    _bloc.addPostBackgroundImageToStream(imageFile.path);

                    Navigator.pop(context);
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


                      _bloc.addPostBackgroundImageToStream(null);
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




  Stream<bool> getPostSetupCompleteObservable({@required BuildContext postContext}){

    PostBloc _bloc = PostBlocProvider.of(postContext).bloc;

    String postType = PostBlocProvider.of(postContext).postType;

    if (postType == constants.PostType.image){
      return _bloc.getIsPostImageSetupCompleteObservable;
    }
    else if(postType == constants.PostType.video){
      return _bloc.getIsPostVideoSetupCompleteObservable;
    }
    else if (postType == constants.PostType.audio){
      return _bloc.getIsPostAudioSetupCompleteObservable;
    }
    else{
      return null;
    }

  }



  Future<void> publishPostImageData({@required BuildContext postContext})async{

    PostBlocProvider _provider = PostBlocProvider.of(postContext);
    PostBloc _bloc = PostBlocProvider.of(postContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(postContext);
    double screenWidth = MediaQuery.of(postContext).size.width;
    double screenHeight = MediaQuery.of(postContext).size.height;
    double scaleFactor = 0.125;



    AppBlocProvider.of(postContext).handler.showProgressPercentDialog(context: postContext, progressPercentRatioStream: _bloc.getPercentRatioProgressStream);


    if (_bloc.getPostImagesPaths != null && _bloc.getPostImagesPaths.length > 0){

      List<String> postImagesUrlList = List<String>();
      List<String> postImagesThumbsUrlList = List<String>();

      bool uploadError = false;

      for (int index = 0; index < _bloc.getPostImagesPaths.length; ++index){


        File imageFile = File(_bloc.getPostImagesPaths[index]);

        File imageThumbFile = await ImageUtils.getCompressedImageFile(
            imageFile: imageFile,
            maxWidth: ImageOptions.maxWidthMedium,
            quality: ImageOptions.qualityMedium
        );


        FileModel imageFileModel = await _bloc.uploadFile(
            sourceFile: imageFile,
            filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            progressSink: _bloc.getProgressTransferDataSink,
            totalSink: _bloc.getTotalTransferDataSink
        );

        //_bloc.addPercentRatioProgress(0.0);

        FileModel imageThumbFileModel = await _bloc.uploadFile(
            sourceFile: imageThumbFile,
            filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            progressSink: _bloc.getProgressTransferDataSink,
            totalSink: _bloc.getTotalTransferDataSink
        );


        if (imageFileModel == null || imageThumbFileModel == null){
          Navigator.of(postContext).pop();
          BasicUI.showSnackBar(context: postContext, message: "An error occured during upload", textColor: RGBColors.red);

          uploadError = true;
          break;
        }
        else{

          postImagesUrlList.add(imageFileModel.fileUrl);
          postImagesThumbsUrlList.add(imageThumbFileModel.fileUrl);
        }

      }


      /*
      if (postImagesUrlList.length != _bloc.getPostImagesPaths.length && postImagesThumbsUrlList.length != _bloc.getPostImagesPaths.length){
        return;
      }
      */
      if (uploadError){

        Navigator.of(postContext).pop();
        BasicUI.showSnackBar(context: postContext, message: "An error occured during upload", textColor: RGBColors.red);

        return;
      }
      else{

        // get current user data
        UserModel currentUserModel = await AppBlocProvider.of(postContext).bloc.getAllCurrentUserData(
            currentUserId: AppBlocProvider.of(postContext).bloc.getCurrentUserId
        );

        ImageModel imageModel = ImageModel(
            imagesUrl: postImagesUrlList,
            imagesThumbsUrl: postImagesThumbsUrlList,
            timestamp: Timestamp.now().microsecondsSinceEpoch,
        );

        PostModel postModel = PostModel(
            userId: AppBlocProvider.of(postContext).bloc.getCurrentUserId,
            postType: _provider.postType,
            postAudience: _bloc.getPostAudience,
            postData: imageModel.toJson(),
            postCaption: _provider.postCaptionTextEditingController.text.trim().isEmpty ? "".trim():  _provider.postCaptionTextEditingController.text,
            timestamp: Timestamp.now(),
            userName: currentUserModel.username,
            userThumb: currentUserModel.profileThumb,
            userProfileName: currentUserModel.profileName,
          friendsIdsList: _bloc.getPostAudience == app_contants.PostAudience.private? currentUserModel.getAllCurrentUserFriendsIdsList(): List<String>()
        );

        _bloc.addPostData(postModel: postModel, currentUserId: AppBlocProvider.of(postContext).bloc.getCurrentUserId).then((String postId){

          // Do something with the post Id
          _bloc.addOptimisedPostData(
              optimisedPostModel: OptimisedPostModel(t: Timestamp.now().millisecondsSinceEpoch),
              currentUserId: AppBlocProvider.of(postContext).bloc.getCurrentUserId,
              postId: postId
          );

        });


        Navigator.of(postContext).pop();
        BasicUI.showSnackBar(
            context: postContext,
            message: "Post was Published", textColor: _themeData.primaryColor
        );



        // refreshes post screen of profile bloc
        if (_provider.dynamicBloc is ProfileBloc){

          ProfileBloc profileBloc = _provider.dynamicBloc;
          profileBloc.loadPosts(

              profileUserId: profileBloc.getProfileUserId,
              postType: null,
              postQueryType: app_contants.POST_QUERY_TYPE.MOST_RECENT,
              postQueryLimit: app_contants.DatabaseQueryLimits.POSTS_QUERY_LIMIT
          );
        }


        Timer(Duration(seconds: 2), (){
          Navigator.of(postContext).pop();
        });

        // delete cache for flutter video compress library
        FlutterVideoCompress().deleteAllCache();

        // This will disable the button
        // since post audience is among the essential parameter to activate the button
        _bloc.addPostAudience(null);
      }



    }
    else{

      Navigator.of(postContext).pop();
      BasicUI.showSnackBar(context: postContext, message: "No images were selected", textColor: RGBColors.red);

    }


  }












  Future<void> publishPostVideoData({@required BuildContext postContext})async{

    PostBlocProvider _provider = PostBlocProvider.of(postContext);
    PostBloc _bloc = PostBlocProvider.of(postContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(postContext);
    double screenWidth = MediaQuery.of(postContext).size.width;
    double screenHeight = MediaQuery.of(postContext).size.height;
    double scaleFactor = 0.125;



    AppBlocProvider.of(postContext).handler.showProgressPercentDialog(context: postContext, progressPercentRatioStream: _bloc.getPercentRatioProgressStream);


    if (_bloc.getVideoPath != null && _bloc.getVideoThumbPath != null){


      //File compressedVideoFile = await _bloc.compressVideo(videoPath: _bloc.getVideoPath);

      File videoFile = File(_bloc.getVideoPath);

      File imageFile = File(_bloc.getVideoThumbPath);

      File imageThumbFile = await ImageUtils.getCompressedImageFile(
          imageFile: imageFile,
          maxWidth: ImageOptions.maxWidthMedium,
          quality: ImageOptions.qualityMedium
      );


      // video file model
      FileModel videoFileModel = await _bloc.uploadFile(
          sourceFile: videoFile,
          filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.mp4,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );

      // video image file model
      FileModel imageFileModel = await _bloc.uploadFile(
          sourceFile: imageFile,
          filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );

      // video image thumb file model
      FileModel imageThumbFileModel = await _bloc.uploadFile(
          sourceFile: imageThumbFile,
          filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );


      if (videoFileModel == null || imageFileModel == null || imageThumbFileModel == null){
        Navigator.of(postContext).pop();
        BasicUI.showSnackBar(context: postContext, message: "An error occured during upload", textColor: RGBColors.red);

        return;
      }
      else{


        // get current user data
        UserModel currentUserModel = await AppBlocProvider.of(postContext).bloc.getAllCurrentUserData(
            currentUserId: AppBlocProvider.of(postContext).bloc.getCurrentUserId
        );



        VideoModel videoModel = VideoModel(
            videoImage: imageFileModel.fileUrl,
            videoThumb: imageThumbFileModel.fileUrl,
            videoUrl: videoFileModel.fileUrl,
            timestamp: Timestamp.now().microsecondsSinceEpoch,
            talentType: null,
            videoCategory: null,
            duration: ((await _bloc.getMediaInfo(mediaPath: videoFile.path)).duration / 1000).floor(),

        );

        PostModel postModel = PostModel(
            userId: AppBlocProvider.of(postContext).bloc.getCurrentUserId,
            postType: _provider.postType,
            postAudience: _bloc.getPostAudience,
            postData: videoModel.toJson(),
            postCaption: _provider.postCaptionTextEditingController.text.trim().isEmpty ? "".trim():  _provider.postCaptionTextEditingController.text,
            timestamp: Timestamp.now(),
            userName: currentUserModel.username,
            userThumb: currentUserModel.profileThumb,
            userProfileName: currentUserModel.profileName,
            friendsIdsList: _bloc.getPostAudience == app_contants.PostAudience.private? currentUserModel.getAllCurrentUserFriendsIdsList(): List<String>()
        );

        _bloc.addPostData(postModel: postModel, currentUserId: AppBlocProvider.of(postContext).bloc.getCurrentUserId).then((String postId){

          // Do something with the post Id
          // Do something with the post Id
          _bloc.addOptimisedPostData(
              optimisedPostModel: OptimisedPostModel(t: Timestamp.now().millisecondsSinceEpoch),
              currentUserId: AppBlocProvider.of(postContext).bloc.getCurrentUserId,
              postId: postId
          );

        });


        Navigator.of(postContext).pop();
        BasicUI.showSnackBar(
            context: postContext,
            message: "Post was Published", textColor: _themeData.primaryColor
        );


        // refreshes post screen of profile bloc
        if (_provider.dynamicBloc is ProfileBloc){

          ProfileBloc profileBloc = _provider.dynamicBloc;
          profileBloc.loadPosts(
              profileUserId: profileBloc.getProfileUserId,
              postType: null,
              postQueryType: app_contants.POST_QUERY_TYPE.MOST_RECENT,
              postQueryLimit: app_contants.DatabaseQueryLimits.POSTS_QUERY_LIMIT
          );
        }


        Timer(Duration(seconds: 2), (){
          Navigator.of(postContext).pop();
        });


        // delete cache for flutter video compress library
        FlutterVideoCompress().deleteAllCache();


        // This will disable the button
        // since post audience is among the essential parameter to activate the button
        _bloc.addPostAudience(null);
      }


    }
    else{

      Navigator.of(postContext).pop();
      BasicUI.showSnackBar(context: postContext, message: "Media was not Selected", textColor: RGBColors.red);

    }


  }






  Future<void> publishPostAudioData({@required BuildContext postContext})async{

    PostBlocProvider _provider = PostBlocProvider.of(postContext);
    PostBloc _bloc = PostBlocProvider.of(postContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(postContext);
    double screenWidth = MediaQuery.of(postContext).size.width;
    double screenHeight = MediaQuery.of(postContext).size.height;
    double scaleFactor = 0.125;




    AppBlocProvider.of(postContext).handler.showProgressPercentDialog(context: postContext, progressPercentRatioStream: _bloc.getPercentRatioProgressStream);


    if (_bloc.getAudioPath != null){


      File audioFile = File(_bloc.getAudioPath);

      File imageFile;
      File imageThumbFile;

      FileModel imageFileModel;
      FileModel imageThumbFileModel;


      if (_bloc.getAudioImage != null){
        imageFile = File(_bloc.getAudioImage);

        imageThumbFile = await ImageUtils.getCompressedImageFile(
            imageFile: imageFile,
            maxWidth: ImageOptions.maxWidthMedium,
            quality: ImageOptions.qualityMedium
        );

        imageFileModel = await _bloc.uploadFile(
            sourceFile: imageFile,
            filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            progressSink: _bloc.getProgressTransferDataSink,
            totalSink: _bloc.getTotalTransferDataSink
        );

        imageThumbFileModel = await _bloc.uploadFile(
            sourceFile: imageThumbFile,
            filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
            progressSink: _bloc.getProgressTransferDataSink,
            totalSink: _bloc.getTotalTransferDataSink
        );
      }



      // audio file model
      FileModel audioFileModel = await _bloc.uploadFile(
          sourceFile: audioFile,
          filename: "${Timestamp.now().microsecondsSinceEpoch}" + FileExtensions.mp3,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );


      if (audioFileModel == null
          || (_bloc.getAudioImage != null && imageFileModel == null)
          || (_bloc.getAudioImage != null && imageThumbFileModel == null)
      ){

        Navigator.of(postContext).pop();
        BasicUI.showSnackBar(context: postContext, message: "An error occured during upload", textColor: Colors.red);

        return;
      }
      else{

        // get current user data
        UserModel currentUserModel = await AppBlocProvider.of(postContext).bloc.getAllCurrentUserData(
            currentUserId: AppBlocProvider.of(postContext).bloc.getCurrentUserId
        );

        AudioModel audioModel = AudioModel(
            audioImage: imageFileModel != null? imageFileModel.fileUrl: null,
            audioThumb: imageThumbFileModel != null? imageThumbFileModel.fileUrl: null,
            audioUrl: audioFileModel.fileUrl,
            timestamp: Timestamp.now().microsecondsSinceEpoch,
            duration: _bloc.getAudioDuration,
        );

        PostModel postModel = PostModel(
            userId: AppBlocProvider.of(postContext).bloc.getCurrentUserId,
            postType: _provider.postType,
            postAudience: _bloc.getPostAudience,
            postData: audioModel.toJson(),
            timestamp: Timestamp.now(),
            userName: currentUserModel.username,
            userThumb: currentUserModel.profileThumb,
            userProfileName: currentUserModel.profileName,
            postCaption: _provider.postCaptionTextEditingController.text.trim().isEmpty ? "".trim():  _provider.postCaptionTextEditingController.text,
            friendsIdsList: _bloc.getPostAudience == app_contants.PostAudience.private? currentUserModel.getAllCurrentUserFriendsIdsList(): List<String>()
        );

        _bloc.addPostData(postModel: postModel, currentUserId: AppBlocProvider.of(postContext).bloc.getCurrentUserId).then((String postId){

          // Do something with the post Id
          _bloc.addOptimisedPostData(
              optimisedPostModel: OptimisedPostModel(t: Timestamp.now().millisecondsSinceEpoch),
              currentUserId: AppBlocProvider.of(postContext).bloc.getCurrentUserId,
              postId: postId
          );

        });


        Navigator.of(postContext).pop();
        BasicUI.showSnackBar(
            context: postContext,
            message: "Post was Published", textColor: _themeData.primaryColor
        );


        // refreshes post screen of profile bloc
        if (_provider.dynamicBloc is ProfileBloc){

          ProfileBloc profileBloc = _provider.dynamicBloc;
          profileBloc.loadPosts(
              profileUserId: profileBloc.getProfileUserId,
              postType: null,
              postQueryType: app_contants.POST_QUERY_TYPE.MOST_RECENT,
              postQueryLimit: app_contants.DatabaseQueryLimits.POSTS_QUERY_LIMIT
          );
        }

        Timer(Duration(seconds: 2), (){
          Navigator.of(postContext).pop();
        });

        // delete cache for flutter video compress library
        FlutterVideoCompress().deleteAllCache();

        // This will disable the button
        // since post audience is among the essential parameter to activate the button
        _bloc.addPostAudience(null);
      }


    }
    else{

      Navigator.of(postContext).pop();
      BasicUI.showSnackBar(context: postContext, message: "Post Setup is not Complete", textColor: RGBColors.red);

    }


  }



}