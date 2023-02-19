import 'dart:async';
import 'option_menu.dart';



abstract class _OptionMenuBlocBlueprint{

  void dispose();

}



class OptionMenuBloc implements _OptionMenuBlocBlueprint{


  StreamController<bool> _buildCompleteStreamController = StreamController<bool>.broadcast();
  Stream<bool> get getBuildCompleteStream => _buildCompleteStreamController.stream;
  StreamSink<bool> get _getBuildCompleteSink => _buildCompleteStreamController.sink;


  StreamController<OptionItemPosition> _itemSelectedStreamController = StreamController<OptionItemPosition>.broadcast();
  Stream<OptionItemPosition> get getItemSelectedStream => _itemSelectedStreamController.stream;
  StreamSink<OptionItemPosition> get _getItemSelectedSink => _itemSelectedStreamController.sink;



  void addBuildComplete(bool isBuildComplete){
    _getBuildCompleteSink.add(isBuildComplete);
  }

  void addItemSelected(OptionItemPosition itemSelected){
    _getItemSelectedSink.add(itemSelected);
  }



  @override
  void dispose() {
    _buildCompleteStreamController?.close();
  }







}