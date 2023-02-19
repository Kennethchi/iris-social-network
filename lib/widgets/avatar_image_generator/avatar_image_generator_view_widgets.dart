import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:avataaar_image/avataaar_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';
import 'package:iris_social_network/ui/basic_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'avatar_image_generator_bloc.dart';
import 'avatar_image_generator_bloc_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';






class AvatarSelectedImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    AvatarImageGeneratorBloc _bloc = AvatarImageGeneratorBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double radius = screenWidth * scaleFactor * 2;


    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: StreamBuilder<Avataaar>(
          stream: _bloc.getSelectedGeneratedAvatarStream,
          builder: (BuildContext context, AsyncSnapshot<Avataaar> snapshot) {
            if (snapshot.hasData) {

              return AvataaarImage(
                avatar: snapshot.data,
                errorImage: Icon(Icons.error),
                placeholder: CircularProgressIndicator(),
                width: radius * 2,
              );
            } else {
              return Container();
            }
          }
      ),
    );
  }
}


class AvatarImagesGridViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    AvatarImageGeneratorBloc _bloc = AvatarImageGeneratorBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;

    double radius = screenWidth * scaleFactor * 2;


    /*
    return
    */

    return StreamBuilder<List<Avataaar>>(
      stream: _bloc.getGeneratedAvatarListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Avataaar>> snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index){

              return GestureDetector(

                onTap: (){

                  _bloc.addGeneratedAvatarToStream(snapshot.data[index]);
                },

                child: Padding(
                  padding: EdgeInsets.all(screenWidth * scaleFactor * 0.33),
                  child: CircleAvatar(
                    radius: radius,
                    backgroundColor: Colors.transparent,
                    child: AvataaarImage(
                      avatar: snapshot.data[index],
                      errorImage: Icon(Icons.error),
                      placeholder: CircularProgressIndicator(),
                      width: radius * 2,
                    ),
                  ),
                ),
              );
            },
            itemCount: snapshot.data.length,
          );
        } else {
          return Container(
            padding: EdgeInsets.all(screenWidth * scaleFactor),
            child: Center(
              child: Text("Click the button below to generate Random Avatars",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
    );
  }
}






class GenerateRandomAvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    AvatarImageGeneratorBloc _bloc = AvatarImageGeneratorBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return CupertinoButton.filled(
        child: Text("GENERATE", style: TextStyle(color: Colors.white),),
        onPressed: (){

          Avataaar avataaar = Avataaar.random(
              skin: Skin.brown,
              style: Style.circle,
              top: Top.random,
              clothes: Clothes.random
          );

          List<Avataaar> avataaarList = List<Avataaar>();

          for (int index = 0; index < 12; ++index){
            avataaarList.add(Avataaar.random(
              style: Style.transparent,
            ));
          }

          _bloc.addGeneratedAvatarListToStream(avataaarList);

        }
    );
  }
}




class ValidateSelectedGeneratedAvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AvatarImageGeneratorBloc _bloc = AvatarImageGeneratorBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;



    return IconButton(icon: Icon(Icons.check), onPressed: ()async{

      BasicUI.showProgressDialog(pageContext: context, child: SpinKitCircle(color: _themeData.primaryColor,));

      Uint8List imageUint8List = await AvataaarsApi().getImage(_bloc.getSelectedGeneratedAvatar, screenWidth);


      Directory tempDir = await getTemporaryDirectory();
      File imageFile = File("${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}" + StorageFileExtensions.jpeg);

      if (imageUint8List == null){
        Navigator.pop(context);
        return;
      }

      imageFile.writeAsBytesSync(imageUint8List);

      Navigator.pop(context);
      Navigator.pop(context, imageFile);

    });
  }
}






class ExitAvatarGeneratorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AvatarImageGeneratorBloc _bloc = AvatarImageGeneratorBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()async{

      Navigator.pop(context);

    });
  }
}



