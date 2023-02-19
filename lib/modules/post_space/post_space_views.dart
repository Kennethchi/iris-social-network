import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_video_preview_model.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'post_space_bloc_provider.dart';
import 'post_space_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';


import 'package:iris_social_network/modules/profile/profile_bloc.dart';
import 'package:iris_social_network/modules/post_feed/post_feed_bloc.dart';


import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/modules/post_room/post_room.dart';

import 'package:iris_social_network/services/constants/constants.dart' as constants;



class PostSpaceSwiperView extends StatelessWidget{

  List<PostModel>  postsList;


  PostSpaceSwiperView({@required this.postsList});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostSpaceBloc  _postSpaceBloc = PostSpaceBlocProvider.of(context).postsSpaceBloc;


    return StreamBuilder<List<PostModel>>(

        stream: _postSpaceBloc.getPostsListStream,
        builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshots){

          if (snapshots.hasData){

            return Swiper.children(
              controller: PostSpaceBlocProvider.of(context).swiperController,
              index: PostSpaceBlocProvider.of(context).swiperController.index,
              loop: false,
              scrollDirection: Axis.horizontal,

              onIndexChanged: (int index){

                // sets currentIndex so as to return to this index when the post space rebuilds due to focus on keyboard
                _postSpaceBloc.setCurrentPostViewIndex = index;
                PostSpaceBlocProvider.of(context).swiperController.index = _postSpaceBloc.getCurrentPostViewIndex;


                if (index == this.postsList.length){

                  PostSpaceBlocProvider.of(context).handlers.loadMorePostsToPostSpace(
                      context: context,
                      currentIndex: index,
                      dynamicBloc: PostSpaceBlocProvider.of(context).dynamicBloc
                  );
                }

              },

              children: <Widget>[

                for (int index = 0; index < this.postsList.length; ++index)

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,

                      child: PostRoom(postModel: this.postsList[index],),
                    ),

                Container(child: LoadingPostsIndicatorWidget(),)

              ],

              viewportFraction: 1.0,
              scale: 0.0,
              curve: Curves.linear,
            );


          }
          else{

            return LoadingPostsIndicatorWidget();
          }

        }

    );

  }

}






class LoadingPostsIndicatorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    dynamic dynamicBloc = PostSpaceBlocProvider.of(context).dynamicBloc;



    return Container(
        width: screenWidth,
        height: screenHeight,
        color: RGBColors.black,
        child: StreamBuilder(
          stream: PostSpaceBlocProvider.of(context).handlers.getHasMorePostStreamFromDynamicBloc(dynamicBloc: dynamicBloc),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

            switch(snapshot.connectionState){
              case ConnectionState.none:
                return Container();
              case ConnectionState.waiting:
                return SpinKitChasingDots(color: _themeData.primaryColor,);
              case ConnectionState.active: case ConnectionState.done:

              if (snapshot.hasData && snapshot.data){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SpinKitChasingDots(color: _themeData.primaryColor,),
                    SizedBox(height: screenHeight * scaleFactor * 0.5,),

                    StreamBuilder<String>(
                      stream: PostSpaceBlocProvider.of(context).handlers.getPostTypeStreamFromDynamicBloc(dynamicBloc: dynamicBloc),
                      builder: (context, snapshot) {


                        if (snapshot.hasData){

                          switch(snapshot.data){
                            case constants.PostType.video:
                              return Text("Loading More Videos...",
                                style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                              );
                            case constants.PostType.image:
                              return Text("Loading More Images...",
                                style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                              );
                            case constants.PostType.audio:
                              return Text("Loading More Audios...",
                                style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                              );
                            default:
                              return Text("Loading More Posts...",
                                style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                              );
                          }

                        }
                        {
                          return Text("Loading More...",
                            style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                          );
                        }
                      }
                    ),

                  ],
                );
              }
              else{
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.125),
                  child: Center(
                    child: StreamBuilder<String>(
                      stream: PostSpaceBlocProvider.of(context).handlers.getPostTypeStreamFromDynamicBloc(dynamicBloc: dynamicBloc),

                      builder: (context, snapshot) {
                        if (snapshot.hasData){

                          switch(snapshot.data){
                            case constants.PostType.video:
                              return Text("No More Videos",
                                style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                              );
                            case constants.PostType.image:
                              return Text("No More Images",
                                style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                              );
                            case constants.PostType.audio:
                              return Text("No More Audios",
                                style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                              );
                            default:
                              return Text("No More Posts",
                                style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                              );
                          }

                        }
                        {
                          return Text("No More Posts",
                            style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                          );
                        }
                      }
                    ),
                  ),
                );
              }
            }


          },
        )
    );

  }



}







