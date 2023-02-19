
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';






class Mole extends StatefulWidget {

  double moleWidth;
  double moleHeight;
  Color color;

  VoidCallback onTap;

  Mole({
    @required this.moleWidth,
    @required this.moleHeight,
    @required this.color,
    @required this.onTap
}){
    if (moleWidth == null){
      moleWidth = 50.0;
    }
    if (moleHeight == null){
      moleHeight = 50.0;
    }
    if(color == null){
      color = Colors.blueAccent;
    }
  }


  @override
  _MoleState createState() => _MoleState();
}

class _MoleState extends State<Mole> {
  final List<MoleParticle> particles = [];

  bool _moleIsVisible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _moleIsVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.moleWidth,
      height: widget.moleHeight,
      child: _buildMole(),
    );
  }

  Rendering _buildMole() {
    return Rendering(
      onTick: (time) => _manageParticleLifecycle(time),
      builder: (context, time) {
        return Stack(
          overflow: Overflow.visible,
          children: [
            if (_moleIsVisible)
              GestureDetector(onTap: (){

                _hitMole(time);

                if (widget.onTap !=null){
                  widget.onTap;
                }
              }, child: _mole()),
            ...particles.map((it) => it.buildWidget(time))
          ],
        );
      },
    );
  }

  Widget _mole() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
              colors: [Colors.white, Colors.blueAccent.withOpacity(0.4), Colors.blueAccent],
              stops: [0.1, 0.3, 0.8],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
      ),
    );
  }

  _hitMole(Duration time) {
    _moleIsVisible = false;
    Iterable.generate(50).forEach((i) => particles.add(MoleParticle(time: time, color: widget.color)));
  }

  _manageParticleLifecycle(Duration time) {
    particles.removeWhere((particle) {
      return particle.progress.progress(time) == 1;
    });
  }

}







class MoleParticle {
  Animatable tween;
  AnimationProgress progress;

  Color color;

  MoleParticle({@required Duration time, @required  Color color}) {
    final random = Random();
    final x = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);
    final y = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);

    tween = MultiTrackTween([
      Track("x").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: x)),
      Track("y").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: y)),
      Track("scale").add(Duration(milliseconds: 500), Tween(begin: 1.0, end: 0.0))
    ]);
    progress = AnimationProgress(
        startTime: time, duration: Duration(milliseconds: 300));
  }

  buildWidget(Duration time) {
    final animation = tween.transform(progress.progress(time));
    return Positioned(
      left: animation["x"],
      top: animation["y"],
      child: Transform.scale(
        scale: animation["scale"],
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              //color: Colors.brown,
              borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
                colors: [Colors.white, Colors.blueAccent.withOpacity(0.4), Colors.blueAccent],
                stops: [0.1, 0.3, 0.8],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            )
          ),

        ),
      ),
    );
  }
}