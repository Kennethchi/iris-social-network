import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'image_classification_challenge_bloc.dart';
import 'image_classification_challenge_handlers.dart';


class ImageClassificationChallengeBlocProvider extends InheritedWidget{

  final ImageClassificationChallengeBloc bloc;
  final Key key;
  final Widget child;

  ImageClassificationChallengeHanders handlers;

  PageController pageController;

  ImageClassificationChallengeBlocProvider({@required this.bloc, @required this.pageController, this.key, this.child}): super(key: key, child: child){

    handlers = ImageClassificationChallengeHanders();
  }

  static ImageClassificationChallengeBlocProvider of(BuildContext context) => (
          context.inheritFromWidgetOfExactType(ImageClassificationChallengeBlocProvider) as ImageClassificationChallengeBlocProvider
  );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}


