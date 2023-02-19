import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'interest_model.dart';



abstract class InterestsPickerBlocBlueprint{

  void dispose();
}


class InterestsPickerBloc implements InterestsPickerBlocBlueprint{



  BehaviorSubject<List<InterestModel>> _interestModelListBehaviorSubjecj = BehaviorSubject<List<InterestModel>>();
  Stream<List<InterestModel>> get getInterestModelListStream => _interestModelListBehaviorSubjecj.stream;
  StreamSink<List<InterestModel>> get _getInterestModelListSink => _interestModelListBehaviorSubjecj.sink;

  InterestsPickerBloc(){
  }

  void addInterestModelListToStream(List<InterestModel> interestModelList){
    _getInterestModelListSink.add(interestModelList);
  }

  @override
  void dispose() {
    _interestModelListBehaviorSubjecj?.close();
  }


}


