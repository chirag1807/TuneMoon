import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunemoon/Cubit/SplashScreenCubit.dart';
import 'package:tunemoon/Cubit/SplashScreenState.dart';
import 'package:tunemoon/Screens/BottomNavPortion/BottomNavBar.dart';
import 'package:tunemoon/Screens/UserRegLogin/LoginScreen.dart';
import 'package:tunemoon/Screens/UserRegLogin/SelectArtistScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<bool> artistSelected() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('isArtistSelected') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashScreenCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xff0A0E3D),
        body: BlocBuilder<SplashScreenCubit, SplashScreenState>(
          builder: (context, state){
            if(state is SplashScreenNavigateState){
              if(state.i == 0){
                authNullNavigator();
              }
              if(state.i == 1){
                authNotNullNavigator();
              }
            }
          return Container(
            color: const Color(0xff0A0E3D),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                splashScreenRow()
              ],
            ),
          );
          },
        ),
      ),
    );
  }

  Widget splashScreenRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/logo.png',),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("TuneMoon",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600
              ),),
            Text("Let Music Speak",
              style: TextStyle(
                  color: Color(0xfff9f295),
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'KaushanScript'
              ),)
          ],
        )
      ],
    );
  }

  void authNullNavigator(){
    Timer(const Duration(seconds: 3),
            () =>
            Navigator.pushReplacement(context,
                PageRouteBuilder(
                    transitionDuration: const Duration(seconds: 1),
                    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                      animation = CurvedAnimation(parent: animation, curve: Curves.linear);
                      return Align(
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ));
                    },
                    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                      return const LoginScreen();
                    })
            )
    );
  }

  void authNotNullNavigator(){
    Timer(const Duration(seconds: 2),
            () {
          artistSelected().then((value) => value==true?
          Navigator.pushReplacement(context,
              PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 1),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                    animation = CurvedAnimation(parent: animation, curve: Curves.easeInCirc);
                    return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ));
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return const BottomNavBar();
                  })) :
          Navigator.pushReplacement(context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                    animation = CurvedAnimation(parent: animation, curve: Curves.easeInCirc);
                    return SlideTransition(
                      position: Tween(
                          begin: const Offset(1.0, 0.0),
                          end: const Offset(0.0, 0.0))
                          .animate(animation),
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return const SelectArtistScreen();
                  }))
          );
        }
    );
  }
}