import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/RecentMusicState.dart';
import 'package:tunemoon/SQFlite/DatabaseHelperRecentPlay.dart';

class RecentMusicCubit extends Cubit<RecentMusicState>{
  RecentMusicCubit() : super(RecentMusicLoadingState()){
    fetchRecentSongs();
  }

  List? songs;
  void fetchRecentSongs() async {
    try{
      songs = await DatabaseHelperRecentPlay.getAllSongs();
      int songsLength = songs?.length ?? 0;
      if(songsLength > 10){
        List<String> toBeDeletedMusic = [];
        for(int i = 0 ; i <= songsLength-11 ; i++){
          toBeDeletedMusic.add(songs![i].sId);
        }
        DatabaseHelperRecentPlay.deleteBulkSong(toBeDeletedMusic);
      }
      else{
        print("less than 10");
      }
      emit(RecentMusicLoadedState(songs));
    }
    catch(err){
      emit(RecentMusicErrorState(err.toString()));
    }
  }
}