abstract class ChangeArtistState{}

class ChangeArtistCheckedState extends ChangeArtistState{
  int index;
  ChangeArtistCheckedState(this.index);
}

class ChangeArtistUnCheckedState extends ChangeArtistState{
  int index;
  ChangeArtistUnCheckedState(this.index);
}

class ChangeArtistLoadingState extends ChangeArtistState{}

class ChangeArtistLoadedState extends ChangeArtistState{
  List selectArtists;
  List<String> selectedArtists;
  ChangeArtistLoadedState(this.selectArtists, this.selectedArtists);
}

class ChangeArtistErrorState extends ChangeArtistState{
  String errorMsg;
  ChangeArtistErrorState(this.errorMsg);
}