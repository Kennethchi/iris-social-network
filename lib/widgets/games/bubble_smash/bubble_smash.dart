import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'bubble_smash_views.dart';
import 'bubble_smash_bloc.dart';
import 'bubble_smash_bloc_provider.dart';





class BubbleSmash extends StatefulWidget{
  _BubbleSmashState createState() => new _BubbleSmashState();
}



class _BubbleSmashState extends State<BubbleSmash>{

  BubbleSmashBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = BubbleSmashBloc();
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BubbleSmashBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        body: SafeArea(
          child: BubbleSmashArenaView(),
        )
      ),
    );
  }


}






