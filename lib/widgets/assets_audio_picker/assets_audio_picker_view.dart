import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'assets_audio_picker_bloc.dart';
import 'assets_audio_picker_bloc_provider.dart';
import 'assets_audio_picker_views_widgets.dart';



class AssetsAudioPickerView extends StatelessWidget {




  @override
  Widget build(BuildContext context) {

    AssetsAudioPickerBlocProvider _provider = AssetsAudioPickerBlocProvider.of(context);
    AssetsAudioPickerBloc _bloc = AssetsAudioPickerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;




    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * scaleFactor * 0.5)

      ),

      child: Column(

        children: <Widget>[


          Padding(
            padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
            child: Text("Select Profile Audio",
              style: TextStyle(
                color: _themeData.primaryColor,
                fontSize: Theme.of(context).textTheme.subhead.fontSize
              ),
            ),
          ),

          Flexible(
              child: AssetAudiosListView()
          ),

          Padding(
            padding: EdgeInsets.all(screenWidth * scaleFactor * 0.25),
            child: Column(
              children: <Widget>[

                SelectedAudioNameWdiget(),
                SizedBox(height: scaleFactor * scaleFactor * 0.3,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Flexible(
                      flex: 50,
                      fit: FlexFit.tight,
                      child: CupertinoButton(
                          child: Text("Cancel", style: TextStyle(
                              color: _themeData.primaryColor
                          ),),
                          onPressed: (){
                            Navigator.pop(context);
                          }
                      ),
                    ),

                    Flexible(
                        flex: 50,
                        fit: FlexFit.tight,
                        child: SaveProfileAudioButton()),
                  ],
                ),
              ],
            ),
          )

        ],


      ),

    );
  }
}
