import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart' as assets_constants;
import 'post_feed_bloc_provider.dart';
import 'post_feed_bloc.dart';
import 'package:iris_social_network/utils/string_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/modules/home/home_bloc_provider.dart';




class PostFeedSliverAppBarView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PostFeedBloc _bloc = PostFeedBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double appBarSizeFactor = 0.15;


    return SliverAppBar(
      expandedHeight: screenHeight * appBarSizeFactor * 0.75,
      //floating: true,
      //pinned: true,
      elevation: 1.0,

      backgroundColor: Colors.transparent,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(


          title: Container(),

          background: Container(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(right: screenWidth * scaleFactor * scaleFactor),
                  child: InkWell(

                    onTap: (){


                      if (_bloc.getPostType != null){

                        _bloc.addPostTypeToStream(null);

                        _bloc.loadPosts(
                            postType: null,
                            postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
                            postQueryLimit: _bloc.getPostsQueryLimit
                        );

                        AppBlocProvider.of(context).bloc.addBackgroundColorValueToStream(Colors.white.value);
                      }


                    },


                    child: StreamBuilder<String>(
                      
                      stream: AppBlocProvider.of(context).bloc.getBackgroundImageStream,
                      builder: (context, snapshot) {
                        return Container(
                          width: screenHeight * appBarSizeFactor * 1.2,
                          height: screenWidth * appBarSizeFactor,
                          decoration: BoxDecoration(
                              color: _themeData.primaryColor,
                            borderRadius: BorderRadius.circular(screenWidth * scaleFactor * appBarSizeFactor),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(snapshot.hasData? snapshot.data: ""),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(_themeData.primaryColor, BlendMode.color)
                            )
                          ),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[

                                Icon(CupertinoIcons.person_solid, color: Colors.white,),

                                Text("Public", style: TextStyle(color: Colors.white, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),)


                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * scaleFactor),
                  child: InkWell(

                    onTap: (){


                      if (_bloc.getPostType != constants.PostType.video){

                        _bloc.addPostTypeToStream(constants.PostType.video);

                        _bloc.loadPosts(
                            postType: constants.PostType.video,
                            postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
                            postQueryLimit: _bloc.getPostsQueryLimit
                        );

                        AppBlocProvider.of(context).bloc.addBackgroundColorValueToStream(Colors.purple.value);
                      }

                    },

                    child: Container(
                      width: screenHeight * appBarSizeFactor * 1.2,
                      height: screenWidth * appBarSizeFactor,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidth * scaleFactor * appBarSizeFactor),
                          image: DecorationImage(
                              image: AssetImage(assets_constants.PostTypeBackgroundImages.video),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(Colors.purple, BlendMode.color)

                          )
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Icon(FontAwesomeIcons.film, color: Colors.white,),

                            Text("Video", style: TextStyle(color: Colors.white, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),)


                          ],
                        ),
                      ),
                    ),
                  ),
                ),



                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * scaleFactor),
                  child: InkWell(

                    onTap: (){



                      if (_bloc.getPostType != constants.PostType.image){

                        _bloc.addPostTypeToStream(constants.PostType.image);

                        _bloc.loadPosts(
                            postType: constants.PostType.image,
                            postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
                            postQueryLimit: _bloc.getPostsQueryLimit
                        );

                        AppBlocProvider.of(context).bloc.addBackgroundColorValueToStream(Colors.yellowAccent.value);

                      }


                    },

                    child: Container(
                      width: screenHeight * appBarSizeFactor * 1.2,
                      height: screenWidth * appBarSizeFactor,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidth * scaleFactor * appBarSizeFactor),
                          image: DecorationImage(
                              image: AssetImage(assets_constants.PostTypeBackgroundImages.image),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(Colors.yellowAccent, BlendMode.color)
                          )
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Icon(FontAwesomeIcons.solidImages, color: Colors.white,),

                            Text("Image", style: TextStyle(color: Colors.white, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),)


                          ],
                        ),
                      ),
                    ),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * scaleFactor),
                  child: InkWell(

                    onTap: (){



                      if (_bloc.getPostType != constants.PostType.audio){

                        _bloc.addPostTypeToStream(constants.PostType.audio);

                        _bloc.loadPosts(
                            postType: constants.PostType.audio,
                            postQueryType: app_constants.POST_QUERY_TYPE.MOST_RECENT,
                            postQueryLimit: _bloc.getPostsQueryLimit
                        );

                        AppBlocProvider.of(context).bloc.addBackgroundColorValueToStream(Colors.pinkAccent.value);
                      }


                    },

                    child: Container(
                      width: screenHeight * appBarSizeFactor * 1.2,
                      height: screenWidth * appBarSizeFactor,
                      decoration: BoxDecoration(
                          color: CupertinoColors.activeOrange,
                          borderRadius: BorderRadius.circular(screenWidth * scaleFactor * appBarSizeFactor),
                        image: DecorationImage(
                          image: AssetImage(assets_constants.PostTypeBackgroundImages.audio),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.pinkAccent, BlendMode.color)
                        )
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Icon(FontAwesomeIcons.headphonesAlt, color: Colors.white,),

                            Text("Audio", style: TextStyle(color: Colors.white, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),)

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )
        //centerTitle: true,

      ),
      
      actions: <Widget>[

        //IconButton(icon: Icon(Icons.add), onPressed: (){})

      ],


    );

  }

}











class LoadingPostsIndicatorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostFeedBloc _bloc = PostFeedBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return SliverList(delegate: SliverChildListDelegate(
        <Widget>[
          Container(
              child: StreamBuilder(
                stream: _bloc.getHasMorePostsStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.waiting:
                      return SpinKitChasingDots(color: _themeData.primaryColor,);
                    case ConnectionState.active: case ConnectionState.done:

                    if (snapshot.hasData && snapshot.data){
                      return SpinKitChasingDots(color: _themeData.primaryColor,);
                    }
                    else{

                      return Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * scaleFactor * 0.25,
                            bottom: screenHeight * scaleFactor
                        ),
                        child: Center(
                          child: StreamBuilder<String>(
                            stream: _bloc.getPostTypeStream,
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                              if (snapshot.hasData){

                                switch(snapshot.data){
                                  case constants.PostType.video:
                                    return Text(_bloc.getPostsList.length > 0? "No More Videos": "No Videos",
                                      style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                                    );
                                  case constants.PostType.image:
                                    return Text(_bloc.getPostsList.length > 0? "No More Images": "No Images",
                                      style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                                    );
                                  case constants.PostType.audio:
                                    return Text(_bloc.getPostsList.length > 0? "No More Audios": "No Audios",
                                      style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                                    );
                                  default:
                                    return Text(_bloc.getPostsList.length > 0? "No More Posts": "No Posts",
                                      style: TextStyle(fontSize: Theme.of(context).textTheme.title.fontSize, color: _themeData.primaryColor),
                                    );
                                }

                              }
                              {
                                return Text(_bloc.getPostsList.length > 0? "No More Posts": "No Posts",
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
          )
        ]
    ));
  }

}












