import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/BottomNavIndexBLoC/BottomNavIndexEvent.dart';
import 'package:tunemoon/BLoCs/BottomNavIndexBLoC/BottomNavIndexState.dart';

class BottomNavIndexBLoC extends Bloc<BottomNavIndexEvent, BottomNavIndexState>{
  BottomNavIndexBLoC() : super(BottomNavIndexPersistState()){
    on<BottomNavIndexPersistEvent>((event, emit) => emit(BottomNavIndexPersistState()));
    on<BottomNavIndexChangedEvent>((event, emit) => emit(BottomNavIndexChangedState(event.index)));
  }
}

// class BottomNavIndexCubit extends Cubit<BottomNavIndexState>{
//   BottomNavIndexCubit() : super(BottomNavIndexPersistState()){
//
//   }
// }