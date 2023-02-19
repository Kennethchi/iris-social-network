import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/animation.dart';
import 'dart:math';
import 'package:meta/meta.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/modules/registration/phone_auth/phone_auth_views_widgets.dart';
import 'auth_bloc.dart';
import 'auth_bloc_provider.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/widgets/clippers/clippers.dart';




class PhoneNumberVerificationView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    AuthBloc _bloc = AuthBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double topHeightSpace = screenHeight * scaleFactor * 0.5;




    return Container(
      width: screenWidth,
      height: screenHeight,
      color: RGBColors.white,
      child: CustomScrollView(
        slivers: <Widget>[

          PhoneAuthSliverAppBar(),

          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: screenWidth * scaleFactor * 0.5),
            sliver: SliverList(delegate: SliverChildListDelegate(

              <Widget>[


                Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: <Widget>[

                    SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                    VerifyButton(),

                    SizedBox(height: screenHeight * scaleFactor * scaleFactor,),


                    Container(
                        child: CountrySelectionCard()
                    ),
                    SizedBox(height: screenHeight * scaleFactor * 0.125,),

                    Container(
                        child: PhoneNumberField()
                    ),
                    SizedBox(height: topHeightSpace,),

                    Container(
                      child: Wrap(
                        children: <Widget>[

                          RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[

                                TextSpan(
                                  text: "By tapping "
                                ),
                                TextSpan(
                                    text: "Verify, ",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)
                                ),
                                TextSpan(text: "an SMS will be sent to this number for Verification.")

                              ]
                           )
                          ),

                        ],
                      ),
                    ),


                  ],
                ),

              ]
            )),
          )

        ],
      ),
    );
  }

}


class SmsVerificationView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    AuthBloc _bloc = AuthBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double topHeightSpace = screenHeight * scaleFactor * 0.5;


    return Container(
      padding: EdgeInsets.all(10.0),
      color: RGBColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          SizedBox(height: topHeightSpace,),

          Container(
            color: RGBColors.white,
            child: Text("Verification Code",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _themeData.primaryColor,
                  fontSize: Theme.of(context).textTheme.headline.fontSize
              ),
            ),
          ),

          SizedBox(height: screenHeight * scaleFactor * 0.25,),

          Container(
            child: Text("Please type the verification code sent to",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.subhead.fontSize,
              ),
            ),
          ),

          StreamBuilder<Map<String, String>>(
            stream: _bloc.getFullPhoneNumberStream,
            builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot){

              if (snapshot.hasData){

                String phoneCode = CountryPickerUtils.getCountryByIsoCode(snapshot.data[AuthBloc.Iso_Code_Key]).phoneCode;
                String phoneNumber = "+" + phoneCode + snapshot.data[AuthBloc.Phone_Number_Key];


                //Store formatted country phone code in shared preferences to get it in account setup when storing user data in firestore
                SharedPreferences.getInstance().then((SharedPreferences prefs){
                  prefs.setString(SharedPrefsKeys.country_phone_code, "+" + phoneCode);
                });


                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(phoneNumber,
                    style: TextStyle(
                        color: _themeData.primaryColor,
                        fontSize: Theme.of(context).textTheme.subhead.fontSize,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }
              else{
                return SpinKitPulse(color: _themeData.primaryColor);
              }
            },
          ),

          SizedBox(height: screenHeight * scaleFactor,),

          Container(
            child: PinCodeTextField(
              maxLength: 6,
              highlight: true,
              highlightColor: RGBColors.active_green,
              autofocus: true,
              pinBoxWidth: screenWidth * scaleFactor,
              pinBoxHeight: screenHeight * scaleFactor,
              pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
              pinTextAnimatedSwitcherDuration: Duration(milliseconds: 250),
              pinTextStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.title.fontSize,
                color: _themeData.primaryColor,
                fontWeight: FontWeight.bold
              ),
              defaultBorderColor: _themeData.primaryColor,
              hasTextBorderColor: _themeData.primaryColor,
              keyboardType: TextInputType.number,

              onDone: (String smsCode) {

                AuthBlocProvider.of(context).onSmsCodeEntered(context: context, smsCode: smsCode);
              }

            )
          )



        ],
      ),
    );;
  }


}



