import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'option_menu_bloc.dart';
import 'option_menu.dart';



class OptionMenuBlocProvider extends InheritedWidget{

  OptionMenuBloc bloc;
  Key key;
  Widget child;


  ValueChanged<OptionItemPosition> onItemSelect;


  OptionMenuBlocProvider({@required this.bloc, this.key, this.child}): super(key: key, child: child);


  static OptionMenuBlocProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(OptionMenuBlocProvider) as OptionMenuBlocProvider);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}