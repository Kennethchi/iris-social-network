import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';


class VideoModel{

   String videoId;
   String videoImage;
   String videoThumb;
   String videoUrl;
   int timestamp;
   int numLikes;
   int numComments;
   int numShares;
   int numViews;
   String talentType;
   String videoCategory;
   int duration;


   VideoModel({
     this.videoId,
     @required this.videoImage,
     @required this.videoThumb,
     @required this.videoUrl,
     @required this.timestamp,
     this.numLikes = 0,
     this.numComments = 0,
     this.numShares = 0,
     this.numViews = 0,
     @required this.talentType,
     @required this.videoCategory,
     @required this.duration,
   });


   VideoModel.fromJson(Map<dynamic, dynamic> json){

     this.videoId = json[VideosDocumentFieldName.video_id];
     this.videoImage = json[VideosDocumentFieldName.video_image];
     this.videoThumb = json[VideosDocumentFieldName.video_thumb];
     this.videoUrl = json[VideosDocumentFieldName.video_url];
     this.timestamp = json[VideosDocumentFieldName.timestamp];
     this.numLikes = json[VideosDocumentFieldName.num_likes];
     this.numComments = json[VideosDocumentFieldName.num_comments];
     this.numShares = json[VideosDocumentFieldName.num_shares];
     this.numViews = json[VideosDocumentFieldName.num_views];
     this.talentType = json[VideosDocumentFieldName.talent_type];
     this.videoCategory = json[VideosDocumentFieldName.video_category];
     this.duration = json[VideosDocumentFieldName.duration];

   }


   Map<String, dynamic> toJson(){

     Map<String, dynamic> data = new Map<String, dynamic>();

     data[VideosDocumentFieldName.video_id] = this.videoId;
     data[VideosDocumentFieldName.video_image] = this.videoImage;
     data[VideosDocumentFieldName.video_thumb] = this.videoThumb;
     data[VideosDocumentFieldName.video_url] = this.videoUrl;
     data[VideosDocumentFieldName.timestamp] = this.timestamp;
     data[VideosDocumentFieldName.num_likes] = this.numLikes;
     data[VideosDocumentFieldName.num_comments] = this.numComments;
     data[VideosDocumentFieldName.num_shares] = this.numShares;
     data[VideosDocumentFieldName.num_views] = this.numViews;
     data[VideosDocumentFieldName.talent_type] = this.talentType;
     data[VideosDocumentFieldName.video_category] = this.videoCategory;
     data[VideosDocumentFieldName.duration] = this.duration;

     return data;
   }


}
