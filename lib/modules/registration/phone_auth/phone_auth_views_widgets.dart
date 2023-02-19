import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/modules/registration/phone_auth/auth_bloc.dart';
import 'package:iris_social_network/modules/registration/phone_auth/auth_bloc_provider.dart';
import 'package:iris_social_network/modules/registration/phone_auth/auth_repository.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:iris_social_network/utils/basic_utils.dart';
import 'package:iris_social_network/modules/registration/phone_auth/firebase_auth_provider.dart';
import 'package:iris_social_network/widgets/clippers/clippers.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';




class PhoneAuthUI{

  static void showCupertinoCountrySelect(BuildContext inheritContext){

    double screenWidth = MediaQuery.of(inheritContext).size.width;
    double screenHeight = MediaQuery.of(inheritContext).size.height;

    final double pickerSheetHeight = screenHeight * 0.25;
    final double pcickerItemHeight = pickerSheetHeight * 0.2;

    showCupertinoModalPopup<void>(
        context: inheritContext,
        builder: (BuildContext context) => CountryPickerCupertino(
          itemBuilder: (Country country){
            return Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: <Widget>[

                CountryPickerUtils.getDefaultFlagImage(country),
                SizedBox(width: 10.0,),

                Text("${country.name}", style: TextStyle(fontSize: Theme.of(context).textTheme.subhead.fontSize),)
              ],
            );
          },
          useMagnifier: true,
          magnification: 1.1,
          pickerSheetHeight: pickerSheetHeight,
          pickerItemHeight: pcickerItemHeight,
          backgroundColor: Colors.white,
          onValuePicked: (Country country){
            AuthBlocProvider.of(inheritContext).selectedCountry = country;
            AuthBlocProvider.of(inheritContext).bloc.addIsoCode(country.isoCode);
          },

        )
    );

  }


  static void showAuthStreamingProgress({@required BuildContext inheritContext, @required AuthBloc bloc,
    @required String message, @required String isoCode, @required String phoneNumber, @required int durationForPageTransition: 1}){

    CupertinoThemeData _themeData = CupertinoTheme.of(inheritContext);
    double screenWidth = MediaQuery.of(inheritContext).size.width;
    double screenHeight = MediaQuery.of(inheritContext).size.height;
    double scaleFactor = 0.125;

    showDialog(
        context: inheritContext,
        barrierDismissible: false,
        builder: (BuildContext context){
          return Center(
            child: SingleChildScrollView(

              child: Container(
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: bloc.getVerificationProcessStream,
                  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){


                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                        return SpinKitFadingCircle(color: RGBColors.light_grey_level_1,);
                      case ConnectionState.waiting:
                        return SpinKitFadingCircle(color: RGBColors.light_grey_level_1,);
                      case ConnectionState.active: case ConnectionState.done:

                      if (snapshot.hasData){

                        PHONE_VERIFICATION_STATE state = snapshot.data[FirebaseAuthProvider.Verification_State_Key];

                        switch(state){

                          case PHONE_VERIFICATION_STATE.FAILED:
                            print("Verification Failed");

                            String error_message = snapshot.data[FirebaseAuthProvider.Verification_Exception_Key];
                            Navigator.of(inheritContext).pop();

                            // delays snackbar so widget can finish building
                            Timer(Duration(milliseconds: 100), (){
                              BasicUI.showSnackBar(context: inheritContext, message: error_message, textColor: RGBColors.red);
                            });
                            break;

                          case PHONE_VERIFICATION_STATE.NONE:
                            print("Verification none");
                            Navigator.of(inheritContext).pop();
                            break;

                          case PHONE_VERIFICATION_STATE.SMSCODE_SENT:
                            print("Verification code sent");

                            Navigator.pop(inheritContext);
                            AuthBlocProvider.of(inheritContext).onSmsCodeSent(
                              inheritContext: inheritContext,
                                snapshotData: snapshot.data,
                                phoneNumber: phoneNumber,
                                isoCode: isoCode,
                                durationForPageTransition: durationForPageTransition
                            );

                            break;

                          case PHONE_VERIFICATION_STATE.SMSCODE_SENT_AUTO_RETRIEVE_TIMEOUT:
                            print("Sms code sent Auto retrieve Time out");

                            // same code as sms code sent
                            Navigator.pop(inheritContext);
                            AuthBlocProvider.of(inheritContext).onSmsCodeSent(
                                inheritContext: inheritContext,
                                snapshotData: snapshot.data,
                                phoneNumber: phoneNumber,
                                isoCode: isoCode,
                                durationForPageTransition: durationForPageTransition
                            );


                            break;

                          case PHONE_VERIFICATION_STATE.COMPLETE:
                            print("Verification Complete");


                            Timer(Duration(seconds: 2), (){

                              Navigator.of(context).pop();
                              BasicUI.showProgressDialog(pageContext: context,
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * scaleFactor),
                                    child: Column(
                                      children: <Widget>[
                                        SpinKitFadingCircle(color: CupertinoTheme.of(context).primaryColor,),
                                        SizedBox(height: screenHeight * scaleFactor * scaleFactor,),
                                        Text("Automatically Retrieving Verification Code from Device...",
                                          style: TextStyle(color: _themeData.primaryColor,),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  )
                              );


                              Timer(Duration(seconds: 3), (){

                                Navigator.pop(inheritContext);

                                BasicUI.showProgressDialog(pageContext: inheritContext,
                                    child: Column(
                                      children: <Widget>[
                                        SpinKitFadingCircle(color: CupertinoTheme.of(inheritContext).primaryColor,),
                                        SizedBox(height: screenHeight * scaleFactor * scaleFactor,),
                                        Text("Signing In...", style: TextStyle(color: _themeData.primaryColor),)
                                      ],
                                    )
                                );

                                Timer(Duration(seconds: 5), (){
                                  AuthBlocProvider.of(inheritContext).onAutoSmsCodeRetrievedCompleted(
                                      context: inheritContext,
                                      authCredential: snapshot.data[FirebaseAuthProvider.Authenticated_Credential_Key]
                                  );
                                });
                              });

                            });


                            break;
                        }

                        return Center(
                          child: SpinKitFadingCircle(
                            color: _themeData.primaryColor,
                          ),
                        );

                      }

                      else{
                        return Center(
                          child: SpinKitFadingCircle(
                            color: _themeData.primaryColor,
                          ),
                        );
                      }



                    }



                  },
                )
              ),
            ),
          );
        }
    );
  }

}








