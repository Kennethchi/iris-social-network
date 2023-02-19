import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:meta/meta.dart';

import 'image_classification_challenge_mock_repository.dart';
import 'image_classification_challenge_production_repository.dart';
import 'image_classification_challenge_repository.dart';




class ImageClassificationChallengeDependencyInjector{

  ImageClassificationChallengeDependencyInjector._internal();

  static final ImageClassificationChallengeDependencyInjector _singleton = ImageClassificationChallengeDependencyInjector._internal();

  factory ImageClassificationChallengeDependencyInjector(){
    return _singleton;
  }

  static REPOSITORY_DEPENDENCY _repositoryDependency;

  static void confgure({@required REPOSITORY_DEPENDENCY repository_dependency}){
    _repositoryDependency = repository_dependency;
  }


  ImageClassificationChallengeRepository get getRepository{

    switch (_repositoryDependency){

      case REPOSITORY_DEPENDENCY.MOCK:
        return ImageClassificationChallengeMockRepository();
      case REPOSITORY_DEPENDENCY.PRODUCTION:
        return ImageClassificationChallengeProductionRepository();
    }

  }




}