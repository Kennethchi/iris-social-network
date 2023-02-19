import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';

import 'create_message_bloc.dart';
import 'create_message_bloc_provider.dart';

import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;

import 'create_message_views.dart';






class CreateMessage extends StatefulWidget {

  String messageType;
  File messageFile;

  CreateMessage({@required this.messageFile, @required this.messageType});


  @override
  _CreateMessageState createState() => _CreateMessageState();
}

class _CreateMessageState extends State<CreateMessage> {

  CreateMessageBloc _bloc;

  TextEditingController _messageCaptionTextEditingController;
  SwiperController _imagesSwiperController;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = CreateMessageBloc(messageFile: widget.messageFile);
    _bloc.addMessageTypeToStream(widget.messageType);

    _messageCaptionTextEditingController = TextEditingController();
    _imagesSwiperController = SwiperController();
    _pageController = PageController();
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _messageCaptionTextEditingController.dispose();
    _imagesSwiperController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return CreateMessageBlocProvider(
      bloc: _bloc,
      messageFile: widget.messageFile,
      messageType: widget.messageType,
      messageCaptionTextEditingController: this._messageCaptionTextEditingController,
      imagesSwiperController: this._imagesSwiperController,
      pageController: this._pageController,
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
                    stream: _bloc.getMessageBackgroundImageStream,
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

                            child: CreateMessageView(),
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
