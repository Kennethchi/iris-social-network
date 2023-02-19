import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/services/models/user_model.dart';
import 'search_bloc.dart';
import 'search_bloc_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'search_views_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    SearchBloc _bloc = SearchBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    double circularRadius = screenWidth * scaleFactor * 0.5;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.2),
        child: Column(

          children: <Widget>[

            SearchTextField(),

            Flexible(
              flex: 100,
              child: StreamBuilder<UserModel>(
                stream: _bloc.getSearchUserModelStream,
                builder: (context, snapshot) {

                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.waiting:
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(circularRadius),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Icon(Icons.search, color: Colors.white.withOpacity(0.5), size: screenWidth * scaleFactor * 1.5,),

                              Text("Search User", style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: Theme.of(context).textTheme.title.fontSize),
                              ),
                            ],
                          ),
                        )
                        ,
                      );
                    case ConnectionState.active: case ConnectionState.done:

                      if(snapshot.hasData){
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(circularRadius)
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[

                              UserModelViewHolder(userModel: snapshot.data,),

                              Center(
                                  child: SearchFoundIndicatorWidget()
                              )

                            ],
                          ),
                        );
                      }
                      else{
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(circularRadius),
                          ),
                          child: Center(
                            child: SearchFoundIndicatorWidget(),
                          )
                          ,
                        );
                      }

                  }

                }
              ),
            ),


          ],

        ),
      ),
    );
  }
}



