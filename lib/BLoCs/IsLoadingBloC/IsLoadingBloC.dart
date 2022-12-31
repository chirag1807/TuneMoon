import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingBloC.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingEvent.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingState.dart';

class IsLoadingBLoC extends Bloc<IsLoadingEvent, IsLoadingState>{
  IsLoadingBLoC() : super(IsLoadingFalseState()){
    on<IsLoadingTrueEvent>((event, emit) => emit(IsLoadingTrueState()));
    on<IsLoadingFalseEvent>((event, emit) => emit(IsLoadingFalseState()));
  }
}