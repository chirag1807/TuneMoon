abstract class ChangeArtistEvent{}

class ChangeArtistCheckedEvent extends ChangeArtistEvent{
  int index;
  ChangeArtistCheckedEvent(this.index);
}

class ChangeArtistUnCheckedEvent extends ChangeArtistEvent{
  int index;
  ChangeArtistUnCheckedEvent(this.index);
}

class ChangeArtistLoadingEvent extends ChangeArtistEvent{}

class ChangeArtistLoadedEvent extends ChangeArtistEvent{

}