import 'package:meta/meta.dart';


class ImagePaths{

  static const String default_profile_image = "assets/medias/images/default_profile_image.jpg";
}


class PostTypeBackgroundImages{

  static const String audio = "assets/medias/images/audios_background_image.jpg";
  static const String image = "assets/medias/images/images_background_image.jpg";
  static const String video = "assets/medias/images/videos_background_image.jpg";

}



class AppBackgroundImages{
  //static const String audio_background_image_aurora = "assets/medias/images/audios_background_image_aurora.jpg";
  static const String audio_background_image_orion_nebula = "assets/medias/images/audios_background_image_orion_nebula.jpg";
}

class FriendsFeedBackgroundImages{

  static const String friends_feed_background_image_girls = "assets/medias/images/friends_feed_background_image_girls.jpg";
  static const String friends_feed_background_image_friend_logo = "assets/medias/images/friends_feed_background_image_friend_logo.jpg";
  static const String friends_feed_background_image_people = "assets/medias/images/friends_feed_background_image_people.jpg";
  static const String friends_feed_background_image_love = "assets/medias/images/friends_feed_background_image_love.jpg";
  static const String friends_feed_background_image_sunset = "assets/medias/images/friends_feed_background_image_sunset.jpg";
}


class ProfileSoundsPaths{


  static const String bensound_acousticbreeze ="assets/medias/audios/profile_sound_tracks/bensound-acousticbreeze.mp3";
  static const String bensound_anewbeginning = "assets/medias/audios/profile_sound_tracks/bensound-anewbeginning.mp3";
  static const String bensound_creativeminds = "assets/medias/audios/profile_sound_tracks/bensound-creativeminds.mp3";
  static const String bensound_cute = "assets/medias/audios/profile_sound_tracks/bensound-cute.mp3";
  static const String bensound_goinghigher = "assets/medias/audios/profile_sound_tracks/bensound-goinghigher.mp3";
  static const String bensound_happyrock = "assets/medias/audios/profile_sound_tracks/bensound-happyrock.mp3";
  static const String bensound_hey = "assets/medias/audios/profile_sound_tracks/bensound-hey.mp3";
  static const String bensound_jazzyfrenchy = "assets/medias/audios/profile_sound_tracks/bensound-jazzyfrenchy.mp3";
  static const String bensound_littleidea = "assets/medias/audios/profile_sound_tracks/bensound-littleidea.mp3";
  static const String bensound_memories = "assets/medias/audios/profile_sound_tracks/bensound-memories.mp3";
  static const String bensound_summer = "assets/medias/audios/profile_sound_tracks/bensound-summer.mp3";
  static const String bensound_ukulele = "assets/medias/audios/profile_sound_tracks/bensound-ukulele.mp3";
}






class AssetsAudioModel{

  String path;
  String name;
  String copyright;


  AssetsAudioModel({
   @required this.name,
    @required this.path,
    @required this.copyright
  });

}