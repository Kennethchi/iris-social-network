import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'users_suggestion_bloc.dart';
import 'users_suggestion_bloc_provider.dart';
import 'users_suggestion_view.dart';





class UsersSuggestion extends StatefulWidget {
  @override
  _UsersSuggestionState createState() => _UsersSuggestionState();
}

class _UsersSuggestionState extends State<UsersSuggestion> {

  UsersSuggestionBloc _bloc;

  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = UsersSuggestionBloc();

    _scrollController = ScrollController();
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _scrollController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return UsersSuggestionBlocProvider(
      bloc: _bloc,
      scrollController: _scrollController,
      child: Scaffold(

        appBar: AppBar(
          title: Text("Users Suggestion",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: (){
                Navigator.of(context).pop();
              },
            child: Icon(Icons.arrow_back_ios, color: CupertinoTheme.of(context).primaryColor,),
          ),
        ),
        body: UsersSuggestionView(),
      ),
    );
  }
}
