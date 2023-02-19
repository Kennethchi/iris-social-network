import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'account_setup_bloc.dart';
import 'account_setup_bloc_provider.dart';
import 'account_setup_strings.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/utils/string_utils.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'package:iris_social_network/utils/image_utils.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/routes/routes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'account_setup_views_widgets.dart';
import 'package:iris_social_network/services/constants/medias_constants.dart';
import 'dart:math';
import 'package:page_indicator/page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';




class AccountSetupView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return PageView(
      controller: AccountSetupBlocProvider.of(context).pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[

        ProfileNameView(),

        UserNameView(),

        GenderTypeSelectView(),

        ProfileImageSelectView(),


      ],
    );
  }
}






class ProfileNameView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double topHeightSpace = screenHeight * scaleFactor * 0.5;


    // TODO: implement build
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          trailing: ProfileNameViewNextButton(),
          border: Border.all(style: BorderStyle.none),
        ),
        child: Stack(
          children: <Widget>[


            /*
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                    color: RGBColors.white,
                ),
                child: Opacity(
                  opacity: 0.2,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds){

                      return LinearGradient(
                        colors: [_themeData.primaryColor, RGBColors.fuchsia],
                        stops: [0.2, 0.8]

                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Image.asset(
                      ImagesConstants.getTalentImagesPath[(Random().nextInt(ImagesConstants.getTalentImagesPath.length))],
                      fit: BoxFit.contain,
                      //color: Colors.white.withOpacity(0.2),

                    ),
                  ),
                ),

              ),
            ),
            */

            Container(
              padding: EdgeInsets.symmetric(horizontal:  scaleFactor * screenWidth * 0.5),
              width: screenWidth,
              height: screenHeight,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      SizedBox(
                        height: screenWidth * scaleFactor,
                      ),

                      Container(
                        child: Text(
                          AccountSetupWidgetStrings.profile_name_view_title,
                          style: TextStyle(color: _themeData.primaryColor,
                              fontSize: Theme.of(context).textTheme.headline.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: screenHeight * scaleFactor,),


                      Container(
                        child: TextField(
                          controller: AccountSetupBlocProvider.of(context).profileNameEditTextController,
                          maxLines: 1,
                          maxLength: 50,
                          focusNode: AccountSetupBlocProvider.of(context).profileNameTextFieldFocusNode,

                          decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.person_solid, color: _themeData.primaryColor,),
                            hintText: AccountSetupWidgetStrings.profile_name_textField_hint,
                            labelText: AccountSetupWidgetStrings.profile_name_textField_label,
                            labelStyle: TextStyle(color: _themeData.primaryColor),
                            contentPadding: EdgeInsets.all(5.0)
                          ),

                          onChanged: (String profileName){
                            _bloc.addProfileName(profileName);
                          },

                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}









class UserNameView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double topHeightSpace = screenHeight * scaleFactor * 0.5;


    // TODO: implement build
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: UserNameViewNextButton(),
          border: Border.all(style: BorderStyle.none),
        ),
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[

            /*
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  color: RGBColors.white,
                ),
                child: Opacity(
                  opacity: 0.2,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds){

                      return LinearGradient(
                          colors: [_themeData.primaryColor, RGBColors.fuchsia],
                          stops: [0.2, 0.8]

                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Image.asset(
                      ImagesConstants.getTalentImagesPath[(Random().nextInt(ImagesConstants.getTalentImagesPath.length))],
                      fit: BoxFit.contain,
                      //color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),

              ),
            ),
            */



            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.5,),
              width: screenWidth,
              height: screenHeight,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[


                      SizedBox(
                        height: screenWidth * scaleFactor,
                      ),

                      Container(
                        child: Text(
                          AccountSetupWidgetStrings.user_name_view_title,
                          style: TextStyle(color: _themeData.primaryColor,
                              fontSize: Theme.of(context).textTheme.headline.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: screenHeight * scaleFactor * 0.75,),


                      Center(child: UsernameResultWidget()),
                      SizedBox(height: screenHeight * scaleFactor * 0.75,),


                      Container(
                        child: TextField(
                          controller: AccountSetupBlocProvider.of(context).usernameEditTextController,
                          maxLines: 1,
                          maxLength: 50,
                          focusNode: AccountSetupBlocProvider.of(context).userNameTextFieldFocusNode,
                          decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.person_solid, color: _themeData.primaryColor,),
                              suffix: UsernameCheckButtonWidget(),
                              hintText: AccountSetupWidgetStrings.user_name_textField_hint,
                              labelText: AccountSetupWidgetStrings.user_name_textField_label,
                              labelStyle: TextStyle(color: _themeData.primaryColor),
                              contentPadding: EdgeInsets.all(5.0)

                          ),

                          onChanged: (String userName){
                            print(userName);
                            _bloc.addUserName(userName);
                          },


                        ),
                      ),
                      SizedBox(height: screenHeight * scaleFactor,),

                      Center(child: Text("NOTE:")),
                      Padding(
                        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                        child: RichText(
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
                        ),
                      )



                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}















class GenderTypeSelectView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double topHeightSpace = screenHeight * scaleFactor * 0.5;



    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: GenderTypeViewNextButton(),
          border: Border.all(style: BorderStyle.none),
        ),
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[


            /*
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  color: RGBColors.white,
                ),
                child: Opacity(
                  opacity: 0.2,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds){

                      return LinearGradient(
                          colors: [_themeData.primaryColor, RGBColors.fuchsia],
                          stops: [0.2, 0.8]

                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Image.asset(
                      ImagesConstants.getTalentImagesPath[(Random().nextInt(ImagesConstants.getTalentImagesPath.length))],
                      fit: BoxFit.contain,
                      //color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),

              ),
            ),
            */



            Container(
              width: screenWidth,
              height: screenHeight,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.5),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[


                      SizedBox(
                        height: screenWidth * scaleFactor,
                      ),

                      Container(
                        child: Text(
                          AccountSetupWidgetStrings.gender_type_title,
                          style: TextStyle(color: _themeData.primaryColor,
                              fontSize: Theme.of(context).textTheme.headline.fontSize,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * scaleFactor * 0.5,),


                      Container(
                          child: StreamBuilder(
                            stream: _bloc.getGenderTypeStream, // Listening to gender type stream
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                              return Column(
                                children: <Widget>[

                                  RadioListTile(
                                    title: Text(StringUtils.toUpperCaseLower(GenderType.male)),
                                    value: GenderType.male,
                                    groupValue: snapshot.hasData? snapshot.data: null, // boolean experesion to check if stream has received gender type data
                                    activeColor: _themeData.primaryColor,
                                    onChanged: (String genderType){
                                      _bloc.addGenderType(genderType); // adds gender type to the stream
                                    },

                                  ),

                                  RadioListTile(
                                    title: Text(StringUtils.toUpperCaseLower(GenderType.female)),
                                    value: GenderType.female,
                                    groupValue: snapshot.hasData? snapshot.data: null, // boolean experesion to check if stream has received gender type data
                                    activeColor: _themeData.primaryColor,
                                    onChanged: (String genderType){
                                      _bloc.addGenderType(genderType);  // adds gender type to the stream
                                    }
                                  ),

                                  RadioListTile(
                                    title: Text(StringUtils.toUpperCaseLower(GenderType.other)),
                                    value: GenderType.other,
                                    groupValue: snapshot.hasData? snapshot.data: GenderType.male, // boolean expression to check if stream has received gender type data
                                    activeColor: _themeData.primaryColor,
                                    onChanged: (String genderType){
                                      _bloc.addGenderType(genderType);
                                    },
                                  )

                                ],
                              );

                            },
                          )
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}














class ProfileImageSelectView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AccountSetupBloc _bloc = AccountSetupBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    double topHeightSpace = screenHeight * scaleFactor * 0.5;
    
    return SafeArea(
      child: CupertinoPageScaffold(

        navigationBar: CupertinoNavigationBar(
          trailing: AccountSetupCompleteButton(),
          backgroundColor: Colors.transparent,
          border: Border.all(style: BorderStyle.none),
        ),

        child: Stack(
          children: <Widget>[



            /*
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  color: RGBColors.white,
                ),
                child: Opacity(
                  opacity: 0.2,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds){

                      return LinearGradient(
                          colors: [_themeData.primaryColor, RGBColors.fuchsia],
                          stops: [0.2, 0.8]

                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Image.asset(
                      ImagesConstants.getTalentImagesPath[(Random().nextInt(ImagesConstants.getTalentImagesPath.length))],
                      fit: BoxFit.contain,
                      //color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),

              ),
            ),
            */


            Container(
              width: screenWidth,
              height: screenHeight,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.5),

              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[



                      SizedBox(
                        height: screenWidth * scaleFactor,
                      ),

                      Container(
                        child: Text(
                          AccountSetupWidgetStrings.profile_image_view_title,
                          style: TextStyle(color: _themeData.primaryColor,
                              fontSize: Theme.of(context).textTheme.headline.fontSize,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * scaleFactor * 0.5,),



                      Container(
                        child: StreamBuilder(
                            stream: _bloc.getProfileImageFileStream,
                            builder: (BuildContext context, AsyncSnapshot<File> imageFileSnapshot){


                              return Container(
                                child: InkWell(
                                  onTap: (){
                                    AccountSetupBlocProvider.of(context).handlers.showProfileImageOptionMenuDialog(accoutSetupContext: context);
                                  },
                                  child: Stack(
                                    children: <Widget>[


                                      Container(
                                        width: screenWidth * 0.5,
                                        height: screenWidth * 0.5,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 3.0, color: _themeData.primaryColor ),
                                            shape: BoxShape.circle
                                        ),

                                        child: Stack(
                                          children: <Widget>[

                                            Positioned.fill(
                                              child: CircleAvatar(

                                                child: FittedBox(
                                                  child: imageFileSnapshot.data == null? Icon(CupertinoIcons.person_solid,

                                                    color: Colors.black.withOpacity(0.1), size: screenHeight,)
                                                      : Container(),
                                                ),
                                                backgroundColor: RGBColors.white,
                                                backgroundImage: imageFileSnapshot.hasData? FileImage(imageFileSnapshot.data): FileImage(File("")),

                                              ),
                                            ),


                                            Positioned(
                                              child: Icon(Icons.add_a_photo, size: scaleFactor * screenWidth, color: _themeData.primaryColor,),
                                              right: 0.0,
                                              bottom: 0.0,
                                            ),
                                          ],
                                        ),

                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        ),
                      )


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}









