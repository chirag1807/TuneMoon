abstract class BottomNavIndexState{}

class BottomNavIndexChangedState extends BottomNavIndexState{
  int index;
  BottomNavIndexChangedState(this.index);
}

class BottomNavIndexPersistState extends BottomNavIndexState{}