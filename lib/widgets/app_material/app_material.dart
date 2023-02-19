import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/percent_indicator.dart';


class GlowCircleAvatar extends StatefulWidget {

  CircleAvatar circleAvatar;
  Color glowColor;

  GlowCircleAvatar({@required this.circleAvatar, this.glowColor}):
      assert(circleAvatar != null, "circleAvatar of GlowCircleAvatar should not be null")
  {

    if (glowColor == null){
      glowColor = Colors.blue;
    }
  }

  @override
  _GlowCircleAvatarState createState() => _GlowCircleAvatarState();
}

class _GlowCircleAvatarState extends State<GlowCircleAvatar> with SingleTickerProviderStateMixin {


  AnimationController _animationController;
  Animation<double> _shadowAnimation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _shadowAnimation = Tween(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.repeat();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _animationController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {



    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child){

        return Container(
            decoration: BoxDecoration(

                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: widget.glowColor,
                    spreadRadius: _shadowAnimation.value *  6.0,
                    blurRadius: _shadowAnimation.value * 14.0,
                  ),
                ]
            ),
            child: widget.circleAvatar
        );

      },
    );
  }
}





class ProgressPercentIndicator extends StatelessWidget{

  Stream<double> progressPercentRatioStream;
  Color color;

  ProgressPercentIndicator({@required this.progressPercentRatioStream, this.color});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    double checkPointProgress = 0.0;



    return StreamBuilder<double>(
      stream: this.progressPercentRatioStream,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot){

        return CircularPercentIndicator(

          animation: false,
          radius: MediaQuery.of(context).size.width * 0.33,
          lineWidth: 5.0,
          percent: snapshot.hasData? snapshot.data: 0.0,
          center: Text(

            snapshot.hasData?   "${(snapshot.data * 100).round()}%"   : "${0.round()}%",

            style: TextStyle(
              color: this.color == null? CupertinoTheme.of(context).primaryColor: this.color,
              fontSize: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.fontSize
          ),),
          progressColor: this.color == null? CupertinoTheme.of(context).primaryColor: this.color,

        );


      },
    );



  }

}







