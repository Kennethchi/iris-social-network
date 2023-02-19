import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/entertaitement_services/models/image_classification_challenges_models.dart';
import 'package:iris_social_network/services/machine_learning_services/machine_learning_servers_api/constants.dart' as machine_learning_services_constants;
import 'package:iris_social_network/services/machine_learning_services/machine_learning_servers_api/models/image_prediction_result_model.dart';
import 'package:iris_social_network/ui/basic_ui.dart';

import 'image_classification_challenge_bloc.dart';
import 'image_classification_challenge_bloc_provider.dart';
import 'package:iris_social_network/services/entertaitement_services/constants.dart' as entertaitement_services_constants;
import 'package:iris_social_network/services/achievements_services/achievements_services.dart' as achievements_services;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';


class ImageCLassPredictionsChallengeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    ImageClassificationChallengeBlocProvider _provider = ImageClassificationChallengeBlocProvider.of(context);
    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container();
  }
}


class ImageClassificationChallengeIntroView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    ImageClassificationChallengeBlocProvider _provider = ImageClassificationChallengeBlocProvider.of(context);
    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[

          Column(
            children: <Widget>[
              Text("Item Finder Challenge",

                style: TextStyle(
                  color: _themeData.primaryColor,
                  fontSize: Theme.of(context).textTheme.headline.fontSize,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * scaleFactor * scaleFactor,),
              Text("(Image Classification)", style: TextStyle(
                color: Colors.black.withOpacity(0.5)
              ),),

            ],
          ),

          SizedBox(height: screenHeight * scaleFactor * 0.5,),


          RichText(
              text: TextSpan(
                text: "Find  ",
                style: TextStyle(
                  color: Colors.black
                ),
                children: <TextSpan>[

                  TextSpan(text: "${entertaitement_services_constants.number_of_challenge_prediction_classes_per_day}",
                    style: TextStyle(
                      color: RGBColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.title.fontSize
                    )
                  ),
                  TextSpan(text: "  Randomly Choosen Items each day to gain Reward Points")


                ]
              ),
            textAlign: TextAlign.center,
          ),

          Column(
            children: <Widget>[

              Text("Reward Points",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.title.fontSize,
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * scaleFactor *scaleFactor,),

              ScaleAnimatedTextKit(
                text: ["+${achievements_services.RewardsTypePoints.machine_learning_classification_reward_point}"],
                textStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.display2.fontSize,
                  color: RGBColors.gold,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenHeight * scaleFactor * scaleFactor * 0.5,
              ),
              Text("per item Found", style: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontWeight: FontWeight.bold
              ),)
            ],
          ),

          Column(
            children: <Widget>[
              CupertinoButton.filled(

                  child: Text("PROCEED", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  borderRadius: BorderRadius.circular(screenWidth * scaleFactor),
                  onPressed: (){

                    _provider.pageController.nextPage(duration: Duration(milliseconds: 700), curve: Curves.easeOutBack);

                    //_provider.handlers.animateSuccessCheck(context: context);

                  }
              ),
              SizedBox(height: screenHeight * scaleFactor * 0.25,),
              Text("Analysing Images requires Internet Connection",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: Theme.of(context).textTheme.caption.fontSize
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}






class ImagePredictionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    ImageClassificationChallengeBlocProvider _provider = ImageClassificationChallengeBlocProvider.of(context);
    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          PredictionClassesWidgets(),

          Stack(
            children: <Widget>[
              SelectedImageWidget(),

              Positioned.fill(child: PredictionResultWidget())
            ],
          ),

          LaunchCameraButton()


        ],
      ),

    );
  }
}




class SelectedImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    ImageClassificationChallengeBlocProvider _provider = ImageClassificationChallengeBlocProvider.of(context);
    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return StreamBuilder<String>(
      stream: _bloc.getUserSelectedImagePathStream,
      builder: (context, snapshot) {


        if (snapshot.hasData){

          return Container(
            width: screenWidth * 0.75,
            height: screenWidth * 0.75,
            decoration: BoxDecoration(
                //color: Colors.black.withOpacity(0.05),
              color: CupertinoColors.extraLightBackgroundGray,
                image: DecorationImage(
                    image: FileImage(File(snapshot.data)),
                  fit: BoxFit.cover
                ),
              borderRadius: BorderRadius.circular(screenWidth * scaleFactor)
            ),
          );
        }
        else{

          return Container(
            width: screenWidth * 0.8,
            height: screenWidth * 0.8,
            decoration: BoxDecoration(
              //color: Colors.black.withOpacity(0.05),
              color: CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(screenWidth * scaleFactor)

            ),
            child: Center(
              child: StreamBuilder<bool>(
                stream: _bloc.getIsChallengeCompleteStream,
                builder: (context, snapshot) {

                  if(snapshot.hasData && snapshot.data){
                    return Container();
                  }
                  else{
                    return Text("Take a Photo\n for \nPredictions",
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.title.fontSize,
                        color: Colors.black.withOpacity(0.2),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                }
              ),
            ),

          );
        }


      }
    );
  }
}



class LaunchCameraButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    ImageClassificationChallengeBlocProvider _provider = ImageClassificationChallengeBlocProvider.of(context);
    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
      stream: _bloc.getIsChallengeCompleteStream,
      builder: (context, snapshot) {

        switch(snapshot.connectionState){
          case ConnectionState.none:case ConnectionState.waiting:
            return SpinKitPulse(color: _themeData.primaryColor,);
          case ConnectionState.active:case ConnectionState.done:
            if (snapshot.hasData && snapshot.data){
              return Container(
                child: ScaleAnimatedTextKit(
                  text: [
                    "Tasks Completed",
                    "Challenge will Reset at Midnight"],
                  textStyle: TextStyle(
                    color: _themeData.primaryColor,
                    fontSize: Theme.of(context).textTheme.title.fontSize,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                  alignment: AlignmentDirectional.center,
                ),
              );
            }
            else{
              return GestureDetector(

                onTap: (){

                  _provider.handlers.launchCameraAndclassifyImage(pageContext: context);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      Icon(Icons.camera_alt, size: 60.0,),


                      SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                      Text("Challenge automatically resets at Midnight", style: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(context).textTheme.caption.fontSize
                      ),
                        textAlign: TextAlign.center,
                      )


                    ],
                  ),
                ),
              );
            }
        }

      }
    );

  }
}





class PredictionClassesWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    ImageClassificationChallengeBlocProvider _provider = ImageClassificationChallengeBlocProvider.of(context);
    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<ImageClassificationChallengeModel>(

      stream: _bloc.getImageClassificationChallengeModelStream,
      builder: (context, snapshot) {

        switch(snapshot.connectionState){
          case ConnectionState.waiting: case ConnectionState.none:
            return SpinKitDoubleBounce(color: _themeData.primaryColor,);
          case ConnectionState.active:case ConnectionState.done:
          if (snapshot.hasData){

            return Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: snapshot.data.target_predictions_map_list.map((dynamic targetPredictionMap){

                int index = snapshot.data.target_predictions_map_list.indexOf(targetPredictionMap);
                Color color;
                if (index == 0){
                  color = Colors.yellow;
                }
                else if (index == 1){
                  color = Colors.purpleAccent;
                }
                else if (index == 2){
                  color = Colors.pinkAccent;
                }
                else{
                  color = _themeData.primaryColor;
                }

                TargetImagePredictionClassModel targetImagePredictionClassModel = TargetImagePredictionClassModel.fromJson(targetPredictionMap);

                return Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: screenWidth * scaleFactor,
                      backgroundColor: color,
                      child: Text(targetImagePredictionClassModel.prediction_class.replaceAll("_", " "), style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                    Container(
                      child: targetImagePredictionClassModel.is_predicted == true
                          ? Icon(FontAwesomeIcons.solidCheckCircle, color: CupertinoColors.activeGreen, size: screenWidth * scaleFactor,)
                    : Icon(FontAwesomeIcons.solidCheckCircle, color: CupertinoColors.extraLightBackgroundGray, size:  screenWidth * scaleFactor,)
                    )
                  ],
                );

              }).toList(),


              );


          }
          else{

            return Container();
          }

        }


      }
    );

  }

}






class PredictionResultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    ImageClassificationChallengeBlocProvider _provider = ImageClassificationChallengeBlocProvider.of(context);
    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<bool>(
      stream: _bloc.getShowPredictionOngoingProgressIndicatorStream,
      builder: (context, snapshotProgress) {

        switch(snapshotProgress.connectionState){

          case ConnectionState.none:case ConnectionState.waiting:
            return ProgressIndicator();
          case ConnectionState.active:case ConnectionState.done:

            if (snapshotProgress.hasData && snapshotProgress.data){
              return ProgressIndicator();
            }
            else{


              return StreamBuilder<bool>(
                stream: _bloc.getShowPredictionResultStream,
                builder: (context, snapshotShowResult) {

                  switch(snapshotShowResult.connectionState){

                    case ConnectionState.none:case ConnectionState.waiting:
                      return Container();
                    case ConnectionState.active:case ConnectionState.done:

                      if (snapshotShowResult.hasData && snapshotShowResult.data){

                        return StreamBuilder<ImagePredictionResultModel>(
                            stream: _bloc.getImagePredictionResultStream,
                            builder: (context, snapshotPredictionResult) {

                              if (snapshotPredictionResult.hasData){

                                
                                

                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.5),

                                  child: double.parse(snapshotPredictionResult.data.prediction_score)
                                      >= machine_learning_services_constants.successfulPredictionLowerBoundValue
                                      && _bloc.getImageChallengeModel.getAllTargetPredictionClasses().contains(snapshotPredictionResult.data.prediction_class)
                                      ? Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[

                                        Icon(FontAwesomeIcons.solidCheckCircle, color: CupertinoColors.activeGreen, size: screenWidth * 0.2,),
                                        Text(snapshotPredictionResult.data.prediction_class.replaceAll("_", " ",),
                                          style: TextStyle(
                                              color: CupertinoColors.activeGreen,
                                              fontSize: Theme.of(context).textTheme.headline.fontSize,
                                              fontWeight: FontWeight.bold
                                          ),
                                          textAlign: TextAlign.center,
                                        )

                                      ],),
                                  )
                                      : Icon(Icons.cancel, color: CupertinoColors.destructiveRed, size:  screenWidth * 0.2,)


                                );
                              }else{

                                //print(snapshotPredictionResult.data);

                                return Container();
                              }

                              return Container();
                            }
                        );
                      }
                      else{

                        return Container();
                      }

                  }
                  return Container();
                }
              );
            }


        }


      }
    );
  }
}



class ProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ImageClassificationChallengeBlocProvider _provider = ImageClassificationChallengeBlocProvider.of(context);
    ImageClassificationChallengeBloc _bloc = ImageClassificationChallengeBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return FittedBox(child: SpinKitPulse(color: _themeData.primaryColor, size: screenWidth * 0.5,));
  }
}
