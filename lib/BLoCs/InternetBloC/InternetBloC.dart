import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/InternetBloC/InternetEvent.dart';
import 'package:tunemoon/BLoCs/InternetBloC/InternetState.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState>{
  StreamSubscription? connectivitySubscription;

  InternetBloc() : super(InternetInitialState()){
    Connectivity connectivity = Connectivity();

    on<InternetLostEvent>((event, emit) => emit(InternetLostState()));
    on<InternetGainedEvent>((event, emit) => emit(InternetGainedState()));

    connectivitySubscription = connectivity.onConnectivityChanged.listen((result) {
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        add(InternetGainedEvent());
      }
      else{
        add(InternetLostEvent());
      }
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }

}