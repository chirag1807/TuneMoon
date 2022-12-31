import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunemoon/Cubit/ChangeUnameState.dart';

class ChangeUnameCubit extends Cubit<ChangeUnameState> {
  ChangeUnameCubit() : super(ChangeUnameLoadingState()) {
    fetchUname();
  }

  void fetchUname() async {
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      String userName = sp.getString("userName") ?? "Enthusiast";
      emit(ChangeUnameLoadedState(userName));
    }
    catch(err){
      emit(ChangeUnameErrorState(err.toString()));
    }
  }

}