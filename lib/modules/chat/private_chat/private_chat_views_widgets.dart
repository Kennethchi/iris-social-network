import 'dart:async';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/models/message_models/message_image_model.dart';
import 'package:iris_social_network/services/models/message_models/message_model.dart';
import 'package:iris_social_network/widgets/app_material/app_material.dart';
import 'private_chat_bloc.dart';
import 'private_chat_bloc_provider.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'private_chat_strings.dart';
import 'package:iris_social_network/services/models/message_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'private_chat_views_handlers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:iris_social_network/widgets/image_viewer/image_viewer.dart';
import 'dart:ui';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:emoji_picker/emoji_picker.dart';








class MessageTextWidget extends StatelessWidget{

  MessageModel messageModel;

  MessageTextWidget({@required this.messageModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * scaleFactor),
      child: Text(messageModel.message_text != null? "${messageModel.message_text}": "",
        style: TextStyle(
            color: messageModel.sender_id == _bloc.getCurrentUserModel.userId? RGBColors.white: RGBColors.black,
            fontWeight: messageModel.sender_id == _bloc.getCurrentUserModel.userId? FontWeight.w700: FontWeight.normal
        ),
      ),
    );

  }

}




class MessageImageWidget extends StatelessWidget{

  MessageModel messageModel;

  MessageImageWidget({@required this.messageModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return MessageMediaTemplateWidget(
        messageModel: messageModel,
        child: PrivateChatBlocProvider.of(context).handlers.getMessageImagePreviewWidget(

            context: context,
            messageModel: messageModel
        )
    );
  }

}



class MessageVideoWidget extends StatelessWidget{

  MessageModel messageModel;

  MessageVideoWidget({@required this.messageModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return MessageMediaTemplateWidget(
        messageModel: messageModel,
        child: PrivateChatBlocProvider.of(context).handlers.getMessageVideoPreviewWidget(

            context: context,
            messageModel: messageModel
        )
    );
  }

}




class MessageAudioWidget extends StatelessWidget{

  MessageModel messageModel;

  MessageAudioWidget({@required this.messageModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return Container(
      child: MessageMediaTemplateWidget(
          messageModel: messageModel,
          child: PrivateChatBlocProvider.of(context).handlers.getMessageAudioPreviewWidget(

              context: context,
              messageModel: messageModel
          )
      ),
    );
  }

}





class MessageMediaTemplateWidget extends StatelessWidget{

  MessageModel messageModel;
  Widget child;

  MessageMediaTemplateWidget({@required this.messageModel, @required this.child});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    double widgetWidth = screenWidth * scaleFactor * 5;
    double widgetHeight = screenWidth * scaleFactor * 4;



    return Column(
      crossAxisAlignment: messageModel.sender_id == _bloc.getCurrentUserModel.userId? CrossAxisAlignment.end: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Flexible(
          child: Container(
              width: widgetWidth,
              height: widgetHeight,
              child: this.child
          ),
        ),

        Container(
            width: widgetWidth,
            child: messageModel.message_text != null && messageModel.message_text.isNotEmpty?  Column(
              crossAxisAlignment: messageModel.sender_id == _bloc.getCurrentUserModel.userId? CrossAxisAlignment.end: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: screenWidth * scaleFactor * scaleFactor,),
                MessageTextWidget(messageModel: messageModel,),
              ],
            ):
            Container()
        )
      ],
    );
  }


}






class UploadWidgetIndicator extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return StreamBuilder<bool>(
        stream: _bloc.getIsMediaUploadingStream,
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
                              color: _themeData.primaryColor,
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
                                        color: RGBColors.fuchsia,
                                      ),
                                      SizedBox(height: screenHeight * scaleFactor * scaleFactor,),

                                      Text("Uploading...", style: TextStyle(
                                        color: RGBColors.fuchsia,
                                        fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
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

    return ProgressPercentIndicator(progressPercentRatioStream: _bloc.getPercentRatioProgressStream,);
  }

}






class ReferredMessageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PrivateChatBlocProvider _provider = PrivateChatBlocProvider.of(context);
    PrivateChatBloc _bloc = PrivateChatBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<MessageModel>(
      stream: _bloc.getReferredMessageModelStream,
      builder: (context, snapshot) {

        if (snapshot.data == null){
          return Container();
        }
        else{
          return Dismissible(
              key: UniqueKey(),
              confirmDismiss: (DismissDirection direction)async{

                if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd){
                  _bloc.addReferredMessageModelToStream(null);
                }

                return false;
              },
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: CupertinoColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: _themeData.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))
                ),
                child: Stack(
                  children: <Widget>[

                    Positioned(

                      child: Container(
                        child: _provider.handlers.getReferredMessageWidget(pageContext: context, referredMessageModel: snapshot.data),
                      ),
                    ),

                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: GestureDetector(
                          onTap: (){
                            _bloc.addReferredMessageModelToStream(null);
                          },
                          child: Icon(Icons.close, size: 18.0,),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        }

      }
    );
  }
}




class EmojieWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: FittedBox(
        child: EmojiPicker(
          rows: 3,
          columns: 7,
          recommendKeywords: ["racing", "horse"],
          numRecommended: 10,
          onEmojiSelected: (emoji, category) {
            print(emoji);
          },
        ),
      ),
    );
  }
}



