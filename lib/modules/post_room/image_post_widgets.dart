import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:chewie/chewie.dart';
import 'package:iris_social_network/widgets/image_viewer/image_viewer.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'post_room_bloc.dart';
import 'post_room_bloc_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/utils/string_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:iris_social_network/widgets/marquee/marquee.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:iris_social_network/widgets/app_material/app_material.dart';
import 'package:iris_social_network/modules/profile/profile.dart';

import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/services/constants/app_constants.dart' as app_contants;

import 'video_post_widgets.dart' as video_post_widgets;
import 'audio_post_widgets.dart' as audio_posts_widgets;
import 'package:soundpool/soundpool.dart';




class ImageWidget extends StatefulWidget {

  ImageModel imageModel;
  PostRoomBloc postRoomBloc;

  ImageWidget({@required this.imageModel, @required this.postRoomBloc});


  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {

  SwiperController _swiperController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _swiperController = SwiperController();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _swiperController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Container(
        child: Swiper(
            itemWidth: MediaQuery.of(context).size.width * 0.9,
            itemHeight: MediaQuery.of(context).size.width * 0.9,
            controller: _swiperController,
            scrollDirection: Axis.vertical,
            layout: widget.imageModel.imagesThumbsUrl.length > 1? SwiperLayout.STACK: SwiperLayout.DEFAULT,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(

                onTap: (){

                  Navigator.of(context).push(
                      PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> primaryAnimation, Animation<double> secondaryAnimation){
                        return ImageViewer(
                          imageList:  widget.imageModel.imagesUrl.cast<String>(),
                          currentIndex: index,
                        );
                      }, transitionDuration: Duration(milliseconds: 700)
                      ));

                },

                child: Hero(
                  tag: widget.imageModel.imagesUrl[index],
                  child: CachedNetworkImage(
                      imageUrl: widget.imageModel.imagesUrl[index],
                      fit: widget.imageModel.imagesUrl.length > 1? BoxFit.cover: BoxFit.contain
                  ),
                ),
              );
            },
            itemCount: widget.imageModel.imagesUrl.length,
            viewportFraction: 0.8,  // 0.8
            scale: 0.9,  //  0.9
            loop: false,
            curve: Curves.ease,
            onIndexChanged: (int index){

              // change background when images are swiped
              widget.postRoomBloc.addPostBackgroundImageToStream(widget.imageModel.imagesThumbsUrl[index]);

              widget.postRoomBloc.addImagesCurrentIndexToStream(index);

            }
        )
    );
  }
}







class ImageCountWidget extends StatelessWidget{

  ImageModel imageModel;

  ImageCountWidget({@required this.imageModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double scaleFactor = 0.125;



    if (imageModel.imagesThumbsUrl.length == 1){
      return Container();
    }
    else{
      return StreamBuilder<int>(
        stream: _bloc.getImagesCurrentIndexStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot){

          if (snapshot.hasData){

            return Container(
                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.125),
                decoration: BoxDecoration(
                    color: RGBColors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(screenWidth)
                ),
                child: Text("${snapshot.data + 1}" + " / " + "${imageModel.imagesThumbsUrl?.length}",
                  style: TextStyle(color: RGBColors.white.withOpacity(0.7)),)
            );


          }
          else{
            return Container(
                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.125),
                decoration: BoxDecoration(
                    color: RGBColors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(screenWidth)
                ),
                child: Text("0 / 0",
                  style: TextStyle(color: RGBColors.white.withOpacity(0.7)),)
            );
          }


        },
      );
    }





  }
}

