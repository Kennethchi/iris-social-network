import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'post_bloc.dart';
import 'post_bloc_provider.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'dart:io';
import 'post_views_widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:emoji_picker/emoji_picker.dart';



class PostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      child: PageView(
        controller: _provider.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[

          Container(
            child: StreamBuilder<String>(
              stream: _bloc.getPostTypeStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                if (snapshot.hasData){

                  switch(snapshot.data){

                    case constants.PostType.image:
                      return ImagePostView();
                    case constants.PostType.video:
                      return VideoPostView();
                    case constants.PostType.audio:
                      return AudioPostView();
                    default:
                      return Container(
                        child: Center(
                          child: Text("Unknown Post Type", style: TextStyle(fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
                        ),
                      );

                  }

                }
                else{
                  return Container(
                    child: Center(
                      child: Text("No Data", style: TextStyle(fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
                    ),
                  );
                }

              }
            ),
          ),

          PostSettingsView(),

          PublishPostView()

        ],
      ),
    );
  }
}




class ImagePostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    
    return CupertinoPageScaffold(

      backgroundColor: Colors.transparent,

      navigationBar: CupertinoNavigationBar(
        
        middle: Text('Post Image', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
        backgroundColor: Colors.white.withOpacity(0.2),
        trailing: StreamBuilder<List<String>>(
          stream: _bloc.getImagesPathStream,
          builder: (context, snapshot) {
            return MaterialButton(
                child: Text("Next", 
                  style: TextStyle(
                      color: snapshot.hasData && snapshot.data.length > 0? _themeData.primaryColor: Colors.black.withOpacity(0.2)),
                ),

                onPressed: snapshot.hasData && snapshot.data.length > 0? (){

                  _provider.pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOutBack);

                }: null
                );
          }
        ),
      ),
      child: SafeArea(
        child: StreamBuilder<List<String>>(
          stream: _bloc.getImagesPathStream,
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            return Container(
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(screenWidth * scaleFactor * 0.33),
                    child: TextField(
                      controller: _provider.postCaptionTextEditingController,
                      style: TextStyle(
                        color: _themeData.barBackgroundColor,
                      ),
                      maxLines: null,
                      cursorColor: _themeData.primaryColor,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                        focusColor: _themeData.primaryColor,
                        hintText: "Enter Caption...",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  SizedBox(height: scaleFactor * screenHeight * 0.5,),

                  Flexible(
                      flex: 100,
                        //child: Image.file(File(snapshot.hasData? snapshot.data[0]: ""), fit: BoxFit.contain,)
                      child: snapshot.data == null? Container(child: Center(child: Text("No Images", style: TextStyle(
                          color: _themeData.barBackgroundColor,
                          fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                        ),)),)

                          : Swiper(

                        controller: _provider.imagesSwiperController,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.file(File(snapshot.data[index]), fit: BoxFit.contain,);
                        },
                        itemCount: snapshot.data.length,
                        viewportFraction: 0.8,
                        scale: 0.9,
                        loop: false,
                        onIndexChanged: (int index){

                          // change background when images are swiped
                          if (snapshot.hasData){
                            _bloc.addPostBackgroundImageToStream(snapshot.data[index]);
                          }


                        },
                      ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(screenWidth * scaleFactor * 0.33),
                    child: ImagesListWidget(),
                  )


              ],
              ),
            );
          }
        ),
      ),
    );
  }
}


class VideoPostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return CupertinoPageScaffold(

      backgroundColor: Colors.transparent,

      navigationBar: CupertinoNavigationBar(
        middle: Text('Post Video', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
        backgroundColor: Colors.white.withOpacity(0.2),
        trailing: StreamBuilder<String>(
          stream: _bloc.getVideoThumbNailPathStream,
          builder: (context, snapshot) {
            return MaterialButton(
                child: Text("Next", style: TextStyle(color: snapshot.hasData? _themeData.primaryColor: Colors.black.withOpacity(0.2)),),
                onPressed: snapshot.hasData? (){

                  _provider.pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOutBack);

                }: null
            );
          }
        ),
      ),
      child: SafeArea(
        child: StreamBuilder<String>(
            stream: _bloc.getVideoThumbNailPathStream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Container(
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.all(screenWidth * scaleFactor * 0.33),
                      child: TextField(
                        controller: _provider.postCaptionTextEditingController,
                        maxLines: null,
                        style: TextStyle(
                            color: _themeData.barBackgroundColor
                        ),
                        cursorColor: _themeData.primaryColor,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                          hintText: "Enter Caption...",
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    //SizedBox(height: scaleFactor * screenHeight * 0.5,),

                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: <Widget>[
                            VideoThumbNailWidget(),
                            Text("View Thumbnail", style: TextStyle(color: _themeData.barBackgroundColor),)
                          ],
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 100,
                      child: StreamBuilder(
                        stream: _bloc.getVideoPathStream,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                          if (snapshot.hasData){
                            return VideoWidget(videoFile: File(snapshot.data), postBloc: _bloc);
                          }
                          else
                            return Container(
                              child: Center(
                                child: Text("Video not Found",
                                  style: TextStyle(color: _themeData.barBackgroundColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                                ),
                              ),
                            );

                        }
                      ),
                    ),


                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}


class AudioPostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return  CupertinoPageScaffold(

      backgroundColor: Colors.transparent,

      navigationBar: CupertinoNavigationBar(
        middle: Text('Post Audio', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
        backgroundColor: Colors.white.withOpacity(0.2),
        trailing: StreamBuilder<String>(
          stream: _bloc.getAudioPathStream,
          builder: (context, snapshot) {
            return MaterialButton(
                child: Text("Next", style: TextStyle(color: snapshot.hasData? _themeData.primaryColor: Colors.black.withOpacity(0.2)),),
                onPressed: snapshot.hasData? (){

                  _provider.pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOutBack);
                }: null
            );
          }
        ),
      ),
      child: SafeArea(
        child: Container(
          child: Column(

            children: <Widget>[

              Padding(
                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.33),
                child: TextField(
                  controller: _provider.postCaptionTextEditingController,
                  maxLines: null,
                  style: TextStyle(
                      color: _themeData.barBackgroundColor
                  ),
                  cursorColor: _themeData.primaryColor,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _themeData.primaryColor)),
                    hintText: "Enter Caption...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  ),
                ),
              ),


              Flexible(
                flex: 100,
                fit: FlexFit.tight,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[

                    Positioned.fill(
                      child: StreamBuilder<String>(
                          stream: _bloc.getAudioImagePathStream,
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                            if (snapshot.hasData){
                              return Image.file(File(snapshot.data));
                            }
                            else{

                              return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      image: DecorationImage(
                                          image: AssetImage(AppBackgroundImages.audio_background_image_orion_nebula),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(Colors.pinkAccent, BlendMode.color)

                                      ),
                                      //borderRadius: BorderRadius.circular(borderRadius)
                                  )
                              );
                            }


                          }
                      ),
                    ),

                      Center(
                      child: StreamBuilder<String>(
                          stream: _bloc.getAudioPathStream,
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                            if (snapshot.hasData){
                              return Container(
                                  height: screenHeight * 0.4,
                                  margin: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.33)
                                  ),
                                  child: AudioWidget(audioFile: File(snapshot.data), postBloc: _bloc,)
                              );
                            }
                            else
                              return Container(
                                child: Center(
                                  child: Text("Audio not Found",
                                    style: TextStyle(color: _themeData.barBackgroundColor, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                                  ),
                                ),
                              );

                          }
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(screenWidth * scaleFactor * 0.33),
                child: AddAudioImageWidget(),
              )


            ],
          ),
        ),
      ),
    );
  }
}









class PostSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return CupertinoPageScaffold(

      backgroundColor: Colors.transparent,

      navigationBar: CupertinoNavigationBar(
        middle: Text('Post Settings', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
        backgroundColor: Colors.white.withOpacity(0.2),
        leading: MaterialButton(
          highlightColor: null,
            child: Text("Back", style: TextStyle(color: _themeData.primaryColor),),
            onPressed: (){

              _provider.pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeInOutBack);

            }
        ),
        trailing: PostSetupCompleteButtonWidget()
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Center(

              child: PostAudienceSettingWidget()
            ),

            //PostMediaIsDownloadableSettingWidget(),

            //PostIsSharableSettingWidget()

          ],
        ),
      ),
    );
  }
}








class PublishPostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostBlocProvider _provider = PostBlocProvider.of(context);
    PostBloc _bloc = PostBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return CupertinoPageScaffold(

      backgroundColor: Colors.transparent,

      navigationBar: CupertinoNavigationBar(
        middle: Text("Publish Post", style: TextStyle(color: Colors.white.withOpacity(0.5)),),
        backgroundColor: Colors.white.withOpacity(0.2),
        leading: MaterialButton(
            highlightColor: null,
            child: Text("Back", style: TextStyle(color: _themeData.primaryColor),),
            onPressed: (){

              _provider.pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOutBack);

            }
        ),

      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  PublishPostButtonWidget(),

                ],
              ),
            )
          )
        ),
      ),
    );
  }
}







