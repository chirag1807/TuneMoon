import 'package:tunemoon/model/SearchMusicDataClass.dart';

abstract class SongSuggestionState{}

class SongSuggestionLoadingState extends SongSuggestionState{}

class SongSuggestionLoadedState extends SongSuggestionState{
  List<SearchMusicDataClass> songs;
  SongSuggestionLoadedState(this.songs);
}

class SongSuggestionErrorState extends SongSuggestionState{
  String errorMsg;
  SongSuggestionErrorState(this.errorMsg);
}