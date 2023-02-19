import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'comment_space_view_widgets.dart';
import 'comment_space_bloc_provider.dart';
import 'comment_space_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/optimised_models/optimised_comment_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:iris_social_network/utils/string_utils.dart';
import 'package:iris_social_network/utils/date_time_utils.dart';
import 'package:iris_social_network/modules/profile/profile.dart';
import 'package:time_ago_provider/time_ago_provider.dart';



class CommentsTitleWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CommentSpaceBloc _bloc = CommentSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return  Container(
      child: Center(
        child: Text("Comments",
          style: TextStyle(
              color: RGBColors.white,
              fontSize: _themeData.textTheme.navTitleTextStyle.fontSize,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}






class CommentsTextFieldWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CommentSpaceBloc _bloc = CommentSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      width: screenWidth * 0.9,
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.5),
            side: BorderSide(color: RGBColors.white, width: 1.0)
        ),

        child: TextField(
          onTap: null,
          maxLength: 150,
          controller: CommentSpaceBlocProvider.of(context).textEditingController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(color: RGBColors.white),
          cursorColor: _themeData.primaryColor,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(screenHeight * scaleFactor * scaleFactor),
            hintStyle: TextStyle(color: RGBColors.white.withOpacity(0.3)),
            border: InputBorder.none,
            suffixIcon: SubmitButtonWidget(),
            hintText: "Comment here ...",
            counterStyle: TextStyle(color: Colors.white)

          ),
          onChanged: (String text){
            CommentSpaceBlocProvider.of(context).handlers.onTextChange(commentSpaceContext: context, text: text);
          },


        ),






      ),
    );

  }
}






class SubmitButtonWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CommentSpaceBloc _bloc = CommentSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<String>(
      stream: _bloc.getTextStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){

        return IconButton(
          color: RGBColors.white,
          disabledColor: RGBColors.white.withOpacity(0.5),
            icon: Icon(FontAwesomeIcons.solidPaperPlane),

            onPressed: snapshot.hasData && snapshot.hasError == false? (){


              AppBlocProvider.of(context).handler.getHasInternetDataConnection().then((bool hasInternetConnection){

                if (hasInternetConnection != null && hasInternetConnection){

                  CommentSpaceBlocProvider.of(context).handlers.sendComment(context: context, cleanedComment: snapshot.data);
                }
                else{

                  BasicUI.showSnackBar(
                      context: context,
                      message: "No Internet Connection",
                      textColor:  CupertinoColors.destructiveRed,
                      duration: Duration(seconds: 1)
                  );
                }

              });



            }: null
        );

      },
    );
  }

}





class CommentModelViewHolder extends StatelessWidget{

  OptimisedCommentModel optimisedCommentModel;

  CommentModelViewHolder({@required this.optimisedCommentModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CommentSpaceBloc _bloc = CommentSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      leading: GestureDetector(

        onTap: (){

          Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserId: optimisedCommentModel.user_id)));
        },

        child: CircleAvatar(
          radius: 15.0,
          backgroundColor: RGBColors.light_grey_level_1,
          backgroundImage: CachedNetworkImageProvider(optimisedCommentModel.thumb),
        ),
      ),
      trailing: Text(
        //DateTimeUtils.getTimeFromMillisecondsSinceEpochType_jm(optimisedCommentModel.t),
        TimeAgo.getTimeAgo(optimisedCommentModel.t),
        style: TextStyle(
            color: RGBColors.light_grey_level_2,
          fontSize: Theme.of(context).textTheme.overline.fontSize
        ),
      ),
      title: GestureDetector(
        onTap: (){

          Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => Profile(profileUserId: optimisedCommentModel.user_id)));
        },

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Flexible(
              fit: FlexFit.loose,
              child: Text("@" + optimisedCommentModel.username,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(width: screenWidth * scaleFactor * scaleFactor,),

            if (optimisedCommentModel.v_user != null && optimisedCommentModel.v_user)
              Icon(FontAwesomeIcons.solidCheckCircle, color: _themeData.primaryColor, size: screenWidth * scaleFactor * 0.2,)

          ],
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * scaleFactor),
        child: Text(optimisedCommentModel.comment , style: TextStyle(color: RGBColors.white.withOpacity(0.8)),),
      ),
      dense: true,
    );
  }
}





class CommentListWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CommentSpaceBloc _bloc = CommentSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<List<OptimisedCommentModel>>(
        stream: _bloc.getCommentListStream,
        builder: (BuildContext context, AsyncSnapshot<List<OptimisedCommentModel>> snapshot){

          switch(snapshot.connectionState){

            case ConnectionState.none: case ConnectionState.waiting:

              return SliverList(delegate: SliverChildListDelegate(

                <Widget>[
                  SpinKitChasingDots(color: _themeData.primaryColor,)
                ]

              ));

            case ConnectionState.active: case ConnectionState.done:

              if (snapshot.hasData){

                if (snapshot.data.length == 0){

                  return SliverList(delegate: SliverChildListDelegate(

                      <Widget>[
                        Container()
                      ]

                  ));
                }
                else{

                  return SliverList(delegate: SliverChildListDelegate(

                      snapshot.data.map((OptimisedCommentModel optimisedCommentModel){

                        return FutureBuilder<String>(
                          future: _bloc.getCurrentUserId(),
                          builder: (context, snapshot) {

                            if (snapshot.hasData && snapshot.data == optimisedCommentModel.user_id){
                              return Dismissible(
                                key: UniqueKey(),

                                  confirmDismiss: (DismissDirection direction)async{

                                    if (direction == DismissDirection.startToEnd || direction == DismissDirection.endToStart){

                                      CommentSpaceBlocProvider.of(context).handlers.showDeleteCommentActionDialog(
                                          commentSpaceContext: context,
                                        optimisedCommentModel: optimisedCommentModel
                                      );
                                    }

                                    return false;
                                  },
                                  onDismissed: (DismissDirection direction){

                                  },

                                  child: CommentModelViewHolder(optimisedCommentModel: optimisedCommentModel)
                              );
                            }
                            else{
                              return CommentModelViewHolder(optimisedCommentModel: optimisedCommentModel);
                            }

                          }
                        );

                      }).toList()

                  ));
                }


              }
              else{

                return SliverList(delegate: SliverChildListDelegate(

                  <Widget>[

                    ScaleAnimatedTextKit(
                      text: ["No", "Comments", "No Comments"],
                      alignment: Alignment.center,
                      duration: Duration(seconds: 2),
                      isRepeatingAnimation: false,
                      textStyle: TextStyle(
                          color: _themeData.primaryColor,
                          fontSize: _themeData.textTheme.navTitleTextStyle.fontSize
                      ),
                    )

                  ]

                ));

              }


          }


        }
    );
  }
}









class LoadingCommentsIndicatorWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    CommentSpaceBloc _bloc = CommentSpaceBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[

          Container(
              child: StreamBuilder(
                stream: _bloc.getHasMoreCommentsStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.waiting:
                      return SpinKitChasingDots(color: _themeData.primaryColor,);
                    case ConnectionState.active: case ConnectionState.done:

                      if (snapshot.hasData && snapshot.data){
                        return SpinKitChasingDots(color: _themeData.primaryColor);
                      }
                      else{
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * scaleFactor * 0.5),
                          child: Center(
                            child: Text("No Comments",
                              style: TextStyle(fontSize: Theme.of(context).textTheme.subhead.fontSize, color: _themeData.primaryColor),
                            ),
                          ),
                        );
                      }
                  }



                },
              )
          )

        ]
      ),
    );


  }



}

