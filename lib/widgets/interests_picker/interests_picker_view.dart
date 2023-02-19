import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'interest_model.dart';
import 'interests_picker_bloc.dart';
import 'interests_picker_bloc_provider.dart';






class InterestsPickerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    InterestsPickerBlocProvider _provider = InterestsPickerBlocProvider.of(context);
    InterestsPickerBloc _bloc = InterestsPickerBlocProvider.of(context).bloc;
    CupertinoThemeData _themeData = CupertinoTheme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = 0.125;


    return Container(
      child: StreamBuilder<List<InterestModel>>(
          stream: _bloc.getInterestModelListStream,
          builder: (context, AsyncSnapshot<List<InterestModel>> snapshot) {

            if (snapshot.hasData){
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.125 * 0.5)
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.all(screenWidth * scaleFactor * 0.5),
                        child: Text("Edit Interests",
                          style: TextStyle(
                              color: _themeData.primaryColor,
                              fontSize: Theme.of(context).textTheme.subhead.fontSize
                          ),
                        ),
                      ),


                      Wrap(
                        alignment: WrapAlignment.center,
                        children: snapshot.data.map((InterestModel interestModel){
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ChoiceChip(
                              selected: snapshot.hasData && interestModel.selected? true: false,
                              selectedColor: CupertinoTheme.of(context).primaryColor,
                              label: Text(interestModel.name, style: TextStyle(color: Colors.white),),
                              onSelected: (bool selected){

                                int index = snapshot.data.indexOf(interestModel);
                                snapshot.data[index].selected = selected;

                                _bloc.addInterestModelListToStream(snapshot.data);

                              },
                            ),
                          );
                        }).toList(),
                      ),




                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Flexible(
                            flex: 50,
                            fit: FlexFit.tight,
                            child: CupertinoButton(
                                child: Text("Cancel", style: TextStyle(
                                    color: _themeData.primaryColor
                                ),),
                                onPressed: (){
                                  Navigator.pop(context);
                                }
                            ),
                          ),

                          /*
                          Flexible(
                              flex: 50,
                              fit: FlexFit.tight,
                              child: SaveProfileAudioButton()
                          ),
                          */
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            else{
              return Container();
            }

          }
      ),
    );
  }
}
