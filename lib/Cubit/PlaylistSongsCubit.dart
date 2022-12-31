import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/PlaylistSongsState.dart';
import 'package:tunemoon/SQFlite/DatabaseHelper.dart';
import 'package:tunemoon/SQFlite/SQFlitePlaylistDataClass.dart';

class PlaylistSongsCubit extends Cubit<PlaylistSongsState>{
  String playlistName;
  PlaylistSongsCubit(this.playlistName) : super(PlaylistSongsLoadingState()){
    fetchSongsFromPlaylist();
  }


  List<SQFlitePlaylistDataClass> songs = [];
  void fetchSongsFromPlaylist() async {
    try{
      songs = await DatabaseHelper.getAllSongs(playlistName) ?? [];
      print(songs);
      emit(PlaylistSongsLoadedState(songs));
    }
    catch(err){
      emit(PlaylistSongsErrorState(err.toString()));
    }
  }
}