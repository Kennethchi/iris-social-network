import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'talent_type_chips_bloc.dart';
import 'package:iris_social_network/res/colors/rgb_colors.dart';
import 'package:iris_social_network/services/constants/constants.dart';




class TalentTypeChips extends StatefulWidget{

  List<String> label;
  ValueChanged<String> onItemSelected;

  TalentTypeChips({@required this.label, @required this.onItemSelected});

  _TalentTypeChipsState createState() => _TalentTypeChipsState();


  onSelected(String label){
    onItemSelected(label);
  }


}


class _TalentTypeChipsState extends State<TalentTypeChips> with AutomaticKeepAliveClientMixin<TalentTypeChips>{

  TalentTypeChipsBloc _bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = TalentTypeChipsBloc();
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
    return Wrap(
      children: widget.label.map((String label){
        return StreamBuilder(
          stream: _bloc.getTalentTypesStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ChoiceChip(
                selected: snapshot.hasData && snapshot.data == label? true: false,
                selectedColor: CupertinoTheme.of(context).primaryColor,
                //backgroundColor: RGBColors.light_grey_level_2,
                //disabledColor: RGBColors.light_grey_level_2,
                label: Text(label, style: TextStyle(color: RGBColors.white),),
                onSelected: (bool selected){
                  _bloc.getTalentTypeSink.add(label);
                  widget.onSelected(label);
                },
              ),
            );

          },
        );
      }).toList(),
    );
  }


}