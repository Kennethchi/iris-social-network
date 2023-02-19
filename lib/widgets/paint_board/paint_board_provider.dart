import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'paint_board_handlers.dart';

class PaintBoardProvider extends InheritedWidget{

  final PainterController painterController;
  bool hasFinishedPainting = false;
  final Key key;
  final Widget child;

  PaintBoardHandlers handlers;

  PaintBoardProvider({@required this.painterController, this.key, this.child}):
        handlers = PaintBoardHandlers(),
        super(key: key, child: child);



  static PaintBoardProvider of(BuildContext context) => (context.inheritFromWidgetOfExactType(PaintBoardProvider) as PaintBoardProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}