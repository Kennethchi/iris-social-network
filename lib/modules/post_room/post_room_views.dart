import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iris_social_network/modules/post_room/post_room_views_widgets.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'post_room_bloc.dart';
import 'post_room_bloc_provider.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'video_post_widgets.dart';
import 'audio_post_widgets.dart';
import 'image_post_widgets.dart';



class PostRoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    PostRoomBlocProvider _provider = PostRoomBlocProvider.of(context);
    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      child: StreamBuilder<PostModel>(
          stream: _bloc.getPostModelStream,
          builder: (BuildContext context, AsyncSnapshot<PostModel> snapshot) {

            switch(snapshot.connectionState){
              case ConnectionState.none: case ConnectionState.waiting:
                return Container();
              case ConnectionState.active:case ConnectionState.done:

                if (snapshot.hasData){

                  switch(snapshot.data.postType){

                    case constants.PostType.image:
                      return ImagePostView(postModel: snapshot.data,);
                    case constants.PostType.video:
                      return VideoPostView(postModel: snapshot.data);
                    case constants.PostType.audio:
                      return AudioPostView(postModel: snapshot.data);
                    default:
                      return Container(
                        child: Center(
                          child: Text("Unknown Post Type", style: TextStyle(
                              fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
                            color: _themeData.primaryColor
                          ),
                          ),
                        ),
                      );

                  }

                }
                else{
                  return Container(
                    child: Center(
                      child: Text("Post Not Found", style: TextStyle(
                          fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
                        color: _themeData.primaryColor
                      ),),
                    ),
                  );
                }

            }



          }
      ),
    );
  }
}





class VideoPostView extends StatelessWidget {

  PostModel postModel;

  VideoPostView({@required this.postModel});

  @override
  Widget build(BuildContext context) {


    PostRoomBlocProvider _provider = PostRoomBlocProvider.of(context);
    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    /*
    return Container(
      child: VideoWidget(videoModel: this.videoModel, postRoomBloc: _bloc),
    );
    */

    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: <Widget>[

          Positioned.fill(
            child: Container(
              child: VideoWidget(videoModel: VideoModel.fromJson(postModel.postData), postRoomBloc: _bloc),
            ),
          ),


          Positioned.fill(
            child: VideoViewOverlayWidget(postModel: postModel,),
          )

        ],
      ),
    );
  }
}



class ImagePostView extends StatelessWidget {

  PostModel postModel;

  ImagePostView({@required this.postModel});


  @override
  Widget build(BuildContext context) {


    PostRoomBlocProvider _provider = PostRoomBlocProvider.of(context);
    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            child: ImageWidget(imageModel: ImageModel.fromJson(this.postModel.postData), postRoomBloc: _bloc,),
          ),
        ),

        Positioned.fill(
          child: Container(
            child: ImageViewOverlayWidget(postModel: postModel),
          ),
        )
      ],
    );
  }
}



class AudioPostView extends StatelessWidget {

  PostModel postModel;

  AudioPostView({@required this.postModel});

  @override
  Widget build(BuildContext context) {


    PostRoomBlocProvider _provider = PostRoomBlocProvider.of(context);
    PostRoomBloc _bloc = PostRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: <Widget>[

          Positioned(
              child: Center(
                child: AudioWidget(audioModel: AudioModel.fromJson(postModel.postData), postRoomBloc: _bloc,),
              )
          ),

          Positioned.fill(
            child: AudioViewOverlayWidget(postModel: postModel),
          ),
        ],
      ),
    );
  }
}



