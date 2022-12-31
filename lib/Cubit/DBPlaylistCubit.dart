import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/DBPlaylistState.dart';
import 'package:tunemoon/SQFlite/DatabaseHelper.dart';

class DBPlaylistCubit extends Cubit<DBPlaylistState>{
  DBPlaylistCubit() : super(DBPlaylistLoadingState()){
    fetchPlaylists();
  }

  List<String> tables = [];
  void fetchPlaylists() async{
    try{
      tables = await DatabaseHelper.getTables("");
      print(tables);
      emit(DBPlaylistLoadedState(tables));
    }
    catch(err){
      emit(DBPlaylistErrorState(err.toString()));
    }
  }
}