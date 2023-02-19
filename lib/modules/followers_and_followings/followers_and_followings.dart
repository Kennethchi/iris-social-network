import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iris_social_network/app/app_bloc_provider.dart';
import 'followers_and_followings_bloc.dart';
import 'followers_and_followings_bloc_provider.dart';
import 'followers_and_followings_views.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'followers_and_followings_views_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'package:iris_social_network/services/constants/app_constants.dart' as app_constants;




class FollowersAndFollowings extends StatefulWidget{

  String profileUserId;
  bool isFollowersView;
  String profileUserThumb;

  FollowersAndFollowings({@required this.profileUserId, @required this.profileUserThumb, @required this.isFollowersView = true})
      :
        assert(profileUserId != null  || isFollowersView != null)
  ;

  _FollowersAndFollowingsState createState() => new _FollowersAndFollowingsState();
}

class _FollowersAndFollowingsState extends State<FollowersAndFollowings>{


  FollowersAndFollowingsBloc _bloc;

  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = FollowersAndFollowingsBloc(profileUserId: widget.profileUserId, isFollowersView: widget.isFollowersView);

    _scrollController = ScrollController();
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _bloc.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FollowersAndFollowingsBlocProvider(
        bloc: _bloc,
        profileUserId: widget.profileUserId,
        scrollController: _scrollController,
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(

                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        widget.profileUserThumb != null && widget.profileUserId == AppBlocProvider.of(context).bloc.getCurrentUserId? widget.profileUserThumb: ""
                    ),
                    fit: BoxFit.cover
                )
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: widget.profileUserId == AppBlocProvider.of(context).bloc.getCurrentUserId? app_constants.WidgetsOptions.blurSigmaX: 0.0,
                  sigmaY: widget.profileUserId == AppBlocProvider.of(context).bloc.getCurrentUserId? app_constants.WidgetsOptions.blurSigmaY: 0.0
              ),
              child: CupertinoPageScaffold(

                backgroundColor: widget.profileUserId == AppBlocProvider.of(context).bloc.getCurrentUserId? Colors.black.withOpacity(0.1): Colors.transparent,

                navigationBar: getFollowersAndFollowingsAppBar(context: context, profileUserId: widget.profileUserId),
                child: FollowersAndFollowingsViews(),
              ),
            ),
          ),
        )

    );
  }


}