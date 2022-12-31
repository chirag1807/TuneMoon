import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/SplashScreenState.dart';

class SplashScreenCubit extends Cubit<SplashScreenState>{
  SplashScreenCubit() : super(SplashScreenInitialState()){
    isAuthNull();
  }

  void isAuthNull(){
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if(firebaseAuth.currentUser == null){
      emit(SplashScreenNavigateState(0));
    }
    else{
      emit(SplashScreenNavigateState(1));
    }
  }
}