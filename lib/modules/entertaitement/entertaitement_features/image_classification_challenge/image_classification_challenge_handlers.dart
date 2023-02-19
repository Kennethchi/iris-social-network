import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/app_services/remote_config_services.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'package:iris_social_network/services/entertaitement_services/models/image_classification_challenges_models.dart';
import 'package:iris_social_network/services/machine_learning_services/machine_learning_servers_api/models/image_prediction_result_model.dart';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'package:iris_social_network/utils/image_utils.dart';
import 'package:package_info/package_info.dart';
import 'image_classification_challenge_bloc.dart';
import 'image_classification_challenge_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iris_social_network/services/machine_learning_services/machine_learning_servers_api/constants.dart' as machine_learning_services_constants;
import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;




class ImageClassificationChallengeHanders{


  Future<void> launchCameraAndclassifyImage({@required BuildContext pageContext })async{

    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(pageContext).bloc;


    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
      maxWidth: 720,
      maxHeight: 720,
      imageQuality: 70
    );


    if (imageFile != null){

      _bloc.addUserSelectedImagePathToStream(imageFile.path);

      _bloc.addShowPredictionOngoingProgressIndicatorToStream(true);
      _bloc.addShowPredictionResultToStream(false);


      File compressedFile = await ImageUtils.getCompressedImageFile(
          imageFile: imageFile,
          maxWidth: 300,
          quality: 50
      );

      if (compressedFile !=null && compressedFile.existsSync()){


        _bloc.addShowPredictionOngoingProgressIndicatorToStream(true);
        _bloc.addShowPredictionResultToStream(false);


        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        RemoteConfig remoteConfig = RemoteConfig();
        await remoteConfig.fetch(expiration: Duration.zero);
        await remoteConfig.activateFetched();

        String prediction_endpoint = remoteConfig.getString(RemoteConfigKeys.object_classification_endpoint);

        if (prediction_endpoint != null){


          _bloc.predictImage(sourceFile: compressedFile,
              filename: "${DateTime.now().microsecondsSinceEpoch}" + FileExtensions.jpg,
              endpoint: prediction_endpoint
          ).then((ImagePredictionResultModel imagePredictionResultModel){

            print(imagePredictionResultModel.toJson());

            if (double.parse(imagePredictionResultModel.prediction_score)
                >= machine_learning_services_constants.successfulPredictionLowerBoundValue
                && _bloc.getImageChallengeModel.getRemainingTargetPredictionClasses().contains(imagePredictionResultModel.prediction_class)
            ){


              _bloc.updateChallengeState(
                  currentUserId: _bloc.getCurrentUserId,
                  targetPredictionClass: imagePredictionResultModel.prediction_class
              ).then((ImageClassificationChallengeModel imageClassificationChallengeModel){

                _bloc.addImageClassificationChallengeModelToStream(imageClassificationChallengeModel);


                // Challenge is Complete
                if (imageClassificationChallengeModel.getRemainingTargetPredictionClasses().isEmpty){
                  _bloc.addIsChallengeCompleteToStream(true);
                }
              });

              AppBlocProvider.of(pageContext).bloc.increaseUserPoints(
                  userId: _bloc.getCurrentUserId,
                  points: achievements_services.RewardsTypePoints.machine_learning_classification_reward_point
              ).then((totalPoints){

                print("Total Points ${totalPoints}");

                AppBlocProvider.of(pageContext).handler.showRewardAchievedDialog(
                    pageContext: pageContext,
                    points: achievements_services.RewardsTypePoints.machine_learning_classification_reward_point
                );
              });
            }

            _bloc.addImagePredictionResultModelToStream(imagePredictionResultModel);
            _bloc.addShowPredictionOngoingProgressIndicatorToStream(false);
            _bloc.addShowPredictionResultToStream(true);

          });

        }

        print(prediction_endpoint);
      }

    }

  }






  Future<void> animateSuccessCheck({@required BuildContext context})async{

    OverlayState overlay = Overlay.of(context);

    OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context){

      return Positioned.fill(
          child: FlareActor(
            "assets/flare/success.flr",
            animation: "success_check",
            //color: CupertinoColors.activeGreen,
            alignment: Alignment.center,
            fit: BoxFit.contain,
          )
      );
    });

    overlay.insert(overlayEntry);

    await Future.delayed(Duration(milliseconds: 3000));

    overlayEntry.remove();
    overlay.dispose();
  }

}




