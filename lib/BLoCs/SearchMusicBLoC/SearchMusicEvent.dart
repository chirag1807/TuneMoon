// SearchMusic

abstract class SearchMusicEvent{}

class SearchMusicInitialEvent extends SearchMusicEvent{}

class SearchMusicLoadingEvent extends SearchMusicEvent{}

class SearchMusicLoadedEvent extends SearchMusicEvent{
  String keyword;
  SearchMusicLoadedEvent(this.keyword);
}

class SearchMusicErrorEvent extends SearchMusicEvent{}

class SearchMusicEmptyTextFieldEvent extends SearchMusicEvent{
  String keyword;
  SearchMusicEmptyTextFieldEvent(this.keyword);
}