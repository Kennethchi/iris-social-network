import 'package:iris_social_network/services/constants/constants.dart';
import 'dart:async';



abstract class TalentTypeChipsBlocBlueprint{
  void dispose();
}


class TalentTypeChipsBloc implements TalentTypeChipsBlocBlueprint{

  StreamController<String> _talentTypesStreamController = StreamController<String>.broadcast();
  Stream<String> get getTalentTypesStream => _talentTypesStreamController.stream;
  StreamSink<String> get getTalentTypeSink => _talentTypesStreamController.sink;



  @override
  void dispose() {
    // TODO: implement dispose


    _talentTypesStreamController?.close();
  }
}