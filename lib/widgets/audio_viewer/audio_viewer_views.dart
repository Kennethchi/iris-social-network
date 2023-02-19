import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'audio_viewer_bloc.dart';
import 'audio_viewer_bloc_provider.dart';
import 'audio_viewer_view_widgets.dart';


class AudioViewerViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AudioViewerBlocProvider _provider = AudioViewerBlocProvider.of(context);
    AudioViewerBloc _bloc = AudioViewerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[

        Positioned.fill(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: _provider.audioImageUrl != null? DecorationImage(
                  image: CachedNetworkImageProvider(_provider.audioImageUrl),
                fit: BoxFit.cover,
              ):
                  DecorationImage(
                    image: AssetImage(AppBackgroundImages.audio_background_image_orion_nebula),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.pinkAccent, BlendMode.color)

                  )
            ),
            child: SafeArea(
              child: Icon(
                FontAwesomeIcons.music,
                color: Colors.white.withOpacity(0.15),
                size: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
          ),
        ),


        Center(
          child: SafeArea(
            child: Container(
              height: screenHeight * 0.4,
              margin: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.125 * 0.33)
              ),
                child: Center(child: AudioWidget(audioUrl: _provider.audioUrl, audioViewerBloc: _bloc,)),
            ),
          ),
        ),

        Positioned(
            top: 0.0,
            right: 0.0,
            child: SafeArea(child: DownloadWidgetIndicator())
        ),
      ],
    );;
  }
}
