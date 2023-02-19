import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/modules/chat/private_chat/private_chat_views_widgets.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'package:iris_social_network/services/models/contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'private_chat_bloc.dart';
import 'private_chat_bloc_provider.dart';
import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'private_chat_views.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'package:animated_background/animated_background.dart';
import 'private_chat_views_handlers.dart';
import 'package:iris_social_network/blocs/overlay_bloc.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:after_layout/after_layout.dart';



class PrivateChat extends StatefulWidget{

  static final String routeName = AppRoutes.private_chat_screen;

  UserModel currentUserModel;
  UserModel chatUserModel;

  PrivateChat({@required this.currentUserModel, @required this.chatUserModel});

  _PrivateChatState createState() => _PrivateChatState();

}



class _PrivateChatState extends State<PrivateChat> with TickerProviderStateMixin, WidgetsBindingObserver, AfterLayoutMixin<PrivateChat> {

  PrivateChatBloc _bloc;
  OverlayBloc _overlayBloc;


  TextEditingController _textEditingController;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _bloc = PrivateChatBloc(chatUserModel: widget.chatUserModel, currentUserModel: widget.currentUserModel);
    _overlayBloc = OverlayBloc();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addObserver(this);
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _overlayBloc.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    PrivateChatViewsHandlers.onChangeAppLifecycleState(state: state, bloc: _bloc);
  }


  @override
  void afterFirstLayout(BuildContext context) {


    SharedPreferences.getInstance().then((sharedPrefs)async{

      bool quitShowingInfoStoredValue = sharedPrefs.getBool(SharedPrefsKeys.show_chat_info);

      if (quitShowingInfoStoredValue == null){
        bool quitShowingInfo = await PrivateChatViewsHandlers.showChatInfo(context: context);;
        sharedPrefs.setBool(SharedPrefsKeys.show_chat_info, quitShowingInfo);
      }
    });
  }



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection){
      if (hasInternetConnection){
        AppBlocProvider.of(context).bloc.addHasInternetConnectionToStream(true);
      }
    });



    _bloc.getCurrentUser().then((FirebaseUser firebaseUser){

      if (firebaseUser != null){

      }

    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PrivateChatBlocProvider(
      bloc: _bloc,
      overlayBloc: _overlayBloc,
      scrollController: _scrollController,
      textEditingController: _textEditingController,

      child: WillPopScope(
        //onWillPop: () async => false
        onWillPop: () async{
          //await _animationController.reverse();

          Navigator.pop(context);
        },
        child: Scaffold(


          appBar: getPrivateChatAppBar(context: context, chatUserModel: widget.chatUserModel),

          body: CupertinoPageScaffold(

            backgroundColor: RGBColors.light_grey_level_1,

            child: Container(
              width: MediaQuery.of(context).size.width,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                //fit: StackFit.loose,
                //alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[


                  Flexible(
                    flex: 100,
                      child: Stack(
                        //fit: StackFit.passthrough,
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          MessagesListView(),

                          Positioned(
                            right: 0.0,
                              child: UploadWidgetIndicator()
                          ),

                          Positioned(
                            top: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                  child: Card(
                                    elevation: 0.0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.125)
                                    ),
                                    child: ChatUserTypingStateView(),
                                  )
                              ),
                            ),
                          ),
                        ],
                      )
                  ),


                  ChatMessageTextField()

                ],
              ),
            ),



            /*
            navigationBar: CupertinoNavigationBar(

              leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FittedBox(
                      child: ChatUserOnlineAvatarView(chatUserModel: widget.chatUserModel)
                  )
              ),

              middle: AppbarTitleView(),

              trailing: IconButton(icon: Icon(Icons.more_vert, color: RGBColors.light_grey_level_3,), onPressed: (){}),
            ),

            */
          ),


        ),
      ),
    );
  }


}