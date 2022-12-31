import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/BottomNavIndexBLoC/BottomNavIndexBLoC.dart';
import 'package:tunemoon/BLoCs/BottomNavIndexBLoC/BottomNavIndexEvent.dart';
import 'package:tunemoon/BLoCs/BottomNavIndexBLoC/BottomNavIndexState.dart';
import 'package:tunemoon/Screens/BottomNavPortion/HomeScreen.dart';
import 'package:tunemoon/Screens/BottomNavPortion/DeviceAudioScreen.dart';
import 'package:tunemoon/Screens/BottomNavPortion/WebAudioScreen.dart';
import 'package:tunemoon/Screens/ProfileSettingPortion/SettingsScreen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  int myIndex = 1;
  List widgetList = [
    const HomeScreen(),
    const WebAudioScreen(),
    const DeviceAudioScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavIndexBLoC(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
              ),
              const Text(
                "TuneMoon",
                style: TextStyle(color: Colors.white, fontSize: 25),
              )
            ],
          ),
          backgroundColor: const Color(0xff0A0E3D),
          automaticallyImplyLeading: false,
          shape: const Border(
              bottom: BorderSide(
            color: Color(0xfff9f295),
            width: 1.0,
          )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {
                    Timer(const Duration(milliseconds: 250), () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              transitionsBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                  Widget child) {
                                animation = CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInCirc);
                                return SlideTransition(
                                  position: Tween(
                                          begin: const Offset(0.0, -1.0),
                                          end: const Offset(0.0, 0.0))
                                      .animate(animation),
                                  child: child,
                                );
                              },
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return const Settingscreen();
                              }));
                    });
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Color(0xfff9f295),
                    size: 40,
                  )),
            )
          ],
        ),
        body: BlocBuilder<BottomNavIndexBLoC, BottomNavIndexState>(
            builder: (context, state) {
          if (state is BottomNavIndexChangedState) {
            myIndex = state.index;
          }
          return widgetList[myIndex];
        }),
        bottomNavigationBar:
            BlocBuilder<BottomNavIndexBLoC, BottomNavIndexState>(
                builder: (context, state) {
          if (state is BottomNavIndexChangedState) {
            myIndex = state.index;
          }
          return Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xfff9f295)))),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xff0A0E3D),
              showUnselectedLabels: false,
              selectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              elevation: 10,
              onTap: (index) {
                BlocProvider.of<BottomNavIndexBLoC>(context)
                    .add(BottomNavIndexChangedEvent(index));
              },
              currentIndex: myIndex,
              items: [
                BottomNavigationBarItem(
                    backgroundColor: const Color(0xff0A0E3D),
                    icon: Image.asset(
                      'assets/images/home.png',
                      width: 35,
                      height: 35,
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                  backgroundColor: const Color(0xff0A0E3D),
                  icon: Image.asset(
                    'assets/images/web-audio.png',
                    width: 35,
                    height: 35,
                  ),
                  label: "Web",
                ),
                BottomNavigationBarItem(
                    backgroundColor: const Color(0xff0A0E3D),
                    icon: Image.asset(
                      'assets/images/device-audio.png',
                      width: 35,
                      height: 35,
                    ),
                    label: "Device"),
              ],
            ),
          );
        }),
      ),
    );
  }
}
