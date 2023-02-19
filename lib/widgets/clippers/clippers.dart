import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class OvalBottomClipper extends CustomClipper<Path>{


  @override
  Path getClip(Size size) {

    Path path = new Path();

    path.lineTo(0.0, size.height * 0.925);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.925);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;


}



class OvalTopClipper extends CustomClipper<Path>{


  @override
  Path getClip(Size size) {

    Path path = new Path();

    path.lineTo(0.0, 0.075 * size.height);
    path.quadraticBezierTo(size.width / 2.0, 0.0, size.width, 0.075  * size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;


}




class ReversedOvalBottomClipper extends CustomClipper<Path>{


  @override
  Path getClip(Size size) {

    Path path = new Path();

    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(size.width / 2, (size.height * 0.9), size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;


}


