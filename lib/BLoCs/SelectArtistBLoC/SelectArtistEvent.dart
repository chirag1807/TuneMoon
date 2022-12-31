abstract class SelectArtistEvent{}

class SelectArtistCheckedEvent extends SelectArtistEvent{
  int index;
  SelectArtistCheckedEvent(this.index);
}

class SelectArtistUnCheckedEvent extends SelectArtistEvent{
  int index;
  SelectArtistUnCheckedEvent(this.index);
}