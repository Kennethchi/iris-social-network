import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:avataaar_image/avataaar_image.dart';
import 'avatar_image_generator_view_widgets.dart';



class AvatarImageGeneratorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return SafeArea(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            //SizedBox(height: screenHeight * scaleFactor * 0.25,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ExitAvatarGeneratorButton(),
                ValidateSelectedGeneratedAvatarButton()
              ],
            ),


            Flexible(
              flex: 50,
              child: AvatarSelectedImageWidget(),
            ),

            Flexible(
              flex: 50,
              child: AvatarImagesGridViewWidget()
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GenerateRandomAvatarButton(),
            )

          ],
        ),
      ),
    );
  }
}
