import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:iris_social_network/widgets/app_material/app_material.dart';
import 'package:iris_social_network/widgets/image_viewer/image_viewer.dart';
import 'private_chat_room_bloc.dart';
import 'private_chat_room_bloc_provider.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:iris_social_network/services/models/chat_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iris_social_network/services/optimised_models/optimised_chat_model.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:time_ago_provider/time_ago_provider.dart';

import 'private_chat_room_views_widgets.dart';


/*


class ContactsView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PrivateChatRoomBloc _bloc = PrivateChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<List<ContactModel>>(
      stream: _bloc.getContactsDataStream,
      builder: (BuildContext context, AsyncSnapshot<List<ContactModel>> snapshot){

        switch(snapshot.connectionState){

          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            return Center(
              child: SpinKitFadingCircle(color: RGBColors.white,),
            );
          case ConnectionState.active: case ConnectionState.done:

          if (snapshot.hasData && snapshot.data.length > 0){

            print(snapshot.data.length);

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap: (){


                    },
                    child: ListTile(
                      leading: Hero(
                        tag: snapshot.data[index].userId,
                        child: CircleAvatar(
                          backgroundColor: RGBColors.light_grey_level_1,
                          backgroundImage: CachedNetworkImageProvider(snapshot.data[index].thumb),
                          child: snapshot.data[index].thumb == null? Text("${snapshot.data[index].displayName[0]}"): null,
                        ),
                      ),
                      title: Text(snapshot.data[index].displayName, overflow: TextOverflow.ellipsis,),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  );
                },
              );

            }
            else{
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * scaleFactor),
                  child: ScaleAnimatedTextKit(
                    text: ["None of your Contacts are on Iris"],
                    textStyle: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline.fontSize,
                      color: RGBColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

        }

      },
    );
  }

}

*/



class PrivateChatRoomView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    PrivateChatRoomBloc _bloc = PrivateChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return SafeArea(
      child: StreamBuilder<List<OptimisedChatModel>>(
        stream: _bloc.getChatsListStream,
        builder: (BuildContext context, AsyncSnapshot<List<OptimisedChatModel>> snapshots){

          switch(snapshots.connectionState){

            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return Center(
                child: SpinKitFadingCircle(color: RGBColors.light_grey_level_2,),
              );
            case ConnectionState.active: case ConnectionState.done:





              if (snapshots.hasData && snapshots.data.length > 0){


                return ListView.builder(
                  padding: EdgeInsets.only(bottom: screenHeight * scaleFactor),
                  controller: PrivateChatRoomBlocProvider.of(context).scrollController,
                  itemCount: snapshots.data.length,
                  itemBuilder: (BuildContext context, int index){


                    return ChatUserViewModel(optimisedChatModel: snapshots.data[index]);
                    
                  },
                );

              }
              else{
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * scaleFactor),
                    child: ScaleAnimatedTextKit(
                      text: ["No Chats"],
                      textStyle: TextStyle(
                        fontSize: Theme.of(context).textTheme.headline.fontSize,
                        color: _themeData.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }



          }





        },
      ),
    );
  }

}







class ChatUserViewModel extends StatelessWidget {
  
  
  OptimisedChatModel optimisedChatModel;
  
  ChatUserViewModel({@required this.optimisedChatModel});
  
  
  @override
  Widget build(BuildContext context) {

    PrivateChatRoomBloc _bloc = PrivateChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return InkWell(
      onTap: (){


        PrivateChatRoomBlocProvider.of(context).privateChatRoomViewHandlers.pushToPrivateChat(
            context: context,
            currentUserModel: _bloc.getCurrentUserData,
            chatUserModel: optimisedChatModel.chatUserModel

        );

        _bloc.setChatSeen(currentUserId: _bloc.getCurrentUserData.userId , chatUserId: optimisedChatModel.chatUserModel.userId);


        Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => PrivateChat(
            currentUserModel: _bloc.getCurrentUserData,
            chatUserModel: optimisedChatModel.chatUserModel
        )));

      },



      child: ListTile(
        leading: ChatUserOnlineAvatarView(optimisedChatModel: optimisedChatModel),

        trailing: FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                //DateTimeUtils.getTimeFromMillisecondsSinceEpochType_jm(optimisedChatModel.t),
                optimisedChatModel.t != null? TimeAgo.getTimeAgo(
                    optimisedChatModel.t
                ): "",
                style: TextStyle(fontSize: Theme.of(context).textTheme.overline.fontSize),
              ),
              ChatMessageSeenWidget(optimisedChatModel: optimisedChatModel,)
            ],
          ),
        ),

        title: Row(

          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Flexible(
                child: Text(
                  optimisedChatModel.name != null? optimisedChatModel.name: "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.bold),
                )
            ),

            if (optimisedChatModel.v_user != null && optimisedChatModel.v_user)
              SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

            Container(
              child: optimisedChatModel.v_user != null && optimisedChatModel.v_user
                  ? Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.3,)
                  : Container(),
            )
          ],
        ),


        subtitle: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                    Flexible(
                        flex: 100,
                        child: ChatUserTypingStateView(optimisedChatModel: optimisedChatModel)
                    ),

                    /*
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * scaleFactor * 0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            //DateTimeUtils.getTimeFromMillisecondsSinceEpochType_jm(optimisedChatModel.t),
                            optimisedChatModel.t != null? TimeAgo.getTimeAgo(
                                optimisedChatModel.t
                            ): "",
                            style: TextStyle(fontSize: Theme.of(context).textTheme.overline.fontSize),
                          ),
                          ChatMessageSeenWidget(optimisedChatModel: optimisedChatModel,)
                        ],
                      ),
                    )
                    */


                  ],
                ),

              ],
            )
        ),

      ),
    );
  }
}

















