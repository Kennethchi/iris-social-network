import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';

import 'avatar_image_generator_bloc.dart';
import 'avatar_image_generator_bloc_provider.dart';

import 'avatar_image_generator_view.dart';



class AvatarImageGenerator extends StatefulWidget {
  @override
  _AvatarImageGeneratorState createState() => _AvatarImageGeneratorState();
}

class _AvatarImageGeneratorState extends State<AvatarImageGenerator> {

  AvatarImageGeneratorBloc _bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = AvatarImageGeneratorBloc();
  }


  @override
  Widget build(BuildContext context) {
    return AvatarImageGeneratorBlocProvider(
      bloc: _bloc,
      child: Scaffold(

        backgroundColor: Colors.transparent,

        body: Container(
          child: CupertinoPageScaffold(

              child: AvatarImageGeneratorView(),

            //backgroundColor: Colors.blue,
            backgroundColor: Colors.transparent,
          ),
        )

      ),
    );;
  }
}




