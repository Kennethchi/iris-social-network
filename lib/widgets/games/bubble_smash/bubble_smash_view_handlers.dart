import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'bubble_smash_bloc_provider.dart';
import 'bubble_smash_bloc.dart';
import 'bubble_smash_views_widgets.dart';






class BubbleSmashViewHandlers{


  void startGame({@required BuildContext gameContext}) async{

    OverlayState overlayState = Overlay.of(gameContext);
    OverlayEntry overlayEntry;

    Random _random = Random();

    BubbleSmashBloc _bloc = BubbleSmashBlocProvider.of(gameContext).bloc;

    for (int i = 0; i < double.maxFinite.toInt(); ++i){
      
      
      overlayEntry = OverlayEntry(
        builder: (BuildContext context){

          double screenWidth = MediaQuery.of(gameContext).size.width;
          double screenHeight = MediaQuery.of(gameContext).size.height;

          return Positioned(

            top: (_random.nextDouble() * screenHeight).clamp(screenHeight * 0.25, screenHeight * 0.75).toDouble(),
            left: (_random.nextDouble() * screenWidth).clamp(screenWidth * 0.25, screenWidth * 0.75).toDouble(),
            child: BubbleWidget(gameContext: gameContext,)
          );
        }
      );


      overlayState.insert(overlayEntry);
      
      await Future.delayed(Duration(milliseconds: 800), );
      overlayEntry.remove();
      
    }


  }


}
















