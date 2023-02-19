import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'entertaitement_bloc.dart';
import 'entertaitement_bloc_provider.dart';
import 'entertaitement_views.dart';


class Entertaitement extends StatefulWidget {
  @override
  _EntertaitementState createState() => _EntertaitementState();
}


class _EntertaitementState extends State<Entertaitement> {

  EntertaitementBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = EntertaitementBloc();
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return EntertaitementBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        body: CupertinoPageScaffold(
          child: EntertaitementViews()
        ),
      ),
    );
  }
}
