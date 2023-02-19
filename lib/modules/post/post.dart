import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'post_bloc.dart';
import 'post_bloc_provider.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'post_views.dart';
import 'dart:ui';
import 'dart:io';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iris_social_network/modules/home/home_bloc_provider.dart';




class Post extends StatefulWidget {

  static String routeName = AppRoutes.post_screen;

  File postFile;
  String postType;

  dynamic dynamicBloc;

  Post({@required this.postFile, @required this.postType, @required this.dynamicBloc});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {

  PostBloc _bloc;
  TextEditingController _postCaptionTextEditingController;
  PageController _pageController;
  SwiperController _imagesSwiperController;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = PostBloc(postFile: widget.postFile);
    _bloc.addPostTypeToStream(widget.postType);


    _postCaptionTextEditingController = TextEditingController();
    _pageController = PageController();
    _imagesSwiperController = SwiperController();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _postCaptionTextEditingController.dispose();
    _pageController.dispose();
    _imagesSwiperController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return PostBlocProvider(
      bloc: _bloc,
      dynamicBloc: widget.dynamicBloc,
      postFile: widget.postFile,
      postType: widget.postType,
      postCaptionTextEditingController: this._postCaptionTextEditingController,
      pageController: this._pageController,
      imagesSwiperController: this._imagesSwiperController,
      child: Scaffold(
        body: StreamBuilder<String>(
          stream: AppBlocProvider.of(context).bloc.getBackgroundImageStream,
          builder: (BuildContext context, AsyncSnapshot<String> appBackgroundImageSnapshot) {

            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(appBackgroundImageSnapshot.hasData? appBackgroundImageSnapshot.data: ""),
                  fit: BoxFit.cover
                )
              ),
              child: StreamBuilder<String>(
                stream: _bloc.getPostBackgroundImageStream,
                builder: (context, postBackgroundImageSnapshot) {
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(postBackgroundImageSnapshot.hasData? postBackgroundImageSnapshot.data: "")),
                            fit: BoxFit.cover
                        )
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: app_constants.WidgetsOptions.blurSigmaX,
                        sigmaY: app_constants.WidgetsOptions.blurSigmaY
                      ),
                      child: CupertinoPageScaffold(

                        backgroundColor: Colors.black.withOpacity(0.2),

                        child: PostView(),
                      ),
                    ),
                  );
                }
              ),
            );
          }
        ),
      ),
    );
  }
}
