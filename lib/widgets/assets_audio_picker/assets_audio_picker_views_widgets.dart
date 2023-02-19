import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'assets_audio_picker_bloc.dart';
import 'assets_audio_picker_bloc_provider.dart';
import 'package:iris_social_network/services/constants/assets_constants.dart';
import 'audio_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';





class AssetAudiosListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    AssetsAudioPickerBlocProvider _provider = AssetsAudioPickerBlocProvider.of(context);
    AssetsAudioPickerBloc _bloc = AssetsAudioPickerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return Container(
      color: Colors.black.withOpacity(0.03),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: screenHeight * scaleFactor * scaleFactor),

        itemCount: _provider.assetsAudioModalList.length,
        itemBuilder: (BuildContext context, int index){

          return AssetAudioViewModelHolder(
            assetsAudioModel: _provider.assetsAudioModalList[index],
            currentAudioIndex: index,
          );
        },

      ),
    );

  }
}



class AssetAudioViewModelHolder extends StatelessWidget {

  AssetsAudioModel assetsAudioModel;
  int currentAudioIndex;

  AssetAudioViewModelHolder({
    @required this.assetsAudioModel,
    @required this.currentAudioIndex,
  });


  @override
  Widget build(BuildContext context) {


    AssetsAudioPickerBlocProvider _provider = AssetsAudioPickerBlocProvider.of(context);
    AssetsAudioPickerBloc _bloc = AssetsAudioPickerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return StreamBuilder<Object>(
      stream: _bloc.getSelectedAudioIndexStream,
      builder: (context, snapshot) {
        return Container(
          color: snapshot.hasData && snapshot.data == currentAudioIndex? _themeData.primaryColor: Colors.transparent,
          child: GestureDetector(

            onTap: (){
              _bloc.addSelectedAudioIndexToStream(currentAudioIndex);
            },

            child: ListTile(

              dense: true,


              title: Text(assetsAudioModel.name),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Icon(Icons.copyright, color: Colors.black.withOpacity(0.2), size: 14.0,),
                  Text(
                    "copyright",
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.caption.fontSize,
                        color: Colors.black.withOpacity(0.2)
                    ),
                  ),

                  SizedBox(width: 5.0),
                  Flexible(
                    child: Text(
                        assetsAudioModel.copyright,
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.caption.fontSize,
                        color: Colors.black.withOpacity(0.2)
                      ),
                    ),
                  ),
                ],
              ),

              trailing: FittedBox(
                fit: BoxFit.contain,
                child: AudioWidget(assetsAudioPickerBloc: _bloc,
                    audioAssetPath: assetsAudioModel.path,
                  currentAudioIndex: currentAudioIndex,
                ),
              ),

            ),
          ),
        );
      }
    );
  }
}







class SaveProfileAudioButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    AssetsAudioPickerBlocProvider _provider = AssetsAudioPickerBlocProvider.of(context);
    AssetsAudioPickerBloc _bloc = AssetsAudioPickerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<int>(
      stream: _bloc.getSelectedAudioIndexStream,
      builder: (context, snapshot) {
        return CupertinoButton(

            disabledColor: snapshot.hasData? _themeData.primaryColor: Colors.black.withOpacity(0.2),

            child: Text("Save",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.subhead.fontSize
              ),
            ),
            onPressed: snapshot.hasData? ()async{

              BasicUI.showProgressDialog(
                  pageContext: context,
                  child: SpinKitFadingCircle(color: _themeData.primaryColor,)
              );

              String audioAssetPath = _provider.assetsAudioModalList[snapshot.data].path;

              File audioFile = await _provider.handlers.generateFileFromAssets(context: context, assetPath: audioAssetPath);

              Navigator.of(context).pop();
              Navigator.of(context).pop(audioFile);
            }: null

        );
      }
    );
  }

}




class SelectedAudioNameWdiget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AssetsAudioPickerBlocProvider _provider = AssetsAudioPickerBlocProvider.of(context);
    AssetsAudioPickerBloc _bloc = AssetsAudioPickerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return StreamBuilder<Object>(
      stream: _bloc.getSelectedAudioIndexStream,
      builder: (context, snapshot) {

        if (snapshot.hasData){

          return Container(
            child: ScaleAnimatedTextKit(
              text: [_provider.assetsAudioModalList[snapshot.data].name],
              textStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.subhead.fontSize,
                color: _themeData.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        else{

          return Container();
        }


      }
    );
  }
}



