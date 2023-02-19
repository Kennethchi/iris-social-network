import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iris_social_network/services/firebase_services/firebase_strings/cloud_firestore_strings.dart';
import 'package:meta/meta.dart';


class ImageModel{

  String imageId;
  List<dynamic> imagesUrl;
  List<dynamic> imagesThumbsUrl;
  int timestamp;
  int numLikes;
  int numComments;
  int numShares;


  ImageModel({
    this.imageId,
    @required this.imagesUrl,
    @required this.imagesThumbsUrl,
    @required this.timestamp,
    this.numLikes = 0,
    this.numComments = 0,
    this.numShares = 0,
  });


  ImageModel.fromJson(Map<dynamic, dynamic> json){

    this.imageId = json[ImageDocumentFieldNames.image_id];
    this.imagesUrl = json[ImageDocumentFieldNames.images_url];
    this.imagesThumbsUrl = json[ImageDocumentFieldNames.images_thumbs_url];
    this.timestamp = json[ImageDocumentFieldNames.timestamp];
    this.numLikes = json[ImageDocumentFieldNames.num_likes];
    this.numComments = json[ImageDocumentFieldNames.num_comments];
    this.numShares = json[ImageDocumentFieldNames.num_shares];

  }


  Map<String, dynamic> toJson(){

    Map<String, dynamic> data = new Map<String, dynamic>();

    data[ImageDocumentFieldNames.image_id] = this.imageId;
    data[ImageDocumentFieldNames.images_thumbs_url] = this.imagesThumbsUrl;
    data[ImageDocumentFieldNames.images_url] = this.imagesUrl;
    data[ImageDocumentFieldNames.timestamp] = this.timestamp;
    data[ImageDocumentFieldNames.num_likes] = this.numLikes;
    data[ImageDocumentFieldNames.num_comments] = this.numComments;
    data[ImageDocumentFieldNames.num_shares] = this.numShares;

    return data;
  }


}
