import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'entertaitement_bloc.dart';
import 'entertaitement_bloc_provider.dart';
import 'entertaitement_views_widgets.dart';



class EntertaitementViews extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    EntertaitementBlocProvider _provider = EntertaitementBlocProvider.of(context);
    EntertaitementBloc _bloc = EntertaitementBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      child: CustomScrollView(
        slivers: <Widget>[

          EntertaitementSliverAppBarWidget(),

          EntertaitementListView()

        ],
      ),
    );
  }
}
