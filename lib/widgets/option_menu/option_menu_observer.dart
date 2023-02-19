import 'dart:async';
import 'option_menu.dart';


abstract class OptionMenuObserver{

  void onItemSelect(OptionItemPosition option);

}


class OptionItemProvider{

  List<OptionMenuObserver> _observers;



  /*
  static final OptionItemProvider _singletonInstance = OptionItemProvider._internal();

  factory OptionItemProvider() => _singletonInstance;

  OptionItemProvider._internal(){
    _observers = List<OptionMenuObserver>();
  }
  */




  OptionItemProvider(){

    _observers = List<OptionMenuObserver>();
  }
  
  void initMenuState(){
    
  }

  void subscribe(OptionMenuObserver observer){
    _observers.add(observer);
  }

  void notify(OptionItemPosition itemPosition){
    _observers.forEach((itemObj) => itemObj.onItemSelect(itemPosition));
  }



  void dispose(OptionMenuObserver observer){
    for (var obj in _observers){
      if (obj == observer){
        _observers.remove(observer);
      }
    }

  }


}











