import 'dart:io';

import 'package:animator/animator.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/server_services/constants.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:iris_social_network/widgets/app_material/app_material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'video_viewer_bloc.dart';
import 'video_viewer_bloc_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_saver/gallery_saver.dart';



class VideoWidget extends StatefulWidget {

  String videoUrl;
  VideoViewerBloc videoViewerBloc;

  VideoWidget({@required this.videoUrl, @required this.videoViewerBloc});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _videoPlayerController.initialize().then((_){

      widget.videoViewerBloc.addIsVideoInitialisedToStream(true);

      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          showControls: true,
          autoPlay: false,
          looping: false
      );

    });



  }



  @override
  void dispose() {
    // TODO: implement dispose

    _videoPlayerController.dispose();
    _chewieController.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: widget.videoViewerBloc.getIsVideoInitialisedStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {


          if (snapshot.hasData && snapshot.data){
            return Chewie(
              controller: _chewieController,
            );
          }
          else{
            return Center(child: CupertinoActivityIndicator(radius: 15.0,));
          }
        }
    );
  }
}








class DownloadButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    VideoViewerBlocProvider _provider = VideoViewerBlocProvider.of(context);
    VideoViewerBloc _bloc = VideoViewerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    if(_provider.videoDownloadable != null && _provider.videoDownloadable){
      return Container(

        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(

              borderRadius: BorderRadius.circular(15.0),
              onTap: (){

                AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection)async{


                  if (hasInternetConnection != null && hasInternetConnection){

                    _bloc.addIsMediaDownloadingToStream(true);

                    String savePath = (await getTemporaryDirectory()).path +  DateTime.now().toString() + FileExtensions.mp4;

                    _bloc.downLoadFile(urlPath: _provider.videoUrl,
                        savePath: savePath,
                        progressSink: _bloc.getProgressTransferDataSink,
                        totalSink: _bloc.getTotalTransferDataSink
                    ).then((File downloadedVideoFile){

                      _bloc.addIsMediaDownloadingToStream(false);

                      if (downloadedVideoFile != null && downloadedVideoFile.existsSync()){


                        GallerySaver.saveVideo(downloadedVideoFile.path, albumName: AppStoragePaths.getVideoDirectoryPath,).then((bool success){

                          if (success != null && success){
                            BasicUI.showSnackBar(
                                context: context,
                                message: "Download Successful. Video saved to Gallery",
                                textColor:  _themeData.primaryColor,
                                duration: Duration(seconds: 5)
                            );
                          }else{
                            BasicUI.showSnackBar(
                                context: context,
                                //message: "Download Successful \nVideo saved to \"${savePath}\" ",
                                //textColor:  _themeData.primaryColor,
                                message: "An error occured while Saving Video to Gallery",
                                textColor:  CupertinoColors.destructiveRed,
                                duration: Duration(seconds: 5)
                            );
                          }
                        });


                      }
                      else{
                        BasicUI.showSnackBar(
                            context: context,
                            message: "An error occured while downloading Video",
                            textColor:  CupertinoColors.destructiveRed,
                        );
                      }

                    });

                  }
                  else{
                    BasicUI.showSnackBar(
                        context: context,
                        message: "No Internet Connection",
                        textColor:  CupertinoColors.destructiveRed,
                        duration: Duration(seconds: 1)
                    );
                  }

                });


              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Download", style: TextStyle(color: Colors.white.withOpacity(0.8)),),
              )
          ),
        ),
      );
    }


    return Container();
  }
}











class DownloadWidgetIndicator extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    VideoViewerBloc _bloc = VideoViewerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return StreamBuilder<bool>(
        stream: _bloc.getIsMediaDownloadingStream,
        builder: (context, snapshot) {


          if (snapshot.hasData && snapshot.data){
            return Animator(
              tween: Tween<double>(begin: 1.0, end: 0.0),
              repeats: 1,
              curve: Curves.easeInOutBack,
              duration: Duration(seconds: 1),
              builder: (anim){
                return Transform.translate(
                    offset: Offset(screenWidth * anim.value , 0.0),
                    child: Opacity(
                      opacity: 0.7,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                        child: Card(
                          elevation: 30.0,
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              //color: _themeData.primaryColor,
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.zero,
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.zero,
                              ),
                            ),
                            child: Center(
                              child: FittedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      ProgressPercentIndicator(
                                        progressPercentRatioStream: _bloc.getPercentRatioProgressStream,
                                        //color: RGBColors.fuchsia,
                                        color: _themeData.primaryColor,
                                      ),
                                      SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                                      Text("Downloading...", style: TextStyle(
                                          //color: RGBColors.fuchsia,
                                        color: _themeData.primaryColor,
                                          fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
                                        fontWeight: FontWeight.bold
                                      ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )
                              ),

                              //child: SpinKitCircle(color: Colors.white,),
                            ),
                          ),
                        ),
                      ),
                    )
                );
              },
            );

          }
          else{
            return Container();
          }

        }
    );

  }

}




