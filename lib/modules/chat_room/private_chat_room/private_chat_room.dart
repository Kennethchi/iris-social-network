import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:backdrop/backdrop.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/app/app_handlers.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/constants/app_constants.dart';
import 'private_chat_room_bloc.dart';
import 'private_chat_room_bloc_provider.dart';
import 'private_chat_room_views.dart';
import 'package:universal_widget/universal_widget.dart';



class PrivateChatRoom extends StatefulWidget{

  String currentUserId;

  PrivateChatRoom({@required this.currentUserId});

  @override
  _PrivateChatRoomState createState() => _PrivateChatRoomState();
}


class _PrivateChatRoomState extends State<PrivateChatRoom> with AutomaticKeepAliveClientMixin{


  PrivateChatRoomBloc _bloc;
  ScrollController _scrollController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = PrivateChatRoomBloc(currentUserId: widget.currentUserId);
    _scrollController = ScrollController();

  }


  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _scrollController.dispose();

    super.dispose();
  }



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    AppHandler.setHomeMainPage(mainPage: HomeMainPages.private_chat_page);


    AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection){
      if (hasInternetConnection){
        AppBlocProvider.of(context).bloc.addHasInternetConnectionToStream(true);
      }
    });
  }






  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return PrivateChatRoomBlocProvider(
      bloc: _bloc,
      scrollController: this._scrollController,
      child: Scaffold(

        body: CupertinoPageScaffold(

          child: PrivateChatRoomView(),

          navigationBar: CupertinoNavigationBar(
            middle: Text("Private Chats",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: Theme.of(context).textTheme.title.fontSize,
                  fontWeight: FontWeight.bold
              ),),
            border: Border.all(style: BorderStyle.none),
          ),

        ),


        /*
        floatingActionButton: FloatingActionButton(
          backgroundColor: CupertinoTheme.of(context).primaryColor,
          foregroundColor: RGBColors.white,
          child: Icon(Icons.add),
          onPressed: (){



            Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context){

              return Scaffold(
                body: UniversalWidget(
                  durationWhenUpdate: 2,
                    x: 20,
                    y: 40,
                    rotation: 45, // degrees
                    top: 10,
                    left: 20,
                    height: 50,
                    padding: EdgeInsets.all(20),
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                    child: Text("Hello World")
                )
                ,
              );



            }));

          },
        ),
        */


      ),

    );
  }

}





