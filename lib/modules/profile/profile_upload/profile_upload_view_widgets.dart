import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/widgets/talent_type_chip/talent_type_chips.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/modules/profile/profile_bloc_provider.dart';
import 'package:iris_social_network/modules/profile/profile_bloc.dart';
import 'profile_upload_bloc_provider.dart';
import 'profile_upload_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/services/ffmpeg_services/ffmpeg_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';






class VideoViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ProfileUploadBloc _bloc = ProfileUploadBlocProvider.of(context).uploadBloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      width: screenWidth,
      height: screenHeight,
      color: RGBColors.black.withOpacity(0.8),
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[

          Positioned(
            top: 10.0,
              child: Text("Video Preview", style: TextStyle(
                color: RGBColors.white.withOpacity(0.8),
                  fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
                  fontWeight: FontWeight.bold),
              )
          ),

          Positioned.fill(
            child: Container(
              width: screenWidth,
              height: screenHeight,
              child: StreamBuilder(
                stream: _bloc.getVideoPathStream,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                  if (snapshot.hasData){

                    return VideoWidget(videoFile: File(snapshot.data), uploadBloc: _bloc,);
                  }
                  else{
                    return CupertinoActivityIndicator();
                  }

                },
              ),

            ),
          ),



        ],
      ),
    );
  }
}



class VideoWidget extends StatefulWidget{

  File videoFile;
  ProfileUploadBloc uploadBloc;

  VideoPlayerController _videoPlayerController;

  VideoWidget({@required this.videoFile, @required this.uploadBloc}){

    _videoPlayerController = VideoPlayerController.file(videoFile);

  }



  _VideoWidgetState createState() => new _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget>{


  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    widget._videoPlayerController.initialize().then((_){

      widget.uploadBloc.addHasInitialisedVideoToStream(hasInitialisedVideo: true);
    });






  }




  @override
  void dispose() {
    // TODO: implement dispose

    widget._videoPlayerController.dispose();
    _chewieController.dispose();

    super.dispose();
  }



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();


    // This is here and not in the init state so has to give time for video to initial when splitted videos are clicked to play
    _chewieController = ChewieController(
        videoPlayerController: widget._videoPlayerController,
        aspectRatio: widget._videoPlayerController.value.aspectRatio,
        showControls: true,
        autoPlay: true,
        looping: true
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return Container(
      child:  Chewie(
        controller: _chewieController,
      ),
    );


  }

}





class VideoCaptionTextFieldWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SafeArea(
        child: Column(
          children: <Widget>[

            Spacer(flex: 10,),
            Text("Caption", style: TextStyle(fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),),

            Spacer(flex: 10,),
            Container(
              width: screenWidth * scaleFactor * 7,
              child: TextField(
                controller: ProfileUploadBlocProvider.of(context).videoCaptionTextEditingControlloer,
                decoration: InputDecoration(
                    hintText: "Enter Caption ..",

                ),
                onChanged: (String text) async{
                  await ProfileUploadBlocProvider.of(context).profileUploadViewHandlers.onCaptionTextChanged(
                      uploadContext: context,
                      text: text
                  );
                },
              ),
            ),
            Spacer(flex: 80,)

          ],
        ),
      ),
    );
  }

}





class TalentTypeSelectionWidget extends StatelessWidget{



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileUploadBloc _bloc = ProfileUploadBlocProvider.of(context).uploadBloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SafeArea(
        child: Column(
          children: <Widget>[

            Spacer(flex: 10,),
            Text("Talent Type", style: TextStyle(fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),),
            Spacer(flex: 10,),

            TalentTypeChips(
              label: [
                VideoType.music, VideoType.dancing, VideoType.sports, VideoType.comedy,
                VideoType.modeling, VideoType.entertaitement, VideoType.magic, VideoType.others
              ],
              onItemSelected: (String label){

                _bloc.addTalentTypeToStream(talentType: label);
                print(label);
              },
            ),
            Spacer(flex: 80,)


          ],

        ),
      ),
    );
  }
}






class VideoThumbnailWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SafeArea(
        child: Column(
          children: <Widget>[

            Spacer(flex: 10,),
            Text("Choose Thumbnail", style: TextStyle(fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, fontWeight: FontWeight.bold),),
            Spacer(flex: 10,),

            StreamBuilder<String>(
                stream: ProfileUploadBlocProvider.of(context).uploadBloc.getVideoThumbStream,
                builder: (context, snapshot) {

                  return Container(
                      width: screenWidth,
                      height: screenWidth * 0.75,
                      decoration: BoxDecoration(
                        color: RGBColors.black.withOpacity(0.15),
                        image: DecorationImage(
                            image: FileImage(
                                File(snapshot.hasData? snapshot.data: "")
                            ),
                            fit: BoxFit.cover
                        ),
                      ),
                      child: InkWell(
                        onTap: (){

                          ProfileUploadBlocProvider.of(context).profileUploadViewHandlers.showUploadImageOptionDialog(uploadContext: context);
                        },
                        child: Center(
                          child: snapshot.hasData? Icon(Icons.camera_alt, size: scaleFactor * screenWidth,)
                              : SpinKitPulse(color: _themeData.primaryColor,),
                        ),
                      )
                  );
                }
            ),
            Spacer(flex: 80,)

          ],
        ),
      ),
    );
  }

}







class VideoUploadButtonWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    ProfileUploadBloc _bloc = ProfileUploadBlocProvider.of(context).uploadBloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SafeArea(
        child: StreamBuilder<bool>(
          stream: _bloc.getValidateUploadStream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: CupertinoButton.filled(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    borderRadius: BorderRadius.circular(100.0),
                    disabledColor: RGBColors.black.withOpacity(0.15),
                    child: Text("Upload"),
                    onPressed: snapshot.hasData && snapshot.data? (){

                      /*
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (BuildContext context){
                          return BubbleSmash();
                        })
                      );
                      */


                      BasicUI.showProgressDialog(
                          pageContext: context,
                          child: CupertinoActivityIndicator(radius: screenWidth * scaleFactor * 0.5)
                      );


                      ProfileUploadBlocProvider.of(context).profileUploadViewHandlers.uploadVideo(context: context).then((bool complete){

                        if (complete == null || complete == false){
                          Navigator.of(context).pop();
                          BasicUI.showSnackBar(context: context, message: "An unexpected error occured during upload", textColor: RGBColors.red);
                        }
                        else{
                          Navigator.pop(context);
                          Navigator.pop(context);
                          BasicUI.showSnackBar(context: context, message: "Video was Successfully Uploaded", textColor: _themeData.primaryColor);
                        }

                      });


                    }: null,
                  ),
                ),
              ],
            );

          },
        ),
      ),
    );
  }
}





