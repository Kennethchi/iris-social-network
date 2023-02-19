import 'dart:async';

import 'package:iris_social_network/modules/home/home.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:iris_social_network/widgets/avatar_image_generator/avatar_image_generator.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';
import 'package:iris_social_network/utils/image_utils.dart';
import 'account_setup_bloc_provider.dart';
import 'account_setup_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'account_setup_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/widgets/option_menu/option_menu.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_user_model.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;








class AccountSetupViewHandlers{



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



  Future<void> showProfileImageOptionMenuDialog({@required BuildContext accoutSetupContext}){

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(accoutSetupContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(accoutSetupContext);
    double screenwidth = MediaQuery.of(accoutSetupContext).size.width;
    double screenHeight = MediaQuery.of(accoutSetupContext).size.height;
    double scaleFactor = 0.125;


    showDialog(
        context: accoutSetupContext,
        builder: (BuildContext context){

          return Center(
            child: OptionMenu(
              width: screenwidth * 0.66,
              height: screenHeight * 0.4,
              backgroundColor: RGBColors.white,
              foregroundColor: _themeData.primaryColor,


              topStart: Container(
                key: GlobalKey(),
                child: OptionMenuItem(
                    iconData: CupertinoIcons.photo_camera_solid,
                    label: AccountSetupWidgetStrings.profile_image_view_camera_option_text,
                    mini: false,
                    returnItemPostionState: false,
                    onTap: () async{

                      File imageFile = await getImageFromCamera();
                      _bloc.addProfileImageFile(imageFile);

                      Navigator.pop(context);

                    },
                    optionItemPosition: OptionItemPosition.TOP_START

                ),
              ),

              topEnd: OptionMenuItem(
                iconData: Icons.image,
                label: AccountSetupWidgetStrings.profile_image_view_gallery_option_text,
                mini: false,
                optionItemPosition: OptionItemPosition.TOP_END,
                returnItemPostionState: false,
                onTap: ()async{

                  File imageFile  = await getImageFromGallery();
                  _bloc.addProfileImageFile(imageFile);

                  Navigator.of(context).pop();

                },
              ),

              bottomCenter: OptionMenuItem(
                  iconData: FontAwesomeIcons.user,
                  label: "Generate Avatar",
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

                    _bloc.addProfileImageFile(imageFile);

                    Navigator.pop(context);
                  },
                  optionItemPosition: OptionItemPosition.BOTTOM_CENTER
              ),


            ),
          );

        }
    );
  }




  Future<void> saveAccountSetupChanges({@required BuildContext accountSetupContext})async{


    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(accountSetupContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(accountSetupContext);
    double scaleFactor = 0.125;


    /*
    AppBlocProvider.of(accountSetupContext).handler.showProgressPercentDialog(
        context: accountSetupContext, progressPercentRatioStream: _bloc.getPercentRatioProgressStream
    );
    */



    // SHow progress
    BasicUI.showProgressDialog(
        pageContext: accountSetupContext,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitFadingCircle(color: _themeData.primaryColor,),
            SizedBox(
              height: MediaQuery.of(accountSetupContext).size.height * scaleFactor * scaleFactor,
            ),
            Text("Completing Account Setup...", style: TextStyle(color: _themeData.primaryColor),)
          ],
        )
    );




    File profileImageFile = File(_bloc.getProfileImagePath);

    File profileThumbFile = await ImageUtils.getCompressedImageFile(
        imageFile: profileImageFile,
        maxWidth: ImageOptions.maxWidthLow,
        quality: ImageOptions.qualityLow
    );


    FileModel profileImageModel = await _bloc.uploadFile(
        sourceFile: profileImageFile,
        filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpeg,
        progressSink: _bloc.getProgressTransferDataSink,
        totalSink: _bloc.getTotalTransferDataSink
    );

    FileModel profileThumbModel = await _bloc.uploadFile(
        sourceFile: profileThumbFile,
        filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpeg,
        progressSink: _bloc.getProgressTransferDataSink,
        totalSink: _bloc.getTotalTransferDataSink
    );