class CountrySelectionCard extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AuthBloc bloc = AuthBlocProvider.of(context).bloc;
    Country selectedCountry = AuthBlocProvider.of(context).selectedCountry;

    return GestureDetector(
      onTap: (){
        PhoneAuthUI.showCupertinoCountrySelect(context);
      },
      child: StreamBuilder(
        stream: bloc.getIsoCodeStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.hasData){
            selectedCountry = CountryPickerUtils.getCountryByIsoCode(snapshot.data);

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    CountryPickerUtils.getDefaultFlagImage(selectedCountry),
                    SizedBox(width: 5.0,),

                    Text("+${selectedCountry.phoneCode}"),
                    SizedBox(width: 5.0,),

                    Text("(${selectedCountry.isoCode})"),
                    SizedBox(width: 5.0,),

                    Spacer(),
                    Icon(Icons.arrow_drop_down),

                  ],
                ),
              ),
            );
          }
          else{
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    CountryPickerUtils.getDefaultFlagImage(selectedCountry),
                    SizedBox(width: 5.0,),

                    Text("+${selectedCountry.phoneCode}"),
                    SizedBox(width: 5.0,),

                    Text("(${selectedCountry.isoCode})"),
                    SizedBox(width: 5.0,),

                    Spacer(),
                    Icon(Icons.arrow_drop_down)

                  ],
                ),
              ),
            );
          }
        },

      ),
    );
  }

}


class VerifyButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AuthBloc _bloc = AuthBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<Map<String, String>>(
      stream: _bloc.getFullPhoneNumberStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){


        return Container(
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: RGBColors.white,
            borderRadius: BorderRadius.circular(screenWidth)


          ),
          child: CupertinoButton(

            color: _themeData.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            borderRadius: BorderRadius.circular(screenWidth),
            disabledColor: Colors.black.withOpacity(0.1),
            child: Text("Verify",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.button.fontSize
              ),
            ),

            onPressed: snapshot.hasData? (){

              String isoCode = snapshot.data[AuthBloc.Iso_Code_Key];
              String phoneCode = CountryPickerUtils.getCountryByIsoCode(isoCode).phoneCode;
              String phoneNumber = snapshot.data[AuthBloc.Phone_Number_Key];
              String fullPhoneNumber = "+" + phoneCode + phoneNumber;

              PhoneAuthUI.showAuthStreamingProgress(
                  inheritContext: context,
                  bloc: _bloc,
                  message: null,
                phoneNumber: phoneNumber,
                isoCode: isoCode,
                durationForPageTransition: 1
              );

              _bloc.verifyPhoneNumber(fullPhoneNumber: fullPhoneNumber);
            }: null,

          ),
        );
      },
    );
  }

}



class PhoneNumberField extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    AuthBloc bloc = AuthBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    return StreamBuilder(
      stream: bloc.getPhoneNumberStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        return TextField(
          cursorColor: _themeData.primaryColor,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5.0),
            hintText: "Enter Phone Number",
            labelText: "Phone number",
            errorText: snapshot.error,
            labelStyle: TextStyle(color: _themeData.primaryColor),
            hintStyle: TextStyle(color: RGBColors.light_grey_level_3),
          ),
          keyboardType: TextInputType.phone,

          onChanged: (String phoneNumber){
            bloc.addPhoneNumber(phoneNumber);
          },

        );
      },
    );
  }

}










class PhoneAuthSliverAppBar extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return SliverAppBar(
      expandedHeight: screenHeight * 0.5,
      //floating: true,
      pinned: false,
      elevation: 0.0,
      
      backgroundColor: RGBColors.white,
      flexibleSpace: ClipPath(

        clipper: OvalBottomClipper(),

        child: FlexibleSpaceBar(
          background: Container(
            color: _themeData.primaryColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Icon(Icons.phone_iphone, color: Colors.white, size: screenWidth * scaleFactor * 2,),
                  SizedBox(height: screenHeight * scaleFactor * 0.25,),

                  ScaleAnimatedTextKit(
                    text: ["Verify your Phone Number"],
                    textStyle: TextStyle(
                      color: RGBColors.white,
                      fontSize: Theme.of(context).textTheme.headline.fontSize,
                    ),
                    textAlign: TextAlign.center,
                    duration: Duration(seconds: 2),
                    isRepeatingAnimation: false,
                  ),
                ],
              )
            ),
          ),

        ),
      ),


    );

  }


}






