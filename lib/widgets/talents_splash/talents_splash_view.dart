import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';





List<String> getTalentImagesPath = [
  "assets/medias/images/talent_images/football.png",
  "assets/medias/images/talent_images/breakdance2.png",
  "assets/medias/images/talent_images/ballerina.png",
  "assets/medias/images/talent_images/breakdance1.png",
  "assets/medias/images/talent_images/girl_dancing.png",
  "assets/medias/images/talent_images/girl_singing.png",
  "assets/medias/images/talent_images/basketball.png",
  "assets/medias/images/talent_images/carefree_solo.png",
  "assets/medias/images/talent_images/singer.png",
  "assets/medias/images/talent_images/carefree_group.png",
  "assets/medias/images/talent_images/skateboard.png",
  "assets/medias/images/talent_images/soccer.png",

  "assets/medias/images/talent_images/karate.png",
  "assets/medias/images/talent_images/kids.png",

];











class TalentsSplashView extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        width: screenWidth,
        height: screenHeight,

        child: StaggeredGridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            staggeredTiles: <StaggeredTile>[
              StaggeredTile.count(4, 1),
              StaggeredTile.count(2, 1),
              StaggeredTile.count(2, 1),

              StaggeredTile.count(1, 1),

              StaggeredTile.count(2, 3),
              StaggeredTile.count(1, 2),
              StaggeredTile.count(1, 2),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(2, 2),
              StaggeredTile.count(2, 1),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(1, 2),
              StaggeredTile.count(1, 1),
              StaggeredTile.count(2, 1),
              StaggeredTile.count(1, 1)
            ],
            children: getTalentImagesPath.map((String imagePath){
              return Container(
                  //color: Colors.blue,
                  child: _TalentImageWidget(imagePath: imagePath, width: null, height: null)
              );
            }).toList()
        ),





      ),
    );
  }
}




class _TalentImageWidget extends StatelessWidget {

  String imagePath;
  BoxFit boxFit;
  double width;
  double height;

  _TalentImageWidget({@required this.imagePath, @required this.width, @required this.height});


  @override
  Widget build(BuildContext context) {


    /*
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.contain
          )
      ),
    );
    */

    return Container(
      width: width,
      height: height,
      child: Opacity(
        opacity: 1.0,
        /*
        child: ShaderMask(
          shaderCallback: (Rect bounds){

            return LinearGradient(
                colors: [CupertinoTheme.of(context).primaryColor, RGBColors.fuchsia],
                stops: [0.3, 0.8]

            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            //color: Colors.white.withOpacity(0.2),
          ),
        ),
        */
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          color: Colors.white.withOpacity(0.4),
          //color: Colors.white.withOpacity(0.2),
        ),
      ),

    );
  }
}