    if (profileImageFile == null || profileThumbFile == null){
      Navigator.of(accountSetupContext).pop();
      BasicUI.showSnackBar(context: accountSetupContext, message: "An error occured during upload", textColor: RGBColors.red);
    }
    else{

        _bloc.getUserModel.profileImage = profileImageModel.fileUrl;
        _bloc.getUserModel.profileThumb = profileThumbModel.fileUrl;


        // Add timestamp and account_state to user data before storing data in firestore
      _bloc.getUserModel.timestamp = Timestamp.now();

      OptimisedUserModel optimisedUserModel = OptimisedUserModel(
          userId: _bloc.getUserModel.userId,
          username: _bloc.getUserModel.username,
          name: _bloc.getUserModel.profileName,
          thumb: _bloc.getUserModel.profileThumb,
          s: _bloc.getUserModel.profileName.substring(0, 1).toLowerCase()
      );


      // For chat user receving the message, the current user info is found also here
      OptimisedChatModel currentUserChattersModel = OptimisedChatModel(
        chat_user_id: app_constants.getServiceUserId,
        sender_id: app_constants.getServiceUserId,
        t: Timestamp.now().millisecondsSinceEpoch,
        text: "Welcome to Iris",
        seen: false,
        tp: false,
        msg_type: MessageType.text,
      );

      // For chat user receving the message, the current user info is found also here
      OptimisedChatModel chatUserChattersModel = OptimisedChatModel(
        chat_user_id: _bloc.getUserModel.userId,
        sender_id: app_constants.getServiceUserId,
        t: Timestamp.now().millisecondsSinceEpoch,
        text: "Welcome to Iris",
        seen: false,
        tp: false,
        msg_type: MessageType.text,
      );



        // get phone code from shared preferences and adds to userModel
      SharedPreferences.getInstance().then((SharedPreferences prefs){

        _bloc.getUserModel.phoneCode = prefs.getString(SharedPrefsKeys.country_phone_code);



        // --------------------ERROR----------------------------
        // ------------------------------------------------
        //----------------------------------------------------
        // This check got a problem
        // its still sends user to home page even when username is taken
        // ------------------------------------------------
        // ----------------------------------------------------
        // --------------------ERROR-----------------------------
        _bloc.checkUsernameIsTaken(userNameTrial: _bloc.getUserModel.username).then((bool userNameIsTaken){

          if (userNameIsTaken){
            Navigator.of(accountSetupContext).pop();

            BasicUI.showSnackBar(context: accountSetupContext, message: "Sorry!!. A New User Just Signed Up with your Username", textColor: RGBColors.red);

            Timer(Duration(seconds: 5), (){

              AccountSetupBlocProvider.of(accountSetupContext).pageController.animateToPage(1, duration: Duration(seconds: 3), curve: Curves.decelerate);
            });
          }

          else{

            _bloc.addUserProfileData(userModel: _bloc.getUserModel, userId: _bloc.getUserModel.userId).then((_){

              // set account setup complete
              // when set to true.
              SharedPreferences.getInstance().then((SharedPreferences prefs){
                prefs.setBool(SharedPrefsKeys.account_setup_complete + _bloc.getUserModel.userId, true);
              });


              // Waits for few seconds before navigating to home page
              Timer(Duration(seconds: 2), (){

                // go to home
                Navigator.of(accountSetupContext).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
                  return Home(appBloc: AppBlocProvider.of(context).bloc,);
                }), (Route<dynamic> route) => false);
              });

            });


            // adds optimised user data to database
            _bloc.addOptimisedUserData(optimisedUserModel: optimisedUserModel, userId: _bloc.getUserModel.userId);

            // adds chat data to both service chat and to current user chat
            _bloc.addChatsData(chatUserChatterModel: chatUserChattersModel, currentUserChatterModel: currentUserChattersModel);
          }

        });


      });


    }





  }



}


