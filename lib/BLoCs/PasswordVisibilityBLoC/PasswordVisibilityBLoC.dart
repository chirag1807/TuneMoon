import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/PasswordVisibilityBLoC/PasswordVisibilityEvent.dart';
import 'package:tunemoon/BLoCs/PasswordVisibilityBLoC/PasswordVisibilityState.dart';

class PasswordVisibilityBloc extends Bloc<PasswordVisibilityEvent, PasswordVisibilityState>{
  PasswordVisibilityBloc() : super(PasswordInVisibleState()){

    on<PasswordInVisibleEvent>((event, emit) => emit(PasswordInVisibleState()));
    on<PasswordVisibleEvent>((event, emit) => emit(PasswordVisibleState()));
  }
}