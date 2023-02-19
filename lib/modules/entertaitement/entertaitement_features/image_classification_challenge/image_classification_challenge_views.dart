import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'image_classification_challenge_bloc.dart';
import 'image_classification_challenge_bloc_provider.dart';
import 'image_classification_challenge_views_widgets.dart';





class ImageClassificationChallengeViews extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    ImageClassificationChallengeBlocProvider _provider = ImageClassificationChallengeBlocProvider.of(context);
    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SafeArea(
        child: PageView(
          controller: _provider.pageController,
          children: <Widget>[
            ImageClassificationChallengeIntroView(),

            ImagePredictionView()
          ],
        ),
      ),
    );
  }

}








