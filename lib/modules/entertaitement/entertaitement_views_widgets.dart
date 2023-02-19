import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/widgets/clippers/clippers.dart';
import 'entertaitement_bloc.dart';
import 'entertaitement_bloc_provider.dart';




class EntertaitementSliverAppBarWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    EntertaitementBlocProvider _provider = EntertaitementBlocProvider.of(context);
    EntertaitementBloc _bloc = EntertaitementBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return SliverAppBar(
      expandedHeight: screenHeight * 0.33,
      elevation: 1.0,
      centerTitle: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipPath(

        clipper: OvalBottomClipper(),

        child: FlexibleSpaceBar(

          centerTitle: true,
          background: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, RGBColors.fuchsia],
                    stops: [0.0, 0.5],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                ),

            ),
            child: SafeArea(
              child: Stack(
                children: <Widget>[

                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
                      child: FittedBox(
                        child: Text("Entertaitement",
                          style: TextStyle(
                              color: RGBColors.gold,
                            fontSize: Theme.of(context).textTheme.display1.fontSize,
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.5),
                              ),

                            ]
                          ),
                        ),
                      ),
                    ),
                  ),

                  FlareActor(
                    "assets/flare/shooting_stars.flr",
                    animation: "shooting",
                    //color: CupertinoColors.activeGreen,
                    alignment: Alignment.center,
                    fit: BoxFit.contain
                  ),
                ],
              ),
            ),
          ),

        ),
      ),


    );

  }

}




class EntertaitementListView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    EntertaitementBlocProvider _provider = EntertaitementBlocProvider.of(context);
    EntertaitementBloc _bloc = EntertaitementBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return SliverList(delegate: SliverChildListDelegate(<Widget>[


      GestureDetector(

        onTap: (){

          _provider.handlers.showChallenges(pageContext: context);
        },

        child: ListTile(
          leading: Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RGBColors.gold
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
                "Challenges",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.title.fontSize,
                color: _themeData.primaryColor,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          subtitle: Text("Get Points by Completing Challenges",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.caption.fontSize,
              color: Colors.black.withOpacity(0.5)
            ),
          ),
        ),
      ),



      Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.4),
          child: Text("More Entertaitements Coming soon...", style: TextStyle(
            //fontSize: Theme.of(context).textTheme.title.fontSize,
              color: _themeData.primaryColor,
              fontWeight: FontWeight.bold

          ),),
        ),
      ),



    ]));
  }
}





