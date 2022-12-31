abstract class DBPlaylistState{}

class DBPlaylistLoadingState extends DBPlaylistState{}

class DBPlaylistLoadedState extends DBPlaylistState{
  final List<String> playlistTables;
  DBPlaylistLoadedState(this.playlistTables);
}

class DBPlaylistErrorState extends DBPlaylistState{
  final String errorMsg;
  DBPlaylistErrorState(this.errorMsg);
}