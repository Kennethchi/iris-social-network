import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'dart:async';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/widgets/assets_audio_picker/assets_audio_picker.dart';
import 'package:iris_social_network/widgets/avatar_image_generator/avatar_image_generator.dart';
import 'package:iris_social_network/widgets/interests_picker/interests_picker.dart';
import 'profile_settings_bloc_provider.dart';
import 'profile_settings_bloc.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/widgets/option_menu/option_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:iris_social_network/utils/image_utils.dart';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';







class ProfileSettingsViewsHandlers{


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



  Future<void> showUploadImageOptionDialog({@required BuildContext profileSettingsContext}){

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(profileSettingsContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(profileSettingsContext);
    double screenwidth = MediaQuery.of(profileSettingsContext).size.width;
    double screenHeight = MediaQuery.of(profileSettingsContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: profileSettingsContext,
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
                      _bloc.addProfileImageToStream(imageFile.path);

                      _bloc.addProfileImageChangedToStream(imageFile.path);

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
                      _bloc.addProfileImageToStream(imageFile.path);

                      _bloc.addProfileImageChangedToStream(imageFile.path);

                      Navigator.pop(context);
                    },
                    optionItemPosition: OptionItemPosition.TOP_END
                ),
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

                      if (imageFile != null){
                        _bloc.addProfileImageToStream(imageFile.path);
                        _bloc.addProfileImageChangedToStream(imageFile.path);
                      }

                      Navigator.pop(context);
                    },
                    optionItemPosition: OptionItemPosition.BOTTOM_CENTER
                ),



            ),
          );

        }
    );
  }






  Future<void> showUpdateProfileNameModalDialog({@required BuildContext profileSettingsContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(profileSettingsContext);
    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(profileSettingsContext).bloc;
    double screenWidth = MediaQuery.of(profileSettingsContext).size.width;
    double screenHeight = MediaQuery.of(profileSettingsContext).size.height;
    double scaleFactor = 0.125;



    await showCupertinoModalPopup(
        context: profileSettingsContext,
        builder: (BuildContext context){
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25)),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text("Profile Name", style: TextStyle(
                              fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
                              color: _themeData.primaryColor
                          ),),
                          SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                          TextField(
                            controller: ProfileSettingsBlocProvider.of(profileSettingsContext).profileNameTextEditingController,
                            maxLines: 1,
                            maxLength: 50,
                            cursorColor: _themeData.primaryColor,
                            decoration: InputDecoration(

                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                                labelStyle: TextStyle(color: Colors.black26),
                              labelText: "Profile Name",

                              suffixIcon: StreamBuilder<String>(
                                stream: _bloc.getProfileNameTextStream,
                                builder: (context, snapshot) {
                                  return CupertinoButton(
                                    onPressed: snapshot.hasData && snapshot.hasError == false? (){

                                      _bloc.addProfileNameToStream(ProfileSettingsBlocProvider.of(profileSettingsContext).profileNameTextEditingController.text);
                                      _bloc.addProfileSettingsChangedToStream(true);

                                      ProfileSettingsBlocProvider.of(profileSettingsContext).profileNameTextEditingController.clear();

                                      Navigator.of(context).pop();
                                    }: null,
                                    child: Text("OK"),
                                  );
                                }
                              )
                            ),

                            onChanged: (String textChanged){

                              _bloc.addProfileNameTextToStream(textChanged);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

    );

  }





  Future<void> showUpdateProfileStatusModalDialog({@required BuildContext profileSettingsContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(profileSettingsContext);
    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(profileSettingsContext).bloc;
    double screenWidth = MediaQuery.of(profileSettingsContext).size.width;
    double screenHeight = MediaQuery.of(profileSettingsContext).size.height;
    double scaleFactor = 0.125;


    await showCupertinoModalPopup(
        context: profileSettingsContext,
        builder: (BuildContext context){
          
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25)),
                    child: Padding(
                      padding:  EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[

                          Text("Profile Status", style: TextStyle(
                              fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
                              color: _themeData.primaryColor
                          ),),
                          SizedBox(height: screenHeight * scaleFactor * scaleFactor,),


                          TextField(
                            controller: ProfileSettingsBlocProvider.of(profileSettingsContext).statusTextEditingController,
                            maxLines: null,
                            maxLength: 300,
                            cursorColor: _themeData.primaryColor,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                                labelStyle: TextStyle(color: Colors.black26),
                                labelText: "Profile Status",
                                suffixIcon: StreamBuilder<String>(
                                  stream: _bloc.getProfileStatusTextStream,
                                  builder: (context, snapshot) {
                                    return CupertinoButton(
                                      onPressed: snapshot.hasData && snapshot.hasError == false?  (){

                                        _bloc.addProfileStatusToStream(ProfileSettingsBlocProvider.of(profileSettingsContext).statusTextEditingController.text);
                                        _bloc.addProfileSettingsChangedToStream(true);

                                        ProfileSettingsBlocProvider.of(profileSettingsContext).statusTextEditingController.clear();

                                        Navigator.of(context).pop();
                                      }: null,
                                      child: Text("OK"),
                                    );
                                  }
                                )
                            ),
                            onChanged: (String textChanged){

                              _bloc.addProfileStatusTextToStream(textChanged);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

    );

  }







  Future<void> showUpdateUsernameModalDialog({@required BuildContext profileSettingsContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(profileSettingsContext);
    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(profileSettingsContext).bloc;


    await showCupertinoModalPopup(
        context: profileSettingsContext,
        builder: (BuildContext context){
          return CupertinoActionSheet(

            title: Center(
                child: Icon(Icons.info_outline)
            ),

            message: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Your username uniquely identifies you on Iris." + "\n" + "You cannot update your username for the next ",
                  style: TextStyle(
                    color: RGBColors.light_grey_level_3,
                  ),
                  children: <TextSpan>[

                    TextSpan(
                        text: " 90 days",
                        style: TextStyle(
                            color: _themeData.primaryColor,
                          fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                        )
                    )

                  ]
              ),
            )

          );
      }
    );

  }




  Future<void> showUpdateGenderTypeModalDialog({@required BuildContext profileSettingsContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(profileSettingsContext);
    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(profileSettingsContext).bloc;


    await showCupertinoModalPopup(
          context: profileSettingsContext,
          builder: (BuildContext context){
            return CupertinoActionSheet(
              message: Text("Choose your Gender"),

              actions: <Widget>[

                CupertinoActionSheetAction(

                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.male),
                          SizedBox(width: 10.0,),
                          Text(GenderType.male, style: TextStyle(
                              color: CupertinoTheme.of(context).primaryColor
                          ),),
                        ],
                      )
                  ),
                  onPressed: ()async{

                    _bloc.addGenderTypeToStream(GenderType.male);
                    _bloc.addProfileSettingsChangedToStream(true);

                    Navigator.of(context).pop();
                  },
                ),

                CupertinoActionSheetAction(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.female),
                      SizedBox(width: 10.0,),
                      Text(GenderType.female, style: TextStyle(
                          color: CupertinoTheme.of(context).primaryColor
                      ),),
                    ],
                  ),
                  onPressed: ()async{

                    _bloc.addGenderTypeToStream(GenderType.female);
                    _bloc.addProfileSettingsChangedToStream(true);

                    Navigator.of(context).pop();
                  },
                ),

                CupertinoActionSheetAction(
                  child: Center(
                      child: Text(GenderType.other, style: TextStyle(
                        color: CupertinoTheme.of(context).primaryColor,
                      ),)
                  ),
                  onPressed: ()async{

                    _bloc.addGenderTypeToStream(GenderType.other);
                    _bloc.addProfileSettingsChangedToStream(true);


                    Navigator.of(context).pop();
                  },
                ),

              ],

            );
      }
    );

  }




  Future<void> saveProfileSettings({@required BuildContext context})async{

    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);


    if (_bloc.getCurrentUpdateDataMap[UsersDocumentFieldNames.profile_image] != null){


      AppBlocProvider.of(context).handler.showProgressPercentDialog(context: context, progressPercentRatioStream: _bloc.getPercentRatioProgressStream);


      File profileImageFile = File(_bloc.getCurrentUpdateDataMap[UsersDocumentFieldNames.profile_image]);

      File profileThumbFile = await ImageUtils.getCompressedImageFile(
          imageFile: profileImageFile,
          maxWidth: ImageOptions.maxWidthLow,
          quality: ImageOptions.qualityLow
      );


      FileModel profileImageModel = await _bloc.uploadFile(
          sourceFile: profileImageFile,
          filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );

      _bloc.addPercentRatioProgress(0.0);

      FileModel profileThumbModel = await _bloc.uploadFile(
          sourceFile: profileThumbFile,
          filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );

      // clears map
      _bloc.getCurrentUpdateDataMap.clear();
      _bloc.addProfileSettingsChangedToStream(null);


      if (profileImageModel == null || profileThumbModel == null){

        Navigator.of(context).pop();
        _bloc.addProfileSettingsChangedToStream(null);
        BasicUI.showSnackBar(context: context, message: "An error occured during upload", textColor: RGBColors.red);
      }
      else{

        _bloc.setupProfileImageUpdateData(profileImageModel.fileUrl);
        _bloc.setupProfileThumbUpdateData(profileThumbModel.fileUrl);


        _bloc.updateProfileSettings(
            currentUserId: _bloc.getCurrentUserModel.userId,
            currentUserUpdateData: _bloc.getCurrentUpdateDataMap
        ).then((_){


          _bloc.updateOptimisedUserData(
              userId: _bloc.getCurrentUserModel.userId,
              updataDataMap: _bloc.getOptimisedUserDataMap)
              .then((_){

            // clears maps data of user  and disable the save button
            _bloc.getCurrentUpdateDataMap.clear();
            _bloc.getOptimisedUserDataMap.clear();
            _bloc.addProfileSettingsChangedToStream(null);

            Navigator.of(context).pop();
            BasicUI.showSnackBar(
                context: context,
                message: "Profile was Updated", textColor: _themeData.primaryColor
            );
          });

        });
      }

    }

    else{

      BasicUI.showProgressDialog(pageContext: context, child: SpinKitFadingCircle(color: _themeData.primaryColor,));


      _bloc.updateProfileSettings(
          currentUserId: _bloc.getCurrentUserModel.userId,
          currentUserUpdateData: _bloc.getCurrentUpdateDataMap
      ).then((_){


        _bloc.updateOptimisedUserData(
            userId: _bloc.getCurrentUserModel.userId,
            updataDataMap: _bloc.getOptimisedUserDataMap)
            .then((_){

          // clears maps data of user  and disable the save button
          _bloc.getCurrentUpdateDataMap.clear();
          _bloc.getOptimisedUserDataMap.clear();
          _bloc.addProfileSettingsChangedToStream(null);

          Navigator.of(context).pop();
          BasicUI.showSnackBar(context: context, message: "Profile was Updated", textColor: _themeData.primaryColor);

        });


      });
    }


  }











  Future<void> showAppThemeColorModalDialog({@required BuildContext profileSettingsContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(profileSettingsContext);
    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(profileSettingsContext).bloc;
    double screenWidth = MediaQuery.of(profileSettingsContext).size.width;
    double screenHeight = MediaQuery.of(profileSettingsContext).size.height;
    double scaleFactor = 0.125;



    bool isColorChanged = await showDialog(
        context: profileSettingsContext,
        builder: (BuildContext context){


          return SafeArea(

            child: Animator(


              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(milliseconds: 750),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: Center(

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.25),
                      child: Container(

                        width: screenWidth,
                        //height: screenHeight * 0.7,

                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.4)
                          ),
                          child: SingleChildScrollView(
                            child: Column(

                              children: <Widget>[


                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.4),
                                  child: Text("Change App Theme Color", style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.subhead.fontSize,
                                      color: Colors.black.withOpacity(0.5),
                                      fontWeight: FontWeight.bold

                                  ),),
                                ),


                                Container(
                                  child: MaterialColorPicker(
                                    allowShades: false, // default true
                                    iconSelected: FontAwesomeIcons.check,
                                    onMainColorChange: (ColorSwatch color) {
                                      // Handle main color changes

                                      _bloc.addAppThemeColorValueToStream(color.value);
                                      _bloc.setAppThemeColorValue = color.value;

                                    },
                                    shrinkWrap: true,
                                    circleSize: screenWidth * 0.15,
                                  ),
                                ),


                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.25),
                                  child: Row(
                                    children: <Widget>[



                                      Flexible(
                                        flex: 33,
                                        fit: FlexFit.tight,
                                        child: CupertinoButton(
                                            onPressed: (){

                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                        )
                                      ),


                                      Flexible(
                                          flex: 33,
                                          fit: FlexFit.tight,
                                          child: CupertinoButton(
                                            child: Text("DEFAULT",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: ()async{

                                              BasicUI.showProgressDialog(pageContext: profileSettingsContext,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[

                                                      SpinKitFadingCircle(color: _themeData.primaryColor,),
                                                      SizedBox(height: screenHeight * scaleFactor * 0.25,),
                                                      Text("Applying Color Theme...",
                                                        style: TextStyle(
                                                            color: _themeData.primaryColor,
                                                            fontSize: Theme.of(context).textTheme.subhead.fontSize
                                                        ),

                                                      )
                                                    ],
                                                  )
                                              );

                                              bool success = await _bloc.saveAppThemeColorValue(colorValue: null);
                                              _bloc.addAppThemeColorValueToStream(RGBColors.default_primary_color.value);

                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              if (success != null && success){
                                                BasicUI.showSnackBar(context: profileSettingsContext,
                                                    message: "App Theme Color was Updated\nRestart the App to view changes",
                                                    textColor: _themeData.primaryColor,
                                                    duration: Duration(seconds: 3)
                                                );
                                              }
                                              else{
                                                BasicUI.showSnackBar(context: profileSettingsContext,
                                                  message: "An error occured when updating your app color theme",
                                                  textColor: CupertinoColors.destructiveRed,
                                                );
                                              }

                                            },

                                          )
                                      ),


                                      Flexible(
                                          flex: 33,
                                          fit: FlexFit.tight,
                                          child: StreamBuilder<Object>(
                                              stream: _bloc.getAppThemeColorValueStream,
                                              builder: (context, snapshot) {
                                                return CupertinoButton(
                                                  child: Text("APPLY",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  disabledColor: snapshot.hasData? _themeData.primaryColor: Colors.black.withOpacity(0.2),
                                                  onPressed: snapshot.hasData? ()async{

                                                    BasicUI.showProgressDialog(pageContext: profileSettingsContext,
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[

                                                            SpinKitFadingCircle(color: _themeData.primaryColor,),
                                                            SizedBox(height: screenHeight * scaleFactor * 0.25,),
                                                            Text("Applying Color Theme...",
                                                              style: TextStyle(
                                                                  color: _themeData.primaryColor,
                                                                  fontSize: Theme.of(context).textTheme.subhead.fontSize
                                                              ),

                                                            )
                                                          ],
                                                        )
                                                    );

                                                    bool success = await _bloc.saveAppThemeColorValue(colorValue: _bloc.getAppThemeColorValue);

                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    if (success != null && success){

                                                      //_bloc.addAppThemeColorValueToStream(_bloc.getAppThemeColorValue);

                                                      BasicUI.showSnackBar(context: profileSettingsContext,
                                                          message: "App Theme Color was Updated\nRestart the App to view changes",
                                                          textColor: _themeData.primaryColor,
                                                          duration: Duration(seconds: 3)
                                                      );
                                                    }
                                                    else{
                                                      BasicUI.showSnackBar(context: profileSettingsContext,
                                                        message: "An error occured when updating your app color theme",
                                                        textColor: CupertinoColors.destructiveRed,
                                                      );
                                                    }

                                                  }: null,

                                                );
                                              }
                                          )
                                      ),


                                    ],
                                  ),
                                )

                              ],


                            ),
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


    if (isColorChanged == null){

      int savedColorValue = await _bloc.getSavedAppThemeColorValue();
      _bloc.addAppThemeColorValueToStream(savedColorValue);
    }
  }













  Future<void> showProfileSoundsModalDialog({@required BuildContext profileSettingsContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(profileSettingsContext);
    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(profileSettingsContext).bloc;
    double screenWidth = MediaQuery.of(profileSettingsContext).size.width;
    double screenHeight = MediaQuery.of(profileSettingsContext).size.height;
    double scaleFactor = 0.125;



    File audioFile = await showDialog(
        context: profileSettingsContext,
        builder: (BuildContext context){


          return SafeArea(

            child: Animator(


              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(milliseconds: 750),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: Center(

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * scaleFactor),
                      child: Container(

                        width: screenWidth,
                        height: screenHeight * 0.8,

                        child: AssetsAudioPicker(),

                      ),
                    ),
                  ),

                );
              },
            ),

          );

        }
    );

    if (audioFile != null){

      AppBlocProvider.of(profileSettingsContext).handler.showProgressPercentDialog(
          context: profileSettingsContext,
          progressPercentRatioStream: _bloc.getPercentRatioProgressStream
      );

      FileModel audioFileModel = await _bloc.uploadFile(
          sourceFile: audioFile,
          filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.mp3,
          progressSink: _bloc.getProgressTransferDataSink,
          totalSink: _bloc.getTotalTransferDataSink
      );

      if (audioFileModel == null){

        Navigator.of(profileSettingsContext).pop();
        BasicUI.showSnackBar(context: profileSettingsContext, message: "An error occured during Upload", textColor: RGBColors.red);
      }
      else {

        _bloc.updateProfileSettings(
            currentUserId: _bloc.getCurrentUserModel.userId,
            currentUserUpdateData: {
              UsersDocumentFieldNames.profile_audio: audioFileModel.fileUrl
            }
        ).then((_) {

          _bloc.addProfileAudioToStream(audioFileModel.fileUrl);

          Navigator.of(profileSettingsContext).pop();
          BasicUI.showSnackBar(
              context: profileSettingsContext,
              message: "Profile Audio was Updated",
              textColor: _themeData.primaryColor
          );
        });
      }
    }

  }








  Future<void> showUserInterestsModalDialog({@required BuildContext profileSettingsContext})async{

    CupertinoThemeData _themeData = CupertinoTheme.of(profileSettingsContext);
    ProfileSettingsBloc _bloc = ProfileSettingsBlocProvider.of(profileSettingsContext).bloc;
    double screenWidth = MediaQuery.of(profileSettingsContext).size.width;
    double screenHeight = MediaQuery.of(profileSettingsContext).size.height;
    double scaleFactor = 0.125;


    showDialog(
        context: profileSettingsContext,
        builder: (BuildContext context){


          return SafeArea(

            child: Animator(


              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(milliseconds: 750),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: Center(

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.5),
                      child: Container(

                        width: screenWidth,
                        height: screenHeight * 0.75,

                        child: InterestsPicker(),

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