import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'interest_model.dart';
import 'interests_picker_bloc.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/constants/constants.dart';
import 'constants.dart';
import 'interests_picker_bloc.dart';
import 'interests_picker_bloc_provider.dart';
import 'interests_picker_view.dart';




class InterestsPicker extends StatefulWidget{

  _InterestsPickerState createState() => _InterestsPickerState();

}


class _InterestsPickerState extends State<InterestsPicker> with AutomaticKeepAliveClientMixin<InterestsPicker>{

  InterestsPickerBloc _bloc;

  List<String> interestsList;

  List<InterestModel> interestsModelList = List<InterestModel>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = InterestsPickerBloc();

    interestsList = getInterestsList();

    for(int index = 0; index < interestsList.length; ++index){
      interestsModelList.add(InterestModel(
          name: interestsList[index],
          selected: false
      ));
    }

    _bloc.addInterestModelListToStream(interestsModelList);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InterestsPickerBlocProvider(
      bloc: _bloc,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InterestsPickerView(),
      ),
    );
  }


}