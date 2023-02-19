import 'dart:async';
import 'package:meta/meta.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/optimised_models/optimised_post_model.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';




abstract class PostRepository{


  Future<String> addPostData({@required PostModel postModel, @required String currentUserId});

  Future<void> addOptimisedPostData({@required OptimisedPostModel optimisedPostModel, @required String currentUserId, @required String postId});

  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink});

}