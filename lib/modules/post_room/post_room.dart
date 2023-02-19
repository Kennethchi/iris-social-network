import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'post_room_views.dart';
import 'post_room_bloc_provider.dart';
import 'post_room_bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'dart:ui';




class PostRoom extends StatefulWidget {

  PostModel postModel;

  PostRoom({@required this.postModel});


  @override
  _PostRoomState createState() => _PostRoomState();
}

class _PostRoomState extends State<PostRoom> {


  PostRoomBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = PostRoomBloc(postModel: widget.postModel);
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return PostRoomBlocProvider(
      bloc: _bloc,
      child: Scaffold(

        body: StreamBuilder<String>(
          stream: _bloc.getPostBackgroundImageStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {


            return Stack(
              children: <Widget>[

                Positioned.fill(
                  child: Hero(
                      tag: widget.postModel.postId,
                      child: CachedNetworkImage(
                          imageUrl: snapshot.hasData? snapshot.data: "",
                        fit: BoxFit.cover,
                      )
                  ),
                ),

                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: app_constants.WidgetsOptions.blurSigmaX,
                        sigmaY: app_constants.WidgetsOptions.blurSigmaY

                    ),
                    child: CupertinoPageScaffold(

                        backgroundColor: Colors.transparent,

                        child: PostRoomView()
                    ),
                  ),
                )


              ],
            );


          }
        ),


      ),
    );
  }
}
