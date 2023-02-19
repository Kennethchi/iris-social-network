import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'post_feed_bloc.dart';
import 'post_feed_bloc_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/models/video_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';

import 'post_feed_views_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:iris_social_network/modules/post_space/post_space.dart';
import 'package:animator/animator.dart';







class PostFeedView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(

      child: CustomScrollView(

        controller: PostFeedBlocProvider.of(context).scrollController,
        slivers: <Widget>[


          PostFeedSliverAppBarView(),

          SliverPadding(
              padding: EdgeInsets.all(screenWidth * scaleFactor * scaleFactor),
              sliver: PostsSliverMainView()
          ),

          SliverPadding(
              padding: EdgeInsets.all(0.0),
              sliver: LoadingPostsIndicatorWidget()

          )


        ],

      ),
    );
  }
}







class PostsSliverMainView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PostFeedBloc _bloc = PostFeedBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;




    return StreamBuilder<String>(
        stream: _bloc.getPostTypeStream,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){


          switch(snapshot.connectionState){

            case ConnectionState.none: case ConnectionState.waiting:
              return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: screenWidth * scaleFactor * scaleFactor,
                      mainAxisSpacing: screenWidth * scaleFactor * scaleFactor,
                      childAspectRatio: 10 / 16
                  ),
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index){
                    return Container(
                      padding: EdgeInsets.all(2.0),
                      child: Animator(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        cycles: 1000000000,
                        curve: Curves.elasticOut,
                        duration: Duration(seconds: 1),
                        builder: (anim){
                          return Transform.scale(
                            scale: anim.value,
                            child: Container(
                              height: screenHeight,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25),
                                color: RGBColors.light_grey_level_1,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                      childCount: 4
                  )
              );

            case ConnectionState.active: case ConnectionState.done:
              return _PostsSliverGridView();

          }

        }
    );
  }


}















class _PostsSliverGridView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PostFeedBloc _bloc = PostFeedBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<List<PostModel>>(
        stream: _bloc.getPostsListStream,
        builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshots){



          if (snapshots.hasData){

            if (snapshots.data.length == 0){
              return SliverList(delegate: SliverChildListDelegate(
                  <Widget>[

                    Container(),
                  ]
              ),);
            }
            else{



              return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: screenWidth * scaleFactor * scaleFactor,
                      mainAxisSpacing: screenWidth * scaleFactor * scaleFactor,
                      childAspectRatio: 10 / 16
                  ),
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index){

                    return GestureDetector(
                      onTap: (){

                        Navigator.of(context).push(
                            PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> primaryAnimation, Animation<double> secondaryAnimation){
                              return PostSpace(
                                  dynamicBloc: _bloc,
                                  postsList: snapshots.data,
                                  currentPostViewIndex: index
                              );
                            }, transitionDuration: Duration(milliseconds: 500)
                            ));

                      },
                      child: Animator(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        //cycles: 1,
                        repeats: 1,
                        curve: Curves.elasticOut,
                        duration: Duration(seconds: 1),
                        builder: (anim){
                          return Transform.scale(
                            scale: anim.value,
                            child: Card(
                              elevation: 0.0,
                              child: Hero(
                                  tag: snapshots.data[index].postId,
                                  child: PostFeedBlocProvider.of(context).handlers.getPostPreviewWidget(
                                      postFeedContext: context,
                                      postModel: snapshots.data[index]
                                  )
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                    childCount: snapshots.data.length,
                  )
              );

            }


          }
          else{

            return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: 10 / 16
                ),
                delegate: SliverChildBuilderDelegate((BuildContext context, int index){
                  return Container(
                    padding: EdgeInsets.all(2.0),
                    child: Animator(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      cycles: 1000000000,
                      curve: Curves.elasticOut,
                      duration: Duration(seconds: 1),
                      builder: (anim){
                        return Transform.scale(
                          scale: anim.value,
                          child: Container(
                            height: screenHeight,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.25),
                              color: RGBColors.light_grey_level_1,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                    childCount: 4
                )
            );
          }


        }
    );
  }

}






