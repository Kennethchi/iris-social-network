import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'paint_board_provider.dart';
import 'dart:typed_data';
import 'package:meta/meta.dart';

class PaintBoardHandlers{

  void show({@required PictureDetails pictureDetails, @required BuildContext context}){



    PaintBoardProvider.of(context).hasFinishedPainting = true;


    Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context){
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('View your image'),
            ),
            body: new Container(
                alignment: Alignment.center,
                child:new FutureBuilder<Uint8List>(
                  future: pictureDetails.toPNG(),
                  builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot){
                    switch (snapshot.connectionState)
                    {

                      case ConnectionState.done:
                        if (snapshot.hasError){
                          return new Text('Error: ${snapshot.error}');
                        }else{
                          return Image.memory(snapshot.data);
                        }
                        break;

                      default:
                        return new Container(
                            child:new FractionallySizedBox(
                              widthFactor: 0.1,
                              child: new AspectRatio(
                                  aspectRatio: 1.0,
                                  child: new CircularProgressIndicator()
                              ),
                              alignment: Alignment.center,
                            )
                        );

                    }
                  },
                )
            ),
          );
        })
    );
  }



}




