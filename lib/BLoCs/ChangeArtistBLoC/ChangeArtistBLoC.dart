import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunemoon/BLoCs/ChangeArtistBLoC/ChangeArtistEvent.dart';
import 'package:tunemoon/BLoCs/ChangeArtistBLoC/ChangeArtistState.dart';

class ChangeArtistBLoC extends Bloc<ChangeArtistEvent, ChangeArtistState>{
  List selectArtist;
  ChangeArtistBLoC(this.selectArtist) : super(ChangeArtistLoadingState()){
    on<ChangeArtistLoadedEvent>((event, emit) async {
      try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      List<String> selectedArtists = sp.getStringList("selectedArtists")!;
      for(int i = 0 ; i < selectedArtists.length ; i++){
        for(int j = 0; j < selectArtist.length ; j++){
          if(selectArtist[j].artistName == selectedArtists[i]){
            selectArtist[j].isChecked = true;
            break;
          }
        }
      }
        emit(ChangeArtistLoadedState(selectArtist, selectedArtists));
      }
      catch(err){
        emit(ChangeArtistErrorState(err.toString()));
      }
    });

    on<ChangeArtistCheckedEvent>((event, emit) async {
      print("object3");
      SharedPreferences sp = await SharedPreferences.getInstance();
      List selectedArtists = sp.getStringList("selectedArtists")!;
      for(int i = 0 ; i < selectedArtists.length ; i++){
        for(int j = 0; j < selectArtist.length ; j++){
          if(selectArtist[j].artistName == selectedArtists[i]){
            selectArtist[j].isChecked = true;
            break;
          }
        }
      }
      emit(ChangeArtistCheckedState(event.index));
    });

    on<ChangeArtistUnCheckedEvent>((event, emit) {
      print("object4");
      emit(ChangeArtistUnCheckedState(event.index));
    });

  }
}