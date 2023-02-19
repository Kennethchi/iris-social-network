import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/firebase_storage_strings.dart';
import 'package:painter/painter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:io';
import 'paint_board_provider.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';


class PaintBoard extends StatefulWidget {
  @override
  _PaintBoardState createState() => new _PaintBoardState();
}

class _PaintBoardState extends State<PaintBoard> with TickerProviderStateMixin {

  bool _finished;
  PainterController _controller;

  AnimationController animationController;
  Animation sizeAnimation;

  @override
  void initState() {
    super.initState();
    _finished = false;

    animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));

  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _controller = _initialisePaintController();
  }

  
  
  PainterController _initialisePaintController(){
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = RGBColors.white;
    controller.drawColor = CupertinoTheme.of(context).primaryColor;
    return controller;
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _controller.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    return PaintBoardProvider(
      painterController: this._controller,
      child: SafeArea(
        child: Container(

          child: new Center(
              child: Column(
                children: <Widget>[

                  PaintBoardToolBar(),

                  Container(
                    padding: EdgeInsets.all(8.0),
                    color: RGBColors.light_grey_level_2,
                    child: new AspectRatio(
                        aspectRatio: 3 / 4,
                        child: new PaintSheet()
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

}



class PaintSheet extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Painter(PaintBoardProvider.of(context).painterController);
  }

}




class PaintBoardToolBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    PainterController painterController = PaintBoardProvider.of(context).painterController;


    return  Column(
      children: <Widget>[

        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: CupertinoTheme.of(context).primaryColor,),
              onPressed: (){
                Navigator.pop(context, null);
              },
            ),

            IconButton(
              onPressed: ()async{

                Directory tempDir = await getTemporaryDirectory();
                File artImageFile = File("${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}" + StorageFileExtensions.jpeg);
                Uint8List pictureUint8List = await PaintBoardProvider.of(context).painterController.finish().toPNG();

                artImageFile.writeAsBytesSync(pictureUint8List);

                Navigator.pop(context, artImageFile);
              },
              icon: Icon(Icons.check),
            )
          ],
        ),

        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
                child: new StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState){
                      return new Container(
                          child: new Slider(
                            value:  painterController.thickness,
                            onChanged: (double value) => setState((){
                              painterController.thickness=value;
                            }),
                            min: 1.0,
                            max: 20.0,
                            activeColor: CupertinoTheme.of(context).primaryColor,
                            inactiveColor: RGBColors.light_grey_level_2,
                          )
                      );
                    }
                )
            ),
            new ColorPickerButton( painterController, false),
            new ColorPickerButton( painterController, true),

            new IconButton(
                icon: new Icon(Icons.undo, color: CupertinoTheme.of(context).primaryColor,),
                tooltip: 'Undo',
                onPressed:  painterController.undo
            ),
            new IconButton(
                icon: new Icon(Icons.delete, color: CupertinoTheme.of(context).primaryColor,),
                tooltip: 'Clear',
                onPressed:  painterController.clear
            ),


          ],
        ),
      ],
    );
  }
}





class ColorPickerButton extends StatefulWidget {

  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller,this._background);

  @override
  _ColorPickerButtonState createState() => new _ColorPickerButtonState();
}





class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new Icon(_iconData ,color: CupertinoTheme.of(context).primaryColor), // _color
        tooltip: widget._background?'Change background color':'Change draw color',
        onPressed: _pickColor
    );
  }

  void _pickColor(){
    Color pickerColor = _color;
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Center(
          child: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                child: Card(
                  child: new ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (Color c)=>pickerColor=c,
                  ),
                )
            ),
          ),
        );
      }
    ).then((_){
      setState((){
        _color=pickerColor;
      });
    });



  }

  Color get _color=>widget._background?widget._controller.backgroundColor:widget._controller.drawColor;

  IconData get _iconData=>widget._background?Icons.format_color_fill:Icons.brush;

  set _color(Color color){
    if(widget._background){
      widget._controller.backgroundColor=color;
    } else {
      widget._controller.drawColor=color;
    }
  }
}