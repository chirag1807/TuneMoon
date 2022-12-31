abstract class SplashScreenState{}

class SplashScreenInitialState extends SplashScreenState{}

class SplashScreenNavigateState extends SplashScreenState{
  int i;
  SplashScreenNavigateState(this.i);
}