class ChatUserOnlineAvatarView extends StatelessWidget{

  OptimisedChatModel optimisedChatModel;

  ChatUserOnlineAvatarView({@required this.optimisedChatModel});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PrivateChatRoomBloc _bloc = PrivateChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return GestureDetector(
        onTap: (){


          showCupertinoModalPopup(context: context, builder: (BuildContext context) => ImageViewer(
              currentIndex: 0,
              imageDownloadable: false,
              imageList: [optimisedChatModel.chatUserModel.profileImage]
          ));


        },
        child: StreamBuilder<bool>(
          stream: AppBlocProvider.of(context).bloc.getHasInternetConnectionStream,
          builder: (context, hasInternetConnectioSnapshot) {


            if (hasInternetConnectioSnapshot.hasData && hasInternetConnectioSnapshot.data){


              return Container(
                child: StreamBuilder<Event>(
                  stream: _bloc.getChatUserOnlineStatus(chatUserId: optimisedChatModel.chat_user_id),
                  builder: (BuildContext context, AsyncSnapshot<Event> isChatUserOnlineSnapshot){

                    if (isChatUserOnlineSnapshot.hasData && isChatUserOnlineSnapshot.data.snapshot.value == 1){

                      return Hero(
                        tag: optimisedChatModel.chat_user_id,
                        child: GlowCircleAvatar(

                          glowColor: _themeData.primaryColor,
                          circleAvatar: CircleAvatar(
                            backgroundColor: RGBColors.light_grey_level_1,
                            backgroundImage: CachedNetworkImageProvider(optimisedChatModel.thumb),
                            child: optimisedChatModel.thumb == null? Text(
                                optimisedChatModel.name != null? optimisedChatModel.name[0]: ""
                            ): null,
                          ),
                        ),
                      );
                    }
                    else{

                      return Hero(
                        tag: optimisedChatModel.chat_user_id,
                        child: Container(
                          child: CircleAvatar(
                            backgroundColor: RGBColors.light_grey_level_1,
                            backgroundImage: CachedNetworkImageProvider(optimisedChatModel.thumb),
                            child: optimisedChatModel.thumb == null? Text(
                                optimisedChatModel.name != null? optimisedChatModel.name[0]: ""
                            ): null,
                          ),
                        ),
                      );
                    }

                  },
                ),
              );

            }
            else{

              return Hero(
                tag: optimisedChatModel.chat_user_id,
                child: Container(
                  child: CircleAvatar(
                    backgroundColor: RGBColors.light_grey_level_1,
                    backgroundImage: CachedNetworkImageProvider(optimisedChatModel.thumb),
                    child: optimisedChatModel.thumb == null? Text(
                        optimisedChatModel.name != null? optimisedChatModel.name[0]: ""
                    ): null,
                  ),
                ),
              );

            }

          },
        )
    );
  }

}






class ChatUserTypingStateView extends StatelessWidget{

  OptimisedChatModel optimisedChatModel;

  ChatUserTypingStateView({@required this.optimisedChatModel});



  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    PrivateChatRoomBloc _bloc = PrivateChatRoomBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<Event>(
      stream: _bloc.getChatUserTypingStatus(currentUserId: _bloc.getCurrentUserId, chatUserId: optimisedChatModel.chat_user_id),
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot){


        if (snapshot.hasData && snapshot.data.snapshot.value == true){

          return Animator(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            //cycles: 1,
            repeats: 1,
            curve: Curves.elasticOut,
            duration: Duration(seconds: 1),
            builder: (anim){
              return Transform.scale(
                  scale: anim.value,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[

                      Text(
                        "Typing",
                        style: TextStyle(
                            color: RGBColors.fuchsia,
                            //fontSize: Theme.of(context).textTheme..fontSize,
                            fontWeight: FontWeight.bold
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

                      SpinKitThreeBounce(color: RGBColors.fuchsia, size: 10.0,)
                    ],
                  )
              );
            },
          );


        }
        else{
          return PrivateChatRoomBlocProvider.of(context).privateChatRoomViewHandlers.getChatMessageView(optimisedChatModel: optimisedChatModel);
        }

      },
    );
  }

}


