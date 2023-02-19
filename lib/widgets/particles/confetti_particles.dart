import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class ConfettiParticles extends StatefulWidget {

  Duration duration;

  ConfettiParticles({@required this.duration});


  @override
  _ConfettiParticlesState createState() => _ConfettiParticlesState();
}

class _ConfettiParticlesState extends State<ConfettiParticles> {
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerTopCenter;
  ConfettiController _controllerBottomCenter;
  ConfettiController _controllerBottomLeft;
  ConfettiController _controllerBottomRight;



  @override
  void initState() {
    _controllerCenterRight = ConfettiController(duration: widget.duration);
    _controllerCenterLeft = ConfettiController(duration: widget.duration);
    _controllerTopCenter = ConfettiController(duration: widget.duration);
    _controllerBottomCenter = ConfettiController(duration: widget.duration);
    _controllerBottomLeft = ConfettiController(duration: widget.duration);
    _controllerBottomRight = ConfettiController(duration: widget.duration);


    super.initState();



    _controllerCenterRight.play();
    _controllerCenterLeft.play();
    _controllerTopCenter.play();



    /*
    _controllerBottomLeft.play();
    _controllerBottomCenter.play();
    _controllerBottomRight.play();
    */

  }

  @override
  void dispose() {
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();
    _controllerBottomLeft.dispose();
    _controllerBottomRight.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        Align(
          alignment: Alignment.centerRight,
          child: ConfettiWidget(
            confettiController: _controllerCenterRight,
            blastDirection: pi, // radial value - LEFT
            emissionFrequency: 0.3, // 0.5
            numberOfParticles: 1,
          ),
        ),

        Align(
          alignment: Alignment.centerLeft,
          child: ConfettiWidget(
            confettiController: _controllerCenterLeft,
            blastDirection: 0, // radial value - RIGHT
            emissionFrequency: 0.3,
            numberOfParticles: 1,
          ),
        ),

        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerTopCenter,
            blastDirection: pi / 2,
            maxBlastForce: 50,
            minBlastForce: 20,
            emissionFrequency: 0.3,
            numberOfParticles: 1, // 50
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _controllerBottomCenter,
            blastDirection: -pi / 2,
            emissionFrequency: 0.01,
            numberOfParticles: 20,
            maxBlastForce: 100,
            minBlastForce: 40,
          ),
        ),


        /*
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _controllerBottomLeft,
            blastDirection: -pi * 2 / 3.5,
            emissionFrequency: 0.01,
            numberOfParticles: 20,
            maxBlastForce: 100,
            minBlastForce: 40,
          ),
        ),


        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _controllerBottomRight,
            blastDirection: -pi / 2.5,
            emissionFrequency: 0.01,
            numberOfParticles: 20,
            maxBlastForce: 100,
            minBlastForce: 40,
          ),
        ),
        */

      ],
    );
  }


}