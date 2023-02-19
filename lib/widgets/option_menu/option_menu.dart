import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'option_menu_bloc.dart';
import 'package:flutter/scheduler.dart';
import 'option_menu_observer.dart';
import 'option_menu_bloc_provider.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;
import 'package:iris_social_network/app/app_bloc_provider.dart';






class OptionMenu extends StatefulWidget{

  final Widget topStart;
  final Widget topCenter;
  final Widget topEnd;
  final Widget centerStart;
  final Widget center;
  final Widget centerEnd;
  final Widget bottomStart;
  final Widget bottomCenter;
  final Widget bottomEnd;

  final double width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool blurBackground;

  final Size optionMenuItemSize;

  final AlignmentDirectional alignmentDirectional;

  OptionMenu({
    @required this.width,
    @required this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.blurBackground = false,
    this.optionMenuItemSize = const Size(56.0, 56.0),
    this.alignmentDirectional = AlignmentDirectional.center,

    this.topStart, this.topCenter, this.topEnd, this.centerStart,
    this.center, this.centerEnd, this.bottomStart, this.bottomCenter, this.bottomEnd,
    
  })
      :
        assert(width != null),
        assert(height != null),
        assert(alignmentDirectional != null);


  _OptionMenuState createState() => _OptionMenuState();



  Size getWidgetSize({Widget widget}){

    assert(widget.key is GlobalKey);

    RenderBox renderBox = (widget.key as GlobalKey).currentContext?.findRenderObject();

    return renderBox?.size;
  }




}






class _OptionMenuState extends State<OptionMenu> with TickerProviderStateMixin implements OptionMenuObserver {

  OptionMenuBloc _bloc;

  OptionItemProvider _optionItemProvider;

  BuildContext _context;


  AnimationController _animationController;
  Animation<double> _translateAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = OptionMenuBloc();

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks){
      SchedulerBinding.instance.addPostFrameCallback((_){
        _bloc.addBuildComplete(true);
      });
    }

    _optionItemProvider = new OptionItemProvider();
    _optionItemProvider.subscribe(this);

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _translateAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOutBack));


    _animationController.forward();
  }






  @override
  void onItemSelect(OptionItemPosition optionPosition) {
    // TODO: implement onItemSelect

    _bloc.addItemSelected(optionPosition);


  }





  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _animationController.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return OptionMenuBlocProvider(
      bloc: _bloc,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child){

          return BackdropFilter(
            filter: widget.blurBackground? ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5
            ): ImageFilter.blur(),
            child: Container(
              width: widget.width,
              height: widget.height,
              child: Stack(
                alignment: widget.alignmentDirectional,

                children: <Widget>[


                  Positioned(
                    left: 0.0,
                    top: 0.0,
                    child: widget.topStart == null? SizedBox(): GestureDetector(
                      onTap: (){
                        _optionItemProvider.notify(OptionItemPosition.TOP_START);
                      },

                      child: Transform(
                        transform: Matrix4.translationValues(
                            _translateAnimation.value * (widget.width / 2 - widget.optionMenuItemSize.width / 2),
                            _translateAnimation.value * (widget.height / 2 - widget.optionMenuItemSize.height / 2),
                            0.0
                        ),
                        child: DragTarget(
                          //child: widget.centerStart,
                          builder: (BuildContext context, List<dynamic> accept, List<dynamic> reject) => widget.topStart,
                          onAccept: (OptionItemPosition itemPosition){
                            _optionItemProvider.notify(OptionItemPosition.TOP_START);;
                          },
                        ),
                      ),
                    ),
                  ),


                  Positioned(
                    top: 0.0,
                    child: widget.topCenter == null? SizedBox(): GestureDetector(
                      onTap: (){
                        _optionItemProvider.notify(OptionItemPosition.TOP_CENTER);
                      },
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0,
                            _translateAnimation.value * (widget.height / 2 - widget.optionMenuItemSize.height / 2),
                            0.0
                        ),
                        child: DragTarget(
                          //child: widget.centerStart,
                          builder: (BuildContext context, List<dynamic> accept, List<dynamic> reject) => widget.topCenter,
                          onAccept: (OptionItemPosition itemPosition){
                            _optionItemProvider.notify(OptionItemPosition.TOP_CENTER);;
                          },
                        ),
                      ),
                    ),
                  ),


                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: widget.topEnd == null? SizedBox():  GestureDetector(
                      onTap: (){
                        _optionItemProvider.notify(OptionItemPosition.TOP_END);
                      },
                      child: Transform(
                        transform: Matrix4.translationValues(
                            _translateAnimation.value * (widget.width / 2 - (widget.optionMenuItemSize.width / 2)) * -1,
                            _translateAnimation.value * (widget.height / 2 - widget.optionMenuItemSize.height / 2),
                            0.0
                        ),
                        child: DragTarget(
                          //child: widget.centerStart,
                          builder: (BuildContext context, List<dynamic> accept, List<dynamic> reject) => widget.topEnd,
                          onAccept: (OptionItemPosition itemPosition){
                            _optionItemProvider.notify(OptionItemPosition.TOP_END);
                          },
                        ),
                      ),
                    ),
                  ),


                  StreamBuilder<bool>(
                    stream: _bloc.getBuildCompleteStream,
                    initialData: false,
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                      return Positioned(
                        left: 0.0,
                        top: snapshot.data && widget.centerStart != null? (widget.height / 2) - (widget.getWidgetSize(widget: widget.centerStart).height / 2)
                            : widget.height / 2,
                        child: widget.centerStart == null? SizedBox():  GestureDetector(
                          onTap: (){
                            _optionItemProvider.notify(OptionItemPosition.CENTER_START);
                          },
                          child: Transform(
                            transform: Matrix4.translationValues(
                                _translateAnimation.value * (widget.width / 2 - widget.optionMenuItemSize.width / 2),
                                0.0,
                                0.0
                            ),
                            child: DragTarget(
                              //child: widget.centerStart,
                              builder: (BuildContext context, List<dynamic> accept, List<dynamic> reject) => widget.centerStart,
                              onAccept: (OptionItemPosition itemPosition){
                                _optionItemProvider.notify(OptionItemPosition.CENTER_START);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),


                  StreamBuilder<bool>(
                    stream: _bloc.getBuildCompleteStream,
                    initialData: false,
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

                      return Positioned(
                        left: snapshot.data && widget.center != null? (widget.width / 2) - (widget.getWidgetSize(widget: widget.center).width / 2)
                            : widget.width / 2,
                        top: snapshot.data && widget.center != null? (widget.height / 2) - (widget.getWidgetSize(widget: widget.center).height / 2)
                            : widget.height / 2,
                        child: widget.center == null? SizedBox(): GestureDetector(
                          onTap: (){
                            _optionItemProvider.notify(OptionItemPosition.CENTER);
                          },
                          child: Draggable(
                              feedback: FloatingActionButton(onPressed: (){}, backgroundColor: CupertinoTheme.of(context).primaryColor,),
                              data: OptionItemPosition.CENTER,
                              child: widget.center
                          ),
                        ),
                      );

                    },
                  ),


                  StreamBuilder<bool>(
                    stream: _bloc.getBuildCompleteStream,
                    initialData: false,
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                      return Positioned(
                        right: 0.0,
                        top: snapshot.data && widget.centerEnd != null? (widget.height / 2) - (widget.getWidgetSize(widget: widget.centerEnd).height / 2)
                            : widget.height / 2,
                        child: widget.centerEnd == null? SizedBox(): GestureDetector(
                          onTap: (){
                            _optionItemProvider.notify(OptionItemPosition.CENTER_END);
                          },
                          child: Transform(
                            transform: Matrix4.translationValues(
                                _translateAnimation.value * (widget.width / 2  - (widget.optionMenuItemSize.width / 2)) * -1 ,
                                0.0,
                                0.0
                            ),
                            child: DragTarget(
                              //child: widget.centerStart,
                              builder: (BuildContext context, List<dynamic> accept, List<dynamic> reject) => widget.centerEnd,
                              onAccept: (OptionItemPosition itemPosition){
                                _optionItemProvider.notify(OptionItemPosition.CENTER_END);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),


                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    child: widget.bottomStart == null? SizedBox():  GestureDetector(
                      onTap: (){
                        _optionItemProvider.notify(OptionItemPosition.BOTTOM_START);
                      },
                      child: Transform(
                        transform: Matrix4.translationValues(
                            _translateAnimation.value * (widget.width / 2 -  (widget.optionMenuItemSize.width / 2)) * 1  ,
                            _translateAnimation.value * (widget.height / 2  +  (widget.optionMenuItemSize.height / 2)) * -1 ,
                            0.0
                        ),
                        child: DragTarget(
                          //child: widget.centerStart,
                          builder: (BuildContext context, List<dynamic> accept, List<dynamic> reject) => widget.bottomStart,
                          onAccept: (OptionItemPosition itemPosition){
                            _optionItemProvider.notify(OptionItemPosition.BOTTOM_START);
                          },
                        ),
                      ),
                    ),
                  ),


                  Positioned(
                    bottom: 0.0,
                    child: widget.bottomCenter == null? SizedBox():  GestureDetector(
                      onTap: (){
                        _optionItemProvider.notify(OptionItemPosition.BOTTOM_CENTER);
                      },
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0,
                            _translateAnimation.value * (widget.height / 2 - (widget.optionMenuItemSize.height / 2)) * -1 ,
                            0.0
                        ),
                        child: DragTarget(
                          //child: widget.centerStart,
                          builder: (BuildContext context, List<dynamic> accept, List<dynamic> reject) => widget.bottomCenter,
                          onAccept: (OptionItemPosition itemPosition){
                            _optionItemProvider.notify(OptionItemPosition.BOTTOM_CENTER);
                          },
                        ),
                      ),
                    ),
                  ),


                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: widget.bottomEnd == null? SizedBox():  GestureDetector(
                      onTap: (){
                        _optionItemProvider.notify(OptionItemPosition.BOTTOM_END);
                      },
                      child: Transform(
                        transform: Matrix4.translationValues(
                            _translateAnimation.value * (widget.width / 2  -  (widget.optionMenuItemSize.width / 2)) * -1 ,
                            _translateAnimation.value * (widget.height / 2 -  (widget.optionMenuItemSize.width / 2)) * -1  ,
                            0.0
                        ),
                        child: DragTarget(
                          //child: widget.centerStart,
                          builder: (BuildContext context, List<dynamic> accept, List<dynamic> reject) => widget.bottomEnd,
                          onAccept: (OptionItemPosition itemPosition){
                            _optionItemProvider.notify(OptionItemPosition.BOTTOM_END);
                          },
                        ),
                      ),
                    ),
                  )



                ],
              ),
            ),
          );
        }
      ),
    );
  }

}





class OptionMenuItem extends StatelessWidget{

  final IconData iconData;
  final String label;
  final bool mini;
  final OptionItemPosition optionItemPosition;
  final bool returnItemPostionState;
  final VoidCallback onTap;


  OptionMenuItem({
    @required this.iconData,
    @required this.label,
    @required this.mini: false,
    @required this.optionItemPosition,
    @required this.onTap,
    this.returnItemPostionState: false,
  }): assert(iconData != null){


  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    OptionMenuBloc _bloc = OptionMenuBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;
    
    
    Color backgroundColor = _themeData.primaryColor;
    Color foregroundColor = _themeData.primaryContrastingColor;



    return StreamBuilder<OptionItemPosition>(
      stream: _bloc.getItemSelectedStream,
      //initialData: OptionItemPosition.CENTER,
      builder: (BuildContext context, AsyncSnapshot<OptionItemPosition> snapshot){


        Timer(Duration(milliseconds: 100), (){
          if(optionItemPosition == snapshot.data && returnItemPostionState){
            Navigator.of(context)?.pop(snapshot.data);
          }
          else if (optionItemPosition == snapshot.data && returnItemPostionState == false){
            onTap();
          }
        });



        // Makes the main item to change color when an item is selected
        // optionItemPosition == OptionItemPosition.CENTER && snapshot.data == optionItemPosition
        if (optionItemPosition == OptionItemPosition.CENTER){

          return Column(
            children: <Widget>[
              FloatingActionButton(onPressed: null, backgroundColor: _themeData.primaryColor, foregroundColor: RGBColors.white,
                child: Icon(iconData),
                mini: this.mini,
              ),
              SizedBox(height: this.label != null? screenHeight * scaleFactor * scaleFactor: 0.0),

              Container(
                child: this.label != null? Text(label, textAlign: TextAlign.center,
                  style: TextStyle(color: _themeData.primaryColor,
                      fontSize: Theme.of(context).textTheme.subtitle.fontSize,
                      decoration: TextDecoration.none
                  ),
                ): Container(),
              ),

            ],
          );
        }


        return Column(
          children: <Widget>[

            FloatingActionButton(
              onPressed: null,

              backgroundColor: optionItemPosition == snapshot.data? _themeData.primaryColor: RGBColors.white.withOpacity(0.2),
              foregroundColor: optionItemPosition == snapshot.data? RGBColors.white: _themeData.primaryColor,


              child: Icon(iconData),
              mini: this.mini,

            ),

            SizedBox(height: this.label != null? screenHeight * scaleFactor * scaleFactor: 0.0),

            Container(
              child: this.label != null? Text(label, textAlign: TextAlign.center,
                style: TextStyle(color: _themeData.primaryColor,
                    fontSize: Theme.of(context).textTheme.subtitle.fontSize,
                    decoration: TextDecoration.none
                ),
              ): Container(),
            ),

          ],
        );



      },

    );



  }

}











enum OptionItemPosition{

  TOP_START,
  TOP_CENTER,
  TOP_END,
  CENTER_START,
  CENTER,
  CENTER_END,
  BOTTOM_START,
  BOTTOM_CENTER,
  BOTTOM_END

}










