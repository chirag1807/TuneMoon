import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/GreetingState.dart';

class GreetingCubit extends Cubit<GreetingState>{
  GreetingCubit() : super(GreetingInitialState()){
    showGreetingMsg();
  }

  void showGreetingMsg(){
    int hour;
    hour = DateTime.now().hour;
    if (hour < 12) {
      emit(GreetingMsgState("Morning"));
    }
    else if (hour < 17) {
      emit(GreetingMsgState("Afternoon"));
    }
    else{
      emit(GreetingMsgState("Evening"));
    }
  }
}