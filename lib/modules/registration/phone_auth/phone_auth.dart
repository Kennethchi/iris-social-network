import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'auth_bloc.dart';
import 'auth_bloc_provider.dart';

import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';

import 'package:iris_social_network/modules/registration/phone_auth/phone_auth_views_widgets.dart';


import 'package:flutter/animation.dart';
import 'dart:math';

import 'phone_auth_views.dart';


class PhoneAuth extends StatefulWidget{

  @override
  _PhoneAuthState createState() => new _PhoneAuthState();

}


class _PhoneAuthState extends State<PhoneAuth> with TickerProviderStateMixin{

  AuthBloc _bloc;


  AnimationController _phoneVerificationAnimationController;
  Animation _phoneVerificationSlideAnimation;

  AnimationController _smsVerificationAnimationController;
  Animation _smsVerificationSlideAnimation;


  PageController _pageController;


  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _bloc = new AuthBloc();
    _pageController = new PageController();
    
    _phoneVerificationAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _phoneVerificationSlideAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: _phoneVerificationAnimationController, curve: Curves.ease));
  }



  @override
  void dispose() {
    // TODO: implement dispose

    // closes all stream controllers
    _bloc.dispose();
    _pageController.dispose();

    _smsVerificationAnimationController.dispose();
    _phoneVerificationAnimationController.dispose();

    super.dispose();
  }
  
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    _phoneVerificationAnimationController.forward();

    return AuthBlocProvider(
      //model: CountryModel(),
      bloc: _bloc,
      pageController: _pageController,
      //selectedCountry: _selectedCountry,
      child: Scaffold(

        body: PageView(

          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[

            PhoneNumberVerificationView(),

            SmsVerificationView()

          ],
        )
      )
    );
  }



}





























//*
/*

class CountryModel extends Model{

  //final Key key;
  //final AuthBloc bloc;
  //final Widget child;

  Country selectedCountry;

  CountryModel(){
    selectedCountry = this.selectedCountry = CountryPickerUtils.getCountryByIsoCode("cm");
  }

  void showPicker(BuildContext context){
    PhoneAuthUI.showCupertinoCountrySelect(context);
    notifyListeners();
  }

  Widget aaaaaa(){
    return ScopedModelDescendant<CountryModel>(builder: (context,_,model){
      Country selectedCountry = model.selectedCountry;

      return GestureDetector(
        onTap: (){
          model.showPicker(context);
          //AuthBlocProvider.of(context).bloc
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                CountryPickerUtils.getDefaultFlagImage(selectedCountry),
                SizedBox(width: 5.0,),

                Text("+${selectedCountry.phoneCode}"),
                SizedBox(width: 5.0,),

                Text("(${selectedCountry.isoCode})"),

              ],
            ),
          ),
        ),
      );
    });

  }

}



*/


