import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/SelectArtistBLoC/SelectArtistEvent.dart';
import 'package:tunemoon/BLoCs/SelectArtistBLoC/SelectArtistState.dart';

class SelectArtistBLoC extends Bloc<SelectArtistEvent, SelectArtistState>{
  SelectArtistBLoC() : super(SelectArtistUnCheckedState(0)){
    on<SelectArtistCheckedEvent>((event, emit) {
      print("object3");
      emit(SelectArtistCheckedState(event.index));
    });

    on<SelectArtistUnCheckedEvent>((event, emit) {
      print("object4");
      emit(SelectArtistUnCheckedState(event.index));
    });
  }

}