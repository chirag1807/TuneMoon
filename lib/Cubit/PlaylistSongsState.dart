abstract class PlaylistSongsState{}

class PlaylistSongsLoadingState extends PlaylistSongsState{}

class PlaylistSongsLoadedState extends PlaylistSongsState{
  final List playlistSongs;
  PlaylistSongsLoadedState(this.playlistSongs);
}

class PlaylistSongsErrorState extends PlaylistSongsState{
  final String errorMsg;
  PlaylistSongsErrorState(this.errorMsg);
}