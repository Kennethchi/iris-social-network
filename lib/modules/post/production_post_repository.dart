import 'dart:async';
import 'package:meta/meta.dart';
import 'post_repository.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'firestore_provider.dart';
import 'realtime_database_provider.dart';
import 'package:iris_social_network/services/optimised_models/optimised_post_model.dart';
import 'dart:io';
import 'package:iris_social_network/services/server_services/models/FileModel.dart';
import 'server_rest_provider.dart';




class ProductionPostRepository extends PostRepository{


  @override
  Future<String> addPostData({@required PostModel postModel, @required String currentUserId})async {

    return await FirestoreProvider.addPostData(postModel: postModel, currentUserId: currentUserId);
  }


  @override
  Future<Function> addOptimisedPostData({@required OptimisedPostModel optimisedPostModel, @required String currentUserId, @required String postId})async {

    await RealtimeDatabaseProvider.addOptimisedPostData(optimisedPostModel: optimisedPostModel, currentUserId: currentUserId, postId: postId);
  }

  @override
  Future<FileModel> uploadFile({@required File sourceFile, @required String filename, @required StreamSink<int> progressSink, @required StreamSink<int> totalSink})async {

    return await ServerRestProvider.uploadFile(sourceFile: sourceFile, filename: filename, progressSink: progressSink, totalSink: totalSink);
  }


}