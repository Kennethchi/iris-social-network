import 'package:flutter/material.dart';
import 'profile_upload_bloc.dart';
import 'profile_upload_view_handlers.dart';
import 'package:iris_social_network/modules/profile/profile_bloc.dart';


class ProfileUploadBlocProvider extends InheritedWidget {


  final Key key;
  final Widget child;
  final ProfileUploadBloc uploadBloc;
  final ProfileBloc profileBloc;

  ProfileUploadViewHandlers profileUploadViewHandlers;

  final TextEditingController videoCaptionTextEditingControlloer;

  ProfileUploadBlocProvider({
    @required this.uploadBloc,
    @required this.profileBloc,
    @required this.videoCaptionTextEditingControlloer, this.key, this.child
  })
      : super(key: key, child: child)
  {
    profileUploadViewHandlers = ProfileUploadViewHandlers();
  }


  static ProfileUploadBlocProvider of(BuildContext context) => (
          context.inheritFromWidgetOfExactType(
          ProfileUploadBlocProvider) as ProfileUploadBlocProvider
      );


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;


}