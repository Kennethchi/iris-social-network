import 'package:flutter/material.dart';
import 'account_setup_bloc.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';
import 'dart:io';
import 'package:iris_social_network/utils/image_utils.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';
import 'account_setup_view_handlers.dart';
import 'account_setup_view_handlers.dart';


class AccountSetupBlocProvider extends InheritedWidget{

  final AccountSetupBloc bloc;
  final Widget child;
  final Key key;


  PageController pageController;

  TextEditingController usernameEditTextController;
  TextEditingController profileNameEditTextController;

  FocusNode profileNameTextFieldFocusNode;
  FocusNode userNameTextFieldFocusNode;


  AnimationController animationController;
  Animation<double> fadeAnimation;

  AccountSetupViewHandlers handlers;


  AccountSetupBlocProvider({
    @required this.bloc,
    @required this.pageController,
    @required this.usernameEditTextController,
    @required this.profileNameEditTextController,
    @required this.profileNameTextFieldFocusNode,
    @required this.userNameTextFieldFocusNode,
    @required this.animationController,
    this.key,
    this.child})
      : super(key: key, child: child)
  {
    this.fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn));

    handlers = AccountSetupViewHandlers();

    bloc.getProfileNameStream.first.then((String profileName){

      this.profileNameEditTextController.text = profileName;
    });

    animationController.repeat();
  }





  static AccountSetupBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(AccountSetupBlocProvider) as AccountSetupBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}











