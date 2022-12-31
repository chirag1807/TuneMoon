abstract class SelectArtistState{}

class SelectArtistCheckedState extends SelectArtistState{
  int index;
  SelectArtistCheckedState(this.index);
}

class SelectArtistUnCheckedState extends SelectArtistState{
  int index;
  SelectArtistUnCheckedState(this.index);
}