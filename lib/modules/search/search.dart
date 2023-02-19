import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/modules/search/search_views.dart';
import 'search_bloc.dart';
import 'search_bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;

import 'package:iris_social_network/routes/routes.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';




class Search extends StatefulWidget {

  static String routeName = AppRoutes.search_screen;


  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  SearchBloc _bloc;

  TextEditingController _searchTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = SearchBloc();

    _searchTextEditingController = TextEditingController();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBlocProvider(
        bloc: _bloc,
        searchTextEditingController: this._searchTextEditingController,
        child: Scaffold(
          body: StreamBuilder<String>(
            stream: AppBlocProvider.of(context).bloc.getBackgroundImageStream,
            builder: (context, snapshot) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(

                    image: DecorationImage(
                        image: CachedNetworkImageProvider(snapshot.hasData? snapshot.data: ""),
                        fit: BoxFit.cover
                    )
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: app_constants.WidgetsOptions.blurSigmaX,
                      sigmaY: app_constants.WidgetsOptions.blurSigmaY
                  ),
                  child: CupertinoPageScaffold(

                    backgroundColor: Colors.transparent,

                    navigationBar: CupertinoNavigationBar(

                      backgroundColor: Colors.white.withOpacity(0.2),
                      middle: Text("Search", style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                    ),


                    child: SearchView(),
                  ),
                ),
              );
            }
          ),
        )

    );;
  }

}


