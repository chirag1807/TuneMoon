abstract class RecentMusicState{}

class RecentMusicLoadingState extends RecentMusicState{}

class RecentMusicLoadedState extends RecentMusicState{
  List? songs;
  RecentMusicLoadedState(this.songs);
}

class RecentMusicErrorState extends RecentMusicState{
  String errorMsg;
  RecentMusicErrorState(this.errorMsg);
}