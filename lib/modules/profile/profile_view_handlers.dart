import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat.dart';
import 'package:iris_social_network/modules/settings/settings.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_notification_model.dart';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'package:iris_social_network/utils/string_utils.dart';
import 'package:iris_social_network/widgets/option_menu/option_menu.dart';
import 'package:iris_social_network/widgets/particles/confetti_particles.dart';
import 'profile_bloc_provider.dart';
import 'profile_bloc.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'profile_views.dart';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_ff_model.dart';
import 'package:iris_social_network/modules/profile/profile_upload/profile_upload.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:iris_social_network/widgets/marquee/marquee.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/modules/post/post.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iris_social_network/widgets/audio_recorder_picker/audio_recorder_picker.dart';

import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/modules/previews/posts_previews.dart';
import 'profile.dart';
import 'package:animator/animator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;



class ProfileViewHandlers{


  Future<void> showUnfollowUserActionDialog({@required BuildContext profileContext}){

    ProfileBloc _bloc = ProfileBlocProvider.of(profileContext).bloc;

    showCupertinoModalPopup(
        context: profileContext,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text("Do you want to unfollow this User?"),
            actions: <Widget>[

              CupertinoActionSheetAction(

                child: Center(
                    child: Text("Yes", style: TextStyle(color: CupertinoTheme.of(context).primaryColor),)
                ),
                onPressed: (){



                    _bloc.removeProfileUserFollower(
                        currentUserId: AppBlocProvider.of(profileContext).bloc.getCurrentUserId,
                        profileUserId: _bloc.getProfileUserModel.userId
                    );

                    _bloc.removeCurrentUserFollowing(
                        profileUserId: _bloc.getProfileUserId,
                        currentUserId: _bloc.getCurrentUserId
                    );


                    AppBlocProvider.of(context).bloc.decreaseUserPoints(
                        userId: _bloc.getProfileUserId,
                        points: achievements_services.RewardsTypePoints.followers_growth_reward_point
                    );

                    _bloc.setNumberOfFollowers = _bloc.getNumberOfFollowers - 1;
                    _bloc.addNumberOfFollowersToStream(_bloc.getNumberOfFollowers);

                    Navigator.pop(context);
                },
              ),

              CupertinoActionSheetAction(
                child: Center(
                    child: Text("No", style: TextStyle(color: CupertinoTheme.of(context).primaryColor))
                ),
                onPressed: () => Navigator.pop(context),
              ),

            ],

            /*
            cancelButton: CupertinoActionSheetAction(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Cancel"),
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            */

          );
        }
    );

  }
  



  Future<void> showProfileOptionMenuDialog({@required BuildContext profileContext}){

    ProfileBloc profileBloc = ProfileBlocProvider.of(profileContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(profileContext);
    double screenwidth = MediaQuery.of(profileContext).size.width;
    double screenHeight = MediaQuery.of(profileContext).size.height;
    double scaleFactor = 0.125;


    showDialog(
        context: profileContext,
        builder: (BuildContext context){

          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 0.0,
              sigmaY: 0.0
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[


                OptionMenu(
                  width: screenwidth * 0.75,
                  height: screenwidth * 0.75,
                  backgroundColor: RGBColors.white,
                  foregroundColor: _themeData.primaryColor,

                  bottomCenter: Container(
                    key: GlobalKey(),
                    child: OptionMenuItem(
                      iconData: CupertinoIcons.settings,
                      label: "My Settings",
                      mini: false,
                      optionItemPosition: OptionItemPosition.BOTTOM_CENTER,
                      returnItemPostionState: false,
                      onTap: (){

                        Navigator.pop(context);
                        Navigator.of(profileContext).push(MaterialPageRoute(builder: (BuildContext context) => Settings()));

                      },
                    ),
                  ),


                  topCenter: Container(
                    key: GlobalKey(),
                    child: OptionMenuItem(
                        iconData: Icons.edit,
                        label: "Create Post",
                        mini: false,
                        returnItemPostionState: false,
                        onTap: () {

                          showDialog(
                              context: profileContext,
                              builder: (BuildContext context){

                                return BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 0.0,
                                      sigmaY: 0.0
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

                                              String message = "Video should be ${AppFeaturesLimits.VIDEO_DURATION_IN_SECONDS_LIMIT} seconds Max" +
                                                  " and ${AppFeaturesLimits.UPLOAD_VIDEO_SIZE_IN_BYTES_LIMIT / 1000000} MB Max";


                                              bool proceed = await showMediaRestrictionInfoActionDialog(
                                                  context: context,
                                                  message: message
                                              );

                                              if (proceed != true){
                                                return;
                                              }

                                              File videoFile = await getVideoFromCamera();

                                              if (videoFile != null){

                                                int videoDurationInSeconds = await validateVideo(videoFile: videoFile);
                                                if (videoDurationInSeconds == null){

                                                  Navigator.pop(context);
                                                  BasicUI.showSnackBar(
                                                      context: profileContext,
                                                      message: message,
                                                      textColor: RGBColors.red
                                                  );
                                                }
                                                else{

                                                  Navigator.pop(context);
                                                  //await showVideoUploadDialog(profileContext: profileContext, videoFile: videoFile, videoDurationInSeconds: videoDurationInSeconds);


                                                  Navigator.of(context).pop();
                                                  Navigator.of(profileContext).push(MaterialPageRoute(
                                                      builder: (BuildContext context) => Post(
                                                        postFile: videoFile,
                                                        postType: constants.PostType.video,
                                                        dynamicBloc: profileBloc,
                                                      )
                                                  ));

                                                  /*
                                                  Navigator.of(profileContext).push(MaterialPageRoute(builder: (BuildContext context){
                                                    return ProfileUpload(videoFile: videoFile, videoDurationInSeconds: videoDurationInSeconds, profileBloc: profileBloc,);
                                                  }));
                                                  */
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


                                                String message = "Video should be ${AppFeaturesLimits.VIDEO_DURATION_IN_SECONDS_LIMIT} seconds Max" +
                                                    " and ${AppFeaturesLimits.UPLOAD_VIDEO_SIZE_IN_BYTES_LIMIT / 1000000} MB Max";


                                                bool proceed = await showMediaRestrictionInfoActionDialog(
                                                    context: context,
                                                    message: message
                                                );

                                                if (proceed != true){
                                                  return;
                                                }

                                                File videoFile = await getVideoFromGallery();

                                                if (videoFile != null){

                                                  int videoDurationInSeconds = await validateVideo(videoFile: videoFile);

                                                  if (videoDurationInSeconds == null){

                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    BasicUI.showSnackBar(
                                                        context: profileContext,
                                                        message: message,
                                                        textColor: RGBColors.red
                                                    );

                                                  }
                                                  else{

                                                    Navigator.of(context).pop();
                                                    //await showVideoUploadDialog(profileContext: profileContext, videoFile: videoFile, videoDurationInSeconds: videoDurationInSeconds);

                                                    /*
                                                    Navigator.of(profileContext).push(MaterialPageRoute(builder: (BuildContext context){
                                                      return ProfileUpload(videoFile: videoFile, videoDurationInSeconds: videoDurationInSeconds, profileBloc: profileBloc,);
                                                    }));
                                                    */

                                                    Navigator.of(context).pop();
                                                    Navigator.of(profileContext).push(MaterialPageRoute(
                                                        builder: (BuildContext context) => Post(
                                                            postFile: videoFile,
                                                            postType: constants.PostType.video,
                                                          dynamicBloc: profileBloc,
                                                        )
                                                    ));
                                                  }
                                                }
                                                else{
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }
                                              },

                                          ),
                                        ),



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
                                                  Navigator.of(profileContext).push(MaterialPageRoute(
                                                      builder: (BuildContext context) => Post(
                                                          postFile: imageFile,
                                                          postType: constants.PostType.image,
                                                        dynamicBloc: profileBloc,
                                                      )
                                                  ));
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
                                                  Navigator.of(profileContext).push(MaterialPageRoute(
                                                      builder: (BuildContext context) => Post(
                                                          postFile: imageFile,
                                                          postType: constants.PostType.image,
                                                        dynamicBloc: profileBloc,
                                                      )
                                                  ));
                                                }
                                                else{
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }
                                              },

                                          ),
                                        ),


                                        bottomCenter: Container(
                                          key: GlobalKey(),
                                          child: OptionMenuItem(
                                            iconData: FontAwesomeIcons.solidFileAudio,
                                            label: "Audio Gallery",
                                            mini: false,
                                            returnItemPostionState: false,
                                            optionItemPosition: OptionItemPosition.BOTTOM_CENTER,
                                            onTap: () async{

                                              String message = "Audio should be ${AppFeaturesLimits.UPLOAD_AUDIO_SIZE_IN_BYTES_LIMIT / 1000000} MB Max";

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
                                                      context: profileContext,
                                                      message: message,
                                                      textColor: RGBColors.red
                                                  );

                                                }
                                                else{
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);

                                                  Navigator.of(profileContext).push(MaterialPageRoute(
                                                      builder: (BuildContext context) => Post(
                                                        postFile: audioFile,
                                                        postType: constants.PostType.audio,
                                                        dynamicBloc: profileBloc,
                                                      )
                                                  ));
                                                }




                                              }
                                              else{
                                                print("aaaaaaaaaaaaaaaaaaaaaaa");
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              }
                                            },

                                          ),
                                        ),



                                        /*
                                        bottomStart: Container(
                                          key: GlobalKey(),
                                          child: OptionMenuItem(
                                            iconData: FontAwesomeIcons.microphoneAlt,
                                            label: "Record Audio",
                                            mini: false,
                                            returnItemPostionState: false,
                                            optionItemPosition: OptionItemPosition.BOTTOM_START,
                                            onTap: () async{

                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();

                                              File audioFile =  await Navigator.of(profileContext).push(MaterialPageRoute(builder: (BuildContext context) => AudioRecorderPicker()));

                                              if (audioFile != null){

                                                Navigator.of(profileContext).push(CupertinoPageRoute(
                                                    builder: (BuildContext context) => Post(
                                                        postFile: audioFile,
                                                        postType: constants.PostType.audio,
                                                      dynamicBloc: profileBloc,
                                                    )
                                                ));
                                              }
                                              else{


                                              }
                                            },

                                          ),
                                        ),
                                        */


                                      ),
                                    ],
                                  ),
                                );

                              }
                          );


                        },
                        optionItemPosition: OptionItemPosition.TOP_CENTER

                    ),
                  ),

                ),
              ],
            ),
          );

        }
    );
  }



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

  Future<File> getRecordAudio()async{

    return null;
  }


  Future<void> showUploadImageOptionDialog({@required BuildContext profileContext}){

    CupertinoThemeData _themeData = CupertinoTheme.of(profileContext);
    double screenwidth = MediaQuery.of(profileContext).size.width;
    double screenHeight = MediaQuery.of(profileContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: profileContext,
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


  Future<int> validateVideo({@required File videoFile}) async{

    VideoPlayerController videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController.initialize();

    Duration videoDuration = videoPlayerController.value.duration;
    int videoSize = videoFile.lengthSync();

    videoPlayerController.dispose();


    if (videoDuration.inSeconds <= AppFeaturesLimits.VIDEO_DURATION_IN_SECONDS_LIMIT &&
        videoSize <= AppFeaturesLimits.UPLOAD_VIDEO_SIZE_IN_BYTES_LIMIT){
      return videoDuration.inSeconds;
    }

    return null;
  }


  Future<int> validateAudio({@required File audioFile}) async{

    int audioSize = audioFile.lengthSync();

    if (audioSize <= AppFeaturesLimits.UPLOAD_AUDIO_SIZE_IN_BYTES_LIMIT){
      return audioSize;
    }
    return null;
  }
  







  Future<bool> _onDeletePost({@required BuildContext profileContext, @required PostModel postModel})async{

    ProfileBloc _bloc = ProfileBlocProvider.of(profileContext).bloc;

    if (_bloc.getCurrentUserId != _bloc.getProfileUserId){

      return  false;
    }
    else{

      AppBlocProvider.of(profileContext).bloc.deleteAllFilesInModelData(dynamicModel: postModel);

      bool postFilesDeleted = true;


     if (postFilesDeleted){

       _bloc.removePostData(postId: postModel.postId, currentUserId: _bloc.getCurrentUserId);

       _bloc.removeOptimisedPostData(postId: postModel.postId, currentUserId: postModel.userId);

       _bloc.removePostComments(postId: postModel.postId, postUserId: postModel.userId);

       _bloc.removePostLikes(postId: postModel.postId, postUserId: postModel.userId);


       _bloc.getPostsList.remove(postModel);
       _bloc.addPostsListToStream(_bloc.getPostsList);
     }
     else{

     }


      return postFilesDeleted;
    }

  }





  Future<void> showPostOptionDialog({@required BuildContext profileContext, @required PostModel postModel})async{

    ProfileBloc profileBloc = ProfileBlocProvider.of(profileContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(profileContext);
    double screenwidth = MediaQuery.of(profileContext).size.width;
    double screenHeight = MediaQuery.of(profileContext).size.height;
    double scaleFactor = 0.125;


    String postImagePreview = "";
    String postCaption = "";

    if (postModel.postType == constants.PostType.video){
      VideoModel videoModel = VideoModel.fromJson(postModel.postData);
      postImagePreview = videoModel.videoThumb ?? "";
      postCaption = postModel.postCaption ?? "";
    }
    else if (postModel.postType == constants.PostType.image){
      ImageModel imageModel = ImageModel.fromJson(postModel.postData);
      postImagePreview = imageModel.imagesThumbsUrl[0] ?? "";
      postCaption = postModel.postCaption ?? "";
    }
    else if (postModel.postType == constants.PostType.audio){
      AudioModel audioModel = AudioModel.fromJson(postModel.postData);
      postImagePreview = audioModel.audioThumb ?? "";
      postCaption = postModel.postCaption ?? "";
    }


    showDialog(
        context: profileContext,
        builder: (BuildContext context){

          return SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0
              ),
              child: Semantics(
                label: "This SingleChildScrollView makes the empty space not dismissible as i want it to be",
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[



                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          SizedBox(height: screenHeight * scaleFactor * 0.5,),

                          Text(postModel.postAudience != null? StringUtils.toUpperCaseLower(postModel.postAudience): "",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenHeight * scaleFactor * 0.25,),

                          Hero(
                            tag: postModel.postId,
                            child:Animator(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              repeats: 1,
                              curve: Curves.easeInOutBack,
                              duration: Duration(seconds: 1),
                              builder: (anim){
                                return Transform.scale(
                                  scale: anim.value,
                                  child: Container(
                                    width: screenwidth * 0.5,
                                    height: screenwidth * 0.5 * 1.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(screenwidth * scaleFactor * 0.33),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(postImagePreview),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  )
                                );
                              },
                            ),
                          ),
                          SizedBox(height: screenwidth * scaleFactor,),

                          Text(
                            postCaption,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: RGBColors.white,
                                fontSize: Theme.of(context).textTheme.headline.fontSize
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),

                        ],
                      ),
                      SizedBox(height: screenwidth * scaleFactor,),


                      OptionMenu(
                        width: screenwidth * 0.75,
                        height: screenwidth * 0.75,
                        backgroundColor: RGBColors.white,
                        foregroundColor: _themeData.primaryColor,

                        topStart: Container(
                          key: GlobalKey(),
                          child: OptionMenuItem(
                            iconData: Icons.delete,
                            label: "Delete Post",
                            mini: false,
                            optionItemPosition: OptionItemPosition.TOP_START,
                            returnItemPostionState: false,
                            onTap: ()async{

                              _showDeletePostActionDialog(profileContext: profileContext, postModel: postModel);
                            },
                          ),
                        ),


                        topEnd: Container(
                          key: GlobalKey(),
                          child: OptionMenuItem(
                              iconData: Icons.close,
                              label: "Cancel",
                              mini: false,
                              returnItemPostionState: false,
                              onTap: () async{

                                Navigator.of(context).pop();
                              },
                              optionItemPosition: OptionItemPosition.TOP_END
                          ),
                        ),


                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

        }
    );
  }











  Future<void> _showDeletePostActionDialog({@required BuildContext profileContext, @required PostModel postModel})async{

    ProfileBloc profileBloc = ProfileBlocProvider.of(profileContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(profileContext);
    double screenwidth = MediaQuery.of(profileContext).size.width;
    double screenHeight = MediaQuery.of(profileContext).size.height;
    double scaleFactor = 0.125;

    showCupertinoModalPopup(
        context: profileContext,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text("Are you sure you want to delete this Post?"),
            actions: <Widget>[

              CupertinoActionSheetAction(

                child: Center(
                    child: Text("Yes", style: TextStyle(color: _themeData.primaryColor),)
                ),
                onPressed: ()async{

                  AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection)async{

                    if (hasInternetConnection != null && hasInternetConnection){

                      BasicUI.showProgressDialog(
                          pageContext: context,
                          child: Column(

                            children: <Widget>[

                              SpinKitFadingCircle(color: _themeData.primaryColor,),
                              SizedBox(height: screenHeight * scaleFactor * 0.25,),

                              Text("Deleting...", style: TextStyle(
                                  color: _themeData.primaryColor,
                                  fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                              ),)

                            ],
                          )
                      );

                      bool success = await _onDeletePost(profileContext: profileContext, postModel: postModel);


                      if (success){

                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);

                        BasicUI.showSnackBar(context: profileContext, message: "Post has been deleted", textColor: _themeData.primaryColor);
                      }
                      else{

                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        BasicUI.showSnackBar(context: profileContext, message: "Post was not deleted. Try again!!", textColor: RGBColors.red);
                      }

                    }
                    else{

                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      BasicUI.showSnackBar(
                          context: profileContext,
                          message: "No Internet Connection",
                          textColor:  CupertinoColors.destructiveRed,
                          duration: Duration(seconds: 1)
                      );
                    }

                  });

                },
              ),

              CupertinoActionSheetAction(
                child: Center(
                    child: Text("No", style: TextStyle(color: _themeData.primaryColor),)
                ),
                onPressed: (){

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),

            ],



          );
        }
    );

  }






  /*

  Widget getPostPreviewWidget({@required BuildContext context, @required PostModel postModel}){

    if (postModel.postType == constants.PostType.video){
      return VideoPostPreviewWidget(postModel: postModel, colorValue: Colors.white.value,);
    }
    else if (postModel.postType == constants.PostType.image){
      return ImagePostPreviewWidget(postModel: postModel, colorValue: Colors.white.value,);
    }
    else if (postModel.postType == constants.PostType.audio){
      return AudioPostPreviewWidget(postModel: postModel, colorValue: Colors.white.value,);
    }
    else{
      return Container();
    }

  }
  */




  Widget getPostPreviewWidget({@required BuildContext context, @required PostModel postModel}){

    ProfileBlocProvider _provider = ProfileBlocProvider.of(context);
    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<int>(

      stream: _bloc.getBackgroundColorValueStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){


        if (postModel.postType == constants.PostType.video){

          return VideoPostPreviewWidget(
            postModel: postModel,
            colorValue: snapshot.hasData? snapshot.data: Colors.white.value,
          );
        }
        else if (postModel.postType == constants.PostType.image){


          return ImagePostPreviewWidget(
            postModel: postModel,
            colorValue: snapshot.hasData? snapshot.data: Colors.white.value,
          );
        }
        else if (postModel.postType == constants.PostType.audio){

          return AudioPostPreviewWidget(
            postModel: postModel,
            colorValue: snapshot.hasData? snapshot.data: Colors.white.value,
          );
        }
        else{
          return Container();
        }

      },
    );

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








  static Future<bool> showProfileHelpDialogAndGetShouldPopAgain({@required BuildContext context})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return await showDialog(
        context: context,
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
                      child: Text("Profile UI Guide", style: TextStyle(color: _themeData.primaryColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
                    ),


                    content: Container(

                      width: screenWidth * 0.75,
                      height: screenHeight * 0.4,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[

                          SizedBox(height: screenHeight * scaleFactor * 0.5,),

                          Text("Slide your Post to PopUp delete Option",
                            textAlign: TextAlign.center,
                          ),

                          Flexible(
                            child: Center(
                              child: Stack(
                                children: <Widget>[


                                  Container(
                                    width: screenWidth * 0.33,
                                    height: screenHeight *  0.25,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: _themeData.primaryColor, width: 2.0)
                                    ),
                                  ),

                                  Animator(
                                      tween: Tween<double>(begin: 1, end: -1),
                                      cycles: 1000000000,
                                      //repeats: 10000000,
                                      curve: Curves.linear,
                                      duration: Duration(milliseconds: 700),
                                      builder: (anim){
                                        return Transform.translate(
                                            offset: Offset(screenHeight * scaleFactor * 0.5 * anim.value, 0.0),
                                            child: Container(
                                              width: screenWidth * 0.33,
                                              height: screenHeight *  0.25,
                                              color: _themeData.primaryColor,
                                            )
                                        );
                                      }
                                  ),
                                ],
                              ),
                            ),
                          )


                        ],
                      ),
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



  Future<void> showFriendshipSuccessModal({@required BuildContext context})async{

    ProfileBloc _bloc = ProfileBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return Stack(
            children: <Widget>[

              Center(
                child: Animator(

                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  //repeats: 1,
                  curve: Curves.easeInOutBack,
                  duration: Duration(seconds: 1),
                  builder: (anim){
                    return Transform.scale(
                      scale: anim.value,
                      child: CupertinoActionSheet(

                        title: Center(
                          //child: Icon(Icons.info_outline)
                          child: Text("Congratulations",
                            style: TextStyle(
                                color: _themeData.primaryColor,
                                fontSize: Theme.of(context).textTheme.headline.fontSize,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),


                        message: Column(
                          children: <Widget>[

                            SizedBox(height: screenHeight * scaleFactor * 0.25,),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[

                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    _bloc.getCurrentUserModel == null? "": _bloc.getCurrentUserModel.profileThumb
                                  ),
                                  backgroundColor: RGBColors.light_grey_level_1,
                                  radius: screenWidth * scaleFactor,
                                ),

                                Icon(FontAwesomeIcons.solidHandshake),

                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      _bloc.getProfileUserModel == null? "": _bloc.getProfileUserModel.profileThumb
                                  ),
                                  backgroundColor: RGBColors.light_grey_level_1,
                                  radius: screenWidth * scaleFactor,
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * scaleFactor * 0.25,),

                            Text("You both are now Friends",
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight * scaleFactor * 0.25,),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[

                                Flexible(
                                  flex: 50,
                                  child: CupertinoButton(
                                    onPressed: (){

                                      Navigator.of(context).pop();
                                    },
                                    child: Center(
                                      child: Text("Return",
                                        style: TextStyle(color: _themeData.primaryColor)
                                      ),
                                    ),
                                  ),
                                ),

                                Flexible(
                                  flex: 50,
                                  child: Center(
                                    child: CupertinoButton(
                                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                      color: _themeData.primaryColor,
                                      onPressed: (){


                                        Navigator.pop(context);

                                        Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => PrivateChat(
                                          currentUserModel: _bloc.getCurrentUserModel,
                                          chatUserModel: _bloc.getProfileUserModel,
                                        )));

                                      },
                                      borderRadius: BorderRadius.circular(100.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[

                                          Icon(FontAwesomeIcons.solidComment),
                                          SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

                                          Text("Chat Now",
                                            style: TextStyle(fontSize: Theme.of(context).textTheme.button.fontSize, fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),

                      ),
                    );
                  },
                ),
              ),



              ConfettiParticles(duration: Duration(seconds: 20),)
            ],
          );
        }
    );

  }











  Future<void> showAcceptFriendRequestActionModal({@required BuildContext profileContext})async{

    ProfileBloc _bloc = ProfileBlocProvider.of(profileContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(profileContext);
    double screenwidth = MediaQuery.of(profileContext).size.width;
    double screenHeight = MediaQuery.of(profileContext).size.height;
    double scaleFactor = 0.125;

    showCupertinoModalPopup(
        context: profileContext,
        builder: (BuildContext context){
          return Center(
            child: Container(
              width: screenwidth * 0.9,
              child: CupertinoActionSheet(
                title: Center(
                  child: RichText(
                      text: TextSpan(
                          //style: DefaultTextStyle.of(context).style,
                        style: TextStyle(color: Colors.black.withOpacity(0.8)),
                          children: <TextSpan>[

                            TextSpan(
                                text: "Do You",
                            ),

                            TextSpan(
                              text: " ACCEPT",
                              style: TextStyle(color: CupertinoColors.activeGreen, fontWeight: FontWeight.bold),
                            ),

                            TextSpan(text: " Friend Request")
                          ]
                      )
                  ),
                ),
                actions: <Widget>[

                  CupertinoActionSheetAction(

                    child: Center(
                        child: Text("Yes", style: TextStyle(color: _themeData.primaryColor),)
                    ),
                    onPressed: ()async{

                      Navigator.of(context).pop();

                      AppBlocProvider.of(profileContext).handler.getHasInternetDataConnection().then((bool hasInternetConnection)async{

                        if (hasInternetConnection != null && hasInternetConnection){


                          // adds profile user to current use friend list
                          _bloc.addFriendToUserFriendList(
                            userId: _bloc.getCurrentUserId,
                            friendModel: FriendModel(
                                userId: _bloc.getProfileUserId,
                                timestamp: Timestamp.now().millisecondsSinceEpoch
                            ),
                          );

                          // adds current user to profile user friend list
                           _bloc.addFriendToUserFriendList(
                            userId: _bloc.getProfileUserId,
                            friendModel: FriendModel(
                                userId: _bloc.getCurrentUserId,
                                timestamp: Timestamp.now().millisecondsSinceEpoch
                            ),
                          );

                          _bloc.sendFriendRequestAcceptedNotification(
                            profileUserId: _bloc.getProfileUserId,
                            optimisedNotificationModel: OptimisedNotificationModel(
                                from: _bloc.getCurrentUserId,
                                n_type: NotificationType.friend_req_accepted,
                                t: Timestamp.now().millisecondsSinceEpoch
                            ),
                          );

                          // remove friend request from profile user
                          _bloc.removeFriendRequest(
                              currentUserId: _bloc.getProfileUserId,
                              profileUserId: _bloc.getCurrentUserId
                          );

                          // remove friend request if sent by current user
                          _bloc.removeFriendRequest(
                              currentUserId: _bloc.getCurrentUserId,
                              profileUserId: _bloc.getProfileUserId
                          );

                          ProfileBlocProvider.of(profileContext).profileViewHandlers.showFriendshipSuccessModal(context: profileContext);


                          // increase points of current user
                          AppBlocProvider.of(context).bloc.increaseUserPoints(
                              userId: _bloc.getCurrentUserId,
                              points: achievements_services.RewardsTypePoints.finding_a_friend_reward_point
                          ).then((_){
                            AppBlocProvider.of(context).handler.showRewardAchievedDialog(
                                pageContext: profileContext,
                                points: achievements_services.RewardsTypePoints.finding_a_friend_reward_point,
                              message: "For You and your New Friend for becoming Friends"
                            );
                          });

                          // increase points of profile user
                          AppBlocProvider.of(context).bloc.increaseUserPoints(
                              userId: _bloc.getProfileUserId,
                              points: achievements_services.RewardsTypePoints.finding_a_friend_reward_point
                          );
                        }
                        else{

                          BasicUI.showSnackBar(
                              context: profileContext,
                              message: "No Internet Connection",
                              textColor:  CupertinoColors.destructiveRed,
                              duration: Duration(seconds: 1)
                          );
                        }

                      });



                    },
                  ),

                  CupertinoActionSheetAction(
                    child: Center(
                        child: Text("No", style: TextStyle(color: _themeData.primaryColor),)
                    ),
                    onPressed: (){

                      Navigator.pop(context);
                    },
                  ),

                ],



              ),
            ),
          );
        }
    );

  }




}








