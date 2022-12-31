abstract class BottomNavIndexEvent{}

class BottomNavIndexChangedEvent extends BottomNavIndexEvent {
  int index;
  BottomNavIndexChangedEvent(this.index);
}

class BottomNavIndexPersistEvent extends BottomNavIndexEvent{}