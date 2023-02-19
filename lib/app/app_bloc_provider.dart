import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_bloc.dart';
import 'app_handlers.dart';
import 'package:iris_social_network/services/app_services/dynamic_links_services.dart' as dynamic_links;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'app_dynamic_links__handlers.dart';



class AppBlocProvider extends InheritedWidget{


  final AppBloc bloc;
  final Key key;
  final Widget child;

  CupertinoTheme cupertinoTheme;
  AppHandler handler;

  AppDynamicLinksHandlers appDynamicLinksHandlers;


  AppBlocProvider({@required this.bloc, this.key, this.child}): super(key: key, child: child){

    handler = AppHandler();
    appDynamicLinksHandlers = AppDynamicLinksHandlers();

    // add is  christmas period to stream
    handler.getIsChristmasPeriod().then((bool isChristmasPeriod){
      bloc.addIschristmasPeriodToStream(isChristmasPeriod);
    });

  }

  static Future<String> getDyanamicLinkWithPostIdAndPostUserId({@required String postId, @required String postUserId})async{

    return await dynamic_links.getDynamicLinkWithPostIdAndPostUserId(postId: postId, postUserId: postUserId );
  }


  static AppBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(AppBlocProvider) as AppBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}