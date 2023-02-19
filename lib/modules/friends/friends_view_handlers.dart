import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat.dart';
import 'package:iris_social_network/modules/profile/profile.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/models/friend_model.dart';
import 'package:iris_social_network/services/models/user_model.dart';

import 'friends_bloc.dart';
import 'friends_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class FriendsViewHandlers{





  Future<void> showfriendsOptionModalDialog({@required BuildContext friendsContext, @required FriendModel friendModel})async{

    FriendsBlocProvider _provider = FriendsBlocProvider.of(friendsContext);
    FriendsBloc _bloc = FriendsBlocProvider.of(friendsContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(friendsContext);
    double screenWidth = MediaQuery.of(friendsContext).size.width;
    double screenHeight = MediaQuery.of(friendsContext).size.height;
    double scaleFactor = 0.125;
    

    await showCupertinoModalPopup(
        context: friendsContext,
        builder: (BuildContext context){
          return Center(
            child: Container(
              width: screenWidth * 0.9,
              child: CupertinoActionSheet(
                message: Text("Option", style: TextStyle(fontWeight: FontWeight.bold, fontSize: _themeData.textTheme.navTitleTextStyle.fontSize, color: _themeData.primaryColor),),
                actions: <Widget>[

                  CupertinoActionSheetAction(

                    child: Text("Chat with Friend", style: TextStyle(color: Colors.black.withOpacity(0.8),  fontSize: Theme.of(context).textTheme.subtitle.fontSize),),
                    onPressed: ()async{

                      Navigator.of(context).pop();
                      Navigator.of(friendsContext).push(CupertinoPageRoute(builder: (BuildContext context) => PrivateChat(
                        currentUserModel: _bloc.getCurrentUserModel,
                        chatUserModel: friendModel.userModel,
                      )));
                    },
                  ),

                  CupertinoActionSheetAction(
                    child:  Text("View Friend Profile", style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: Theme.of(context).textTheme.subtitle.fontSize)),
                    onPressed: ()async{

                      Navigator.of(context).pop();
                      Navigator.of(friendsContext).push(CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserId: friendModel.userModel.userId,)));
                    },
                  ),


                  CupertinoActionSheetAction(


                    child:  Text("View Friendship Birth Day", style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: Theme.of(context).textTheme.subtitle.fontSize)),
                    onPressed: ()async{


                      Navigator.of(context).pop();


                      showDialog(
                          context: context,
                          builder: (BuildContext context){

                            return Center(
                              child: Animator(

                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                //repeats: 1,
                                curve: Curves.easeInOutBack,
                                duration: Duration(seconds: 1),
                                builder: (anim){
                                  return Transform.scale(
                                    scale: anim.value,
                                    child: Container(
                                      width: screenWidth * 0.8,
                                      child: Card(
                                        //child: Icon(Icons.info_outline)
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.33)
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * scaleFactor * 0.5,
                                            vertical: screenWidth * scaleFactor * 0.75
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[

                                                  CircleAvatar(
                                                    backgroundImage: CachedNetworkImageProvider(
                                                        _bloc.getCurrentUserModel == null? "": _bloc.getCurrentUserModel.profileThumb
                                                    ),
                                                    backgroundColor: RGBColors.light_grey_level_1,
                                                    radius: screenWidth * scaleFactor * 0.75,
                                                  ),

                                                  Icon(FontAwesomeIcons.solidHandshake),

                                                  CircleAvatar(
                                                    backgroundImage: CachedNetworkImageProvider(
                                                        friendModel.userModel.profileThumb == null? "": friendModel.userModel.profileThumb
                                                    ),
                                                    backgroundColor: RGBColors.light_grey_level_1,
                                                    radius: screenWidth * scaleFactor * 0.75,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: screenHeight * scaleFactor * 0.25,),

                                              Text(DateFormat.yMMMMEEEEd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(friendModel.timestamp)),
                                                style: TextStyle(color: Colors.black.withOpacity(0.5),
                                                    fontSize: _themeData.textTheme.navTitleTextStyle.fontSize),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                      );






                    },
                  ),


                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Center(
                      child: Text("Cancel", style: TextStyle(color: Colors.black.withOpacity(0.8),  fontSize: Theme.of(context).textTheme.subtitle.fontSize))
                  ),
                  isDestructiveAction: true,
                  onPressed: ()async{

                    Navigator.of(context).pop();
                  },
                ),

              ),
            ),
          );
        }
    );

  }






}