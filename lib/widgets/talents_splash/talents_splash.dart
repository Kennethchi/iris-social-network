import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/animation.dart';
import 'talents_splash_view.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';





class TalentsSplash extends StatefulWidget {

  Duration splashduration;

  TalentsSplash({@required this.splashduration});

  @override
  _TalentsSplashState createState() => _TalentsSplashState();
}


class _TalentsSplashState extends State<TalentsSplash> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation talentImagesOpacity;
  Animation titleTranslate;

  @override
  void initState() {
    super.initState();


    _controller = AnimationController(vsync: this, duration: widget.splashduration);
    talentImagesOpacity = Tween(begin: 0.0, end: 0.7).animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.8, curve: Curves.easeInCirc)));
    titleTranslate = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Interval(0.8, 1.0, curve: Curves.easeInOutBack)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    _controller.forward();

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child){

        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[

            Opacity(
                opacity: talentImagesOpacity.value,
                child: TalentsSplashView()
            ),

            /*
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              child: Transform.translate(
                offset: Offset(0.0, -1 * titleTranslate.value * MediaQuery.of(context).size.height),
                child: ScaleAnimatedTextKit(
                    text: ["Welcome to Iris"],
                  textStyle: TextStyle(
                    color: CupertinoTheme.of(context).primaryColor,
                    fontSize: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.fontSize,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: "RobotoMono"
                  ),
                ),
              ),
            ),
            */


          ],
        );
      }

    );
  }
}







