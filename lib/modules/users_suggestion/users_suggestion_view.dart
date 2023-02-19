import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'users_suggestion_bloc.dart';
import 'users_suggestion_bloc_provider.dart';
import 'users_suggestion_view_widgets.dart';



class UsersSuggestionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    UsersSuggestionBlocProvider _provider = UsersSuggestionBlocProvider.of(context);
    UsersSuggestionBloc _bloc = UsersSuggestionBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return Center(
      child: SuggestedUsersListView(),
    );
  }
}
