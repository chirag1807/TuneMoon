// SearchMusic

import 'package:tunemoon/model/SearchMusicDataClass.dart';

abstract class SearchMusicState{}

class SearchMusicInitialState extends SearchMusicState{}

class SearchMusicLoadingState extends SearchMusicState{}

class SearchMusicLoadedState extends SearchMusicState{
  List<SearchMusicDataClass> musics;
  SearchMusicLoadedState(this.musics);
}

class SearchMusicErrorState extends SearchMusicState{
  String errorMsg;
  SearchMusicErrorState(this.errorMsg);
}

class SearchMusicTextFieldEmptyState extends SearchMusicState{
  String keyword;
  SearchMusicTextFieldEmptyState(this.keyword);
}