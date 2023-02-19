import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'bubble_smash_bloc_provider.dart';
import 'bubble_smash_bloc.dart';
import 'mole_widgets.dart';





class HigHScoreWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    BubbleSmashBloc _bloc = BubbleSmashBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      child: StreamBuilder<int>(
        stream: _bloc.getHighScoreStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshots){

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              Text("High Score: "),
              SizedBox(width: 10.0,),

              Text(
                snapshots.hasData? snapshots.data: 0.toString(),
              )

            ],
          );

        },
      ),
    );
  }

}







class CurrentScoreWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    BubbleSmashBloc _bloc = BubbleSmashBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      child: StreamBuilder<int>(
        stream: _bloc.getCurrentScoreStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshots){

          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              Text("Score: "),
              SizedBox(width: 10.0,),

              Text(
                snapshots.hasData? snapshots.data: 0.toString(),
              )

            ],
          );

        },
      ),
    );
  }

}






class StartGameButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build



    BubbleSmashBloc _bloc = BubbleSmashBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return CupertinoButton(
      color: _themeData.primaryColor,
        child: Text("Start"),
        onPressed: ()async{


          //_bloc.addGameStateToStream(gameState: GameState.ON_STARTED);

          await BubbleSmashBlocProvider.of(context).handlers.startGame(gameContext: context);
        }
    );
  }

}


class StopGameButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    BubbleSmashBloc _bloc = BubbleSmashBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    return CupertinoButton(
      color: CupertinoColors.destructiveRed,
        child: Text("Stop"),
        onPressed: (){


          //BubbleSmashBlocProvider.of(context).bloc.addGameStateToStream(gameState: GameState.ON_STOPPED);
        }
    );
  }

}




class GameBoardWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    BubbleSmashBloc _bloc = BubbleSmashBlocProvider.of(context).bloc;


    return StreamBuilder<GameState>(

      stream: _bloc.getGameStateStream,
      initialData: GameState.ON_ENTER,
      builder: (BuildContext context, AsyncSnapshot<GameState> snapshots){

        switch(snapshots.data){
          case GameState.ON_ENTER:
            return StartGameButton();
          case GameState.ON_UPDATE:
            return Container();
          case GameState.ON_EXIT:
            return Container();
          case GameState.ON_STARTED:
            return StopGameButton();
          case GameState.ON_STOPPED:
            return Container();
        }

      },

    );
  }

}







class BubbleWidget extends StatelessWidget{


  BuildContext gameContext;

  BubbleWidget({
    @required this.gameContext
});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    BubbleSmashBloc _bloc = BubbleSmashBlocProvider.of(gameContext).bloc;




    return StreamBuilder<Color>(
      stream: _bloc.getSelectedBubbleColorStream,
      builder: (BuildContext context, AsyncSnapshot<Color> snapshots){

        if (snapshots.hasData){
          return Mole(
            moleWidth: 100.0,
            moleHeight: 100.0,
            color: snapshots.data,

          );
        }
        else{
          return Mole(
            moleWidth: 100.0,
            moleHeight: 100.0,
            color: Colors.blueAccent,
            onTap: (){

              _bloc.addSelectedBubbleColorToStream(selectedColor: CupertinoColors.activeGreen);

            },
          );
        }


        return Container(
          child: FloatingActionButton(
              backgroundColor: snapshots.hasData? snapshots.data: CupertinoColors.destructiveRed,
              foregroundColor: snapshots.hasData? snapshots.data: CupertinoColors.destructiveRed,
              onPressed: (){


              }),
        );
      },

    );
  }


}







