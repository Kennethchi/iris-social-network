import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'image_classification_challenge_bloc.dart';
import 'image_classification_challenge_bloc_provider.dart';
import 'image_classification_challenge_views.dart';



class ImageClassificationChallenge extends StatefulWidget {
  @override
  _ImageClassificationChallengeState createState() => _ImageClassificationChallengeState();
}

class _ImageClassificationChallengeState extends State<ImageClassificationChallenge> {

  ImageClassificationChallengeBloc _bloc;

  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = ImageClassificationChallengeBloc();

    _pageController = PageController();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ImageClassificationChallengeBlocProvider(
      bloc: _bloc,
      pageController: _pageController,
      child: Scaffold(
          body: CupertinoPageScaffold(
              child: ImageClassificationChallengeViews()
          ),
      ),
    );

  }
}
