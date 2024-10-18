// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';


// ignore: must_be_immutable
class SwitchEventStates extends Equatable{
  bool isSwitchOn;
  double sliderValue;

SwitchEventStates({
this.isSwitchOn = false,
this.sliderValue = 10
});


SwitchEventStates copyWith({bool? isSwitchOn, double? sliderValue}){
  return SwitchEventStates(
    
    isSwitchOn: isSwitchOn ?? this.isSwitchOn,
    sliderValue: sliderValue ?? this.sliderValue,
  
  );
}

@override
  List<Object?> get props => [isSwitchOn, sliderValue];
}