import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/res/strings/app_messages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';



class BasicUI {

  static void showSnackBar({
    @required BuildContext context,
    @required String message,
    Color textColor: RGBColors.white,
    Color backgroundColor: RGBColors.black,
    Duration duration: const Duration(seconds: 4)}) {


    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message,
        style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold
        ),
      ),
      duration: duration,
    ));
  }


  static void showToast({@required String message}){

    //Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
  }


  static void showProgressDialog({
    @required BuildContext pageContext,
    @required Widget child
  }){

    ThemeData _themeData = Theme.of(pageContext);

    showDialog(
      barrierDismissible: false,
        context: pageContext,

        builder: (BuildContext context){
          return WillPopScope(
            onWillPop: ()async{

              await AppBlocProvider.of(context).handler.showCancelOperationOption(pageContext: pageContext, message: "Do you want to Quit?");
            },
            child: Center(
              child: SingleChildScrollView(

                child: child


              ),
            ),
          );
        }
    );
  }






}