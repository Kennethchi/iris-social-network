import 'assets_constants.dart';
import 'constants.dart';




class ImagesConstants{


  static String IMAGE_PATH_KEY = "image_path";
  static String IMAGE_TITLE = "image_title";


  static List<Map<String, dynamic>> getVideoFeedsSlideshowImages = [

    /*
    {
      IMAGE_PATH_KEY: "assets/medias/images/video_feeds_slideshow_images/all_talents.jpg",
      IMAGE_TITLE: null
    },
    */

    {
      IMAGE_PATH_KEY: "assets/medias/images/video_feeds_slideshow_images/singing.jpg",
      IMAGE_TITLE: VideoType.music
    },

    {
      IMAGE_PATH_KEY: "assets/medias/images/video_feeds_slideshow_images/dancing.jpg",
      IMAGE_TITLE: VideoType.dancing
    },

    {
      IMAGE_PATH_KEY: "assets/medias/images/video_feeds_slideshow_images/sports.jpg",
      IMAGE_TITLE: VideoType.sports
    },

    {
      IMAGE_PATH_KEY: "assets/medias/images/video_feeds_slideshow_images/magic.jpg",
      IMAGE_TITLE: VideoType.magic
    },


    {
      IMAGE_PATH_KEY: "assets/medias/images/video_feeds_slideshow_images/modeling.jpg",
      IMAGE_TITLE: VideoType.modeling
    },

    {
      IMAGE_PATH_KEY: "assets/medias/images/video_feeds_slideshow_images/fashion.jpg",
      IMAGE_TITLE: VideoType.fashion
    },

    {
      IMAGE_PATH_KEY: "assets/medias/images/video_feeds_slideshow_images/comedy.jpg",
      IMAGE_TITLE: VideoType.comedy
    },


  ];



  static List<String> getTalentImagesPath = [
    "assets/medias/images/talent_images/girl_jumping.png",
    "assets/medias/images/talent_images/football.png",
    "assets/medias/images/talent_images/basketball.png",
    "assets/medias/images/talent_images/break-dance.png",
    "assets/medias/images/talent_images/breakdance1.png",
    "assets/medias/images/talent_images/girl_dancing.png",
    "assets/medias/images/talent_images/breakdance2.png",
    "assets/medias/images/talent_images/flip_dance.png",
    "assets/medias/images/talent_images/carefree_solo.png",
    "assets/medias/images/talent_images/singer.png",
    "assets/medias/images/talent_images/carefree_group.png",
    "assets/medias/images/talent_images/skateboard.png",
    "assets/medias/images/talent_images/soccer.png",
    "assets/medias/images/talent_images/girl_singing.png",
    "assets/medias/images/talent_images/ballerina.png",
    "assets/medias/images/talent_images/kids.png",
    "assets/medias/images/talent_images/karate.png",

  ];




  static String music_note_animation_gif = "assets/medias/images/music_note_animation.gif";


}




class AudioContants{



  static List<AssetsAudioModel> get getProfileSoundsAssetModels => [

    AssetsAudioModel(
        name: "Bensound - Acoustic Breeze",
        path: ProfileSoundsPaths.bensound_acousticbreeze,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - A New Beginning",
        path: ProfileSoundsPaths.bensound_anewbeginning,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Creative Minds",
        path: ProfileSoundsPaths.bensound_creativeminds,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Cute",
        path: ProfileSoundsPaths.bensound_cute,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Going Higher",
        path: ProfileSoundsPaths.bensound_goinghigher,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Happy Rock",
        path: ProfileSoundsPaths.bensound_happyrock,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Hey",
        path: ProfileSoundsPaths.bensound_hey,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Jazzy Frenchy",
        path: ProfileSoundsPaths.bensound_jazzyfrenchy,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Little Idea",
        path: ProfileSoundsPaths.bensound_littleidea,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Memories",
        path: ProfileSoundsPaths.bensound_memories,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Summer",
        path: ProfileSoundsPaths.bensound_summer,
        copyright: Copyrighters.bensound
    ),

    AssetsAudioModel(
        name: "Bensound - Ukulele",
        path: ProfileSoundsPaths.bensound_ukulele,
        copyright: Copyrighters.bensound
    ),
  ];



}


class Copyrighters{
  static const bensound = "www.bensound.com";

}