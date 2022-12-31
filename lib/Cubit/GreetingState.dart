abstract class GreetingState{}

class GreetingInitialState extends GreetingState{}

class GreetingMsgState extends GreetingState{
  String greetingMsg;
  GreetingMsgState(this.greetingMsg);
}