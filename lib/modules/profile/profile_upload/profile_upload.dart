import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/widgets/talent_type_chip/talent_type_chips.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'profile_upload_view.dart';
import 'profile_upload_bloc.dart';
import 'profile_upload_bloc_provider.dart';
import 'dart:ui';
import 'package:iris_social_network/modules/profile/profile_bloc.dart';





class ProfileUpload extends StatefulWidget{

  File videoFile;
  int videoDurationInSeconds;
  ProfileBloc profileBloc;

  ProfileUpload({@required this.videoFile, @required this.videoDurationInSeconds, @required this.profileBloc})
      :assert(videoFile != null, "Upload video file should not be null"),
        assert(videoDurationInSeconds != null, "Video Duration should not be null"),
        assert(profileBloc != null, "Profile Bloc should not be null");



  _ProfileUploadState createState() => _ProfileUploadState();
}

class _ProfileUploadState extends State<ProfileUpload> with AutomaticKeepAliveClientMixin<ProfileUpload>{


  ProfileUploadBloc _uploadBloc;
  TextEditingController _videoCaptionTextEditingController;
  //TextEditingController videoTitleTextEditingController;


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _uploadBloc = ProfileUploadBloc(videoFile: widget.videoFile, videoDurationInSeconds: widget.videoDurationInSeconds, thumbQuality: 75);
    _videoCaptionTextEditingController = TextEditingController();

    
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _uploadBloc.dispose();
    _videoCaptionTextEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProfileUploadBlocProvider(
      uploadBloc: _uploadBloc,
      profileBloc: widget.profileBloc,
      videoCaptionTextEditingControlloer: _videoCaptionTextEditingController,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ProfileUploadView()
      ),
    );
  }
}









