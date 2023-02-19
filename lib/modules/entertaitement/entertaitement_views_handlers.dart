import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';

import 'entertaitement_bloc.dart';
import 'entertaitement_bloc_provider.dart';
import 'entertaitement_features/image_classification_challenge/image_classification_challenge.dart';



class EntertaitementViewsHandlers{


  Future<void> showChallenges({@required BuildContext pageContext}){



    EntertaitementBlocProvider _provider = EntertaitementBlocProvider.of(pageContext);
    EntertaitementBloc _bloc = EntertaitementBlocProvider.of(pageContext).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(pageContext);
    double screenWidth = MediaQuery.of(pageContext).size.width;
    double screenHeight = MediaQuery.of(pageContext).size.height;
    double scaleFactor = 0.125;


    showDialog(
        context: pageContext,
        builder: (BuildContext context){

          return SafeArea(

            child: Animator(

              tween: Tween<double>(begin: 0.0, end: 1.0),
              //repeats: 1,
              curve: Curves.easeOutBack,
              duration: Duration(milliseconds: 500),
              builder: (anim){
                return Transform.scale(
                  scale: anim.value,
                  child: Center(

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * scaleFactor * 0.25),
                      child: Container(

                        width: screenWidth,
                        height: screenHeight * 0.8,

                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.4)
                          ),
                          child: SingleChildScrollView(
                            child: Column(

                              children: <Widget>[

                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.4),
                                  child: Text("Challenges", style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.title.fontSize,
                                      color: _themeData.primaryColor,
                                      fontWeight: FontWeight.bold

                                  ),),
                                ),

                                GestureDetector(

                                  onTap: (){

                                    Navigator.of(context).pop();

                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ImageClassificationChallenge()));

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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Item Finder Challenge",
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.bold,
                                              fontSize: Theme.of(context).textTheme.subhead.fontSize
                                            ),
                                          ),
                                          Text("(Image Classification)", style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.caption.fontSize
                                          ),)
                                        ],
                                      ),
                                    ),
                                    subtitle: Text("Earn Points by Finding randomly specified items, and taking a photo",
                                      style: TextStyle(
                                        fontSize: Theme.of(context).textTheme.caption.fontSize,
                                        color: Colors.black.withOpacity(0.4)
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * 0.4),
                                  child: Text("More Challenges Coming soon...", style: TextStyle(
                                      //fontSize: Theme.of(context).textTheme.title.fontSize,
                                      color: _themeData.primaryColor,
                                      fontWeight: FontWeight.bold

                                  ),),
                                ),


                              ],
                            ),
                          ),
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


  }



}