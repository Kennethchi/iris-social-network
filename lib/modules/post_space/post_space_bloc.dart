import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:iris_social_network/services/models/post_model.dart';
import 'package:iris_social_network/services/models/image_model.dart';
import 'package:iris_social_network/services/models/audio_model.dart';
import 'package:iris_social_network/services/models/post_model.dart';





abstract class PostSpaceBlocBlueprint{
  
  void dispose();
}


class PostSpaceBloc implements PostSpaceBlocBlueprint{




  int _currentPostViewIndex;
  int get getCurrentPostViewIndex => _currentPostViewIndex;
  set setCurrentPostViewIndex(int currentPostViewIndex) {
    _currentPostViewIndex = currentPostViewIndex;
  }


  BehaviorSubject<bool> _hasMorePostsBehaviorSubject = BehaviorSubject<bool>();
  Stream<bool> get getHasMorePostsBehaviorSubjectStream => _hasMorePostsBehaviorSubject.stream;
  Sink<bool> get getHasMorePostsBehaviorSubjectSink => _hasMorePostsBehaviorSubject.sink;


  BehaviorSubject<List<PostModel>> _postsListBehaviorSubject = BehaviorSubject<List<PostModel>>();
  Stream<List<PostModel>> get getPostsListStream => _postsListBehaviorSubject.stream;
  StreamSink<List<PostModel>> get _getPostsListSink => _postsListBehaviorSubject.sink;



  PostSpaceBloc({@required List<PostModel> postsList, @required int currentPostViewIndex}){

    this.setCurrentPostViewIndex = currentPostViewIndex;


    /*
    setCurrentPostViewIndex = 0;

    if (currentPostViewIndex > 0){


      PostModel currentIndexPostModel = postsList.elementAt(currentPostViewIndex);
      postsList.insert(0, currentIndexPostModel);

      // Plus 1 becauses after inserting post, the current post index will shift by 1 additional index
      postsList.removeAt(currentPostViewIndex + 1);
    }
    */

    addPostsListToStream(postsList);
  }


  addPostsListToStream(List<PostModel> postsList){

    _getPostsListSink.add(postsList);
  }


  @override
  void dispose() {
    // TODO: implement dispose

    _hasMorePostsBehaviorSubject?.close();
    _postsListBehaviorSubject?.close();
  }



}


