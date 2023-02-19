import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/widgets/talents_splash/talents_splash.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'splash_screen_widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart' as assets_contants;




class SplashScreenview extends StatelessWidget {

  Duration splashDuration;

  SplashScreenview({@required this.splashDuration});


  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Stack(
      children: <Widget>[

        Container(
          width: screenWidth,
          height: screenHeight,
          child: Swiper.children(
            autoplay: true,
            autoplayDelay: 3000,
            duration: 750,
            children: <Widget>[
              Image.asset(assets_contants.PostTypeBackgroundImages.video, fit: BoxFit.cover, color: Colors.purple, colorBlendMode: BlendMode.color),
              Image.asset(assets_contants.PostTypeBackgroundImages.image, fit: BoxFit.cover, color: Colors.yellow, colorBlendMode: BlendMode.color),
              Image.asset(assets_contants.PostTypeBackgroundImages.audio, fit: BoxFit.cover, color: Colors.pinkAccent, colorBlendMode: BlendMode.color,),

            ],
            viewportFraction: 1.0,
            scale: 1.0,
            loop: true,
          ),
        ),

        Container(
          decoration: BoxDecoration(
            /*
              gradient: LinearGradient(
                  colors: [RGBColors.turquoise, RGBColors.fuchsia],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomRight,
                  stops: [0.1, 0.9],
                  tileMode: TileMode.clamp
              )
              */
            //color: Color.fromRGBO(0, 51, 51, 1.0)

            color: Colors.black.withOpacity(0.1)
          ),
          child: TalentsSplash(splashduration: splashDuration,),
        ),

        Positioned(
          left: 0.0,
          right: 0.0,
          top: screenHeight * scaleFactor * 2,
          child: Center(
              child: SplashScreenTitleWidget()
          ),
        ),

        Positioned(
          left: 0.0,
          bottom: screenHeight * scaleFactor * 0.5,
          right: 0.0,
          child: AuthenticationButtonsWidget(),
        )


      ],
    );
  }
}


















