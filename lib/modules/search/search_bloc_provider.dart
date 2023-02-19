import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'search_bloc.dart';
import 'search_views_handlers.dart';



class SearchBlocProvider extends InheritedWidget{

  final SearchBloc bloc;
  final Key key;
  final Widget child;

  SearchViewsHandlers handlers;

  TextEditingController searchTextEditingController;

  SearchBlocProvider({@required this.bloc, @required this.searchTextEditingController, this.key, this.child}): super(key: key, child: child){


    handlers = SearchViewsHandlers();
  }


  static SearchBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(SearchBlocProvider) as SearchBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;


}