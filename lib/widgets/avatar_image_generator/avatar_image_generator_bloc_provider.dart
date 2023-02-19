import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'avatar_image_generator_bloc.dart';



class AvatarImageGeneratorBlocProvider extends InheritedWidget{

  final AvatarImageGeneratorBloc bloc;
  final Key key;
  final Widget child;

  AvatarImageGeneratorBlocProvider({@required this.bloc, this.key, this.child}): super(key: key, child: child);

  static AvatarImageGeneratorBlocProvider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(AvatarImageGeneratorBlocProvider) as AvatarImageGeneratorBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}