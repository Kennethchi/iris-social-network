import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'comment_space_bloc.dart';
import 'comment_space_view_handlers.dart';



class CommentSpaceBlocProvider extends InheritedWidget{


  final CommentSpaceBloc bloc;
  final Key key;
  final Widget child;

  TextEditingController textEditingController;
  ScrollController scrollController;

  CommentSpaceViewHandlers handlers;


  CommentSpaceBlocProvider({
    @required this.bloc,
    @required this.textEditingController,
    @required this.scrollController, this.key, this.child})
      : super(key: key, child: child){

    handlers = CommentSpaceViewHandlers();


    scrollController.addListener((){

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double deltaBottom = 0.0;


      if (maxScroll == currentScroll){

        if ((bloc.getHasLoadedComments == false || bloc.getHasLoadedComments == null) && bloc.getHasMoreComments){

          bloc.setHasLoadedComments = true;

          bloc.loadMoreComments(
            commentsPostId: bloc.getPostModel.postId,
            postUserId: bloc.getPostModel.userId,
            queryLimit: bloc.getCommentsQueryLimit,
            endAtValue: bloc.getQueryEndAtValue
          ).then((_){

            bloc.setHasLoadedComments = false;
          });
        }
      }

    });
  }

  static CommentSpaceBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(CommentSpaceBlocProvider));


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}