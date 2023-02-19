import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/constants/constants.dart' as constants;
import 'dart:io';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:emoji_picker/emoji_picker.dart';

import 'create_message_bloc.dart';
import 'create_message_bloc_provider.dart';

import 'create_message_views_widgets.dart';




class CreateMessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
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
                stream: _bloc.getMessageTypeStream,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                  if (snapshot.hasData){

                    switch(snapshot.data){

                      case constants.MessageType.image:
                        return ImageMessageView();
                      case constants.MessageType.video:
                        return VideoMessageView();
                      case constants.MessageType.audio:
                        return AudioMessageView();
                      default:
                        return Container(
                          child: Center(
                            child: Text("Unknown Message Type", style: TextStyle(fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),),
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

          CreateMessageSettingsView()

        ],
      ),
    );
  }
}




class ImageMessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return CupertinoPageScaffold(

      backgroundColor: Colors.transparent,

      navigationBar: CupertinoNavigationBar(
        middle: Text('Send Image', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
        backgroundColor: Colors.white.withOpacity(0.2),
        trailing: StreamBuilder<List<String>>(
          stream: _bloc.getImagesPathStream,
          builder: (context, snapshot) {
            return MaterialButton(
                child: Text("Next", style: TextStyle(color: snapshot.hasData && snapshot.data.length > 0? _themeData.primaryColor: Colors.black.withOpacity(0.2)),),
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
                        controller: _provider.messageCaptionTextEditingController,
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
                            _bloc.addMessageBackgroundImageToStream(snapshot.data[index]);
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


class VideoMessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return CupertinoPageScaffold(

      backgroundColor: Colors.transparent,

      navigationBar: CupertinoNavigationBar(
        middle: Text('Send Video', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
        backgroundColor: Colors.white.withOpacity(0.2),
        trailing: StreamBuilder<String>(
          stream: _bloc.getVideoPathStream,
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
                        controller: _provider.messageCaptionTextEditingController,
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


class AudioMessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CreateMessageBloc _bloc = CreateMessageBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return  CupertinoPageScaffold(

      backgroundColor: Colors.transparent,

      navigationBar: CupertinoNavigationBar(
        middle: Text('Send Audio', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
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
                    controller: _provider.messageCaptionTextEditingController,
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
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[

                      Positioned.fill(
                        child: StreamBuilder<String>(
                            stream: _bloc.getAudioImagePathStream,
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                              return Image.file(File(snapshot.hasData? snapshot.data: ""));

                            }
                        ),
                      ),

                      Positioned(
                        bottom: 0.0,
                        child: StreamBuilder<String>(
                            stream: _bloc.getAudioPathStream,
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                              if (snapshot.hasData){
                                return AudioWidget(audioFile: File(snapshot.data), postBloc: _bloc,);
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
          )
      ),
    );
  }
}





class CreateMessageSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    CreateMessageBlocProvider _provider = CreateMessageBlocProvider.of(context);
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return CupertinoPageScaffold(

      backgroundColor: Colors.transparent,

      navigationBar: CupertinoNavigationBar(
          middle: Text('Message Settings', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
          backgroundColor: Colors.white.withOpacity(0.2),
          leading: MaterialButton(
              highlightColor: null,
              child: Text("Back", style: TextStyle(color: _themeData.primaryColor),),
              onPressed: (){

                _provider.pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeInOutBack);

              }
          ),
          trailing: CreateMessageSetupCompleteButtonWidget()
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[


            CreateMessageMediaIsDownloadableSettingWidget(),

            //PostIsSharableSettingWidget()

          ],
        ),
      ),
    );
  }
}


