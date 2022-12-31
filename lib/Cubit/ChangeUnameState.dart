abstract class ChangeUnameState{}

class ChangeUnameLoadingState extends ChangeUnameState{}

class ChangeUnameLoadedState extends ChangeUnameState{
  String uname;
  ChangeUnameLoadedState(this.uname);
}

class ChangeUnameErrorState extends ChangeUnameState{
  String errorMsg;
  ChangeUnameErrorState(this.errorMsg);
}