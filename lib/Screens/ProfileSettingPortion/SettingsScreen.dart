import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunemoon/Screens/ProfileSettingPortion/ChangeEmailPasswordScreen.dart';
import 'package:tunemoon/Screens/ProfileSettingPortion/ChangeUnameArtistScreen.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({Key? key}) : super(key: key);

  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

class _SettingscreenState extends State<Settingscreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController artistsController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String userName = "";
  List<String> selectedArtists = [];
  String email = "";
  String uid = "";
  bool isEditable = false;
  @override
  void initState(){
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      userName = sp.getString("userName")!;
      selectedArtists = sp.getStringList("selectedArtists")!;
      email = firebaseAuth.currentUser!.email.toString();
      uid = firebaseAuth.currentUser!.uid;
      nameController.text = userName;
      emailController.text = email;
      artistsController.text = selectedArtists.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontSize: 25),),
        backgroundColor: const Color(0xff0A0E3D),
        automaticallyImplyLeading: false,
        shape: const Border(
            bottom: BorderSide(
                color: Color(0xfff9f295),
                width: 1.0
            )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              tooltip: "Logout",
                onPressed: (){
                  showDialog(context: context, builder: (content) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      backgroundColor: const Color(0xfff9f295),
                      title: const Text("Logout", style: TextStyle(color: Color(0xff0A0E3D), fontSize: 25),),
                      content: const Text("Are You Sure to Want to Logout?", style: TextStyle(color: Color(0xff0A0E3D), fontSize: 17),),
                      actions: [
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("No", style: TextStyle(color: Color(0xff0A0E3D), fontSize: 20),)
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                              firebaseAuth.signOut()
                                  .then((value) {
                                Timer(const Duration(milliseconds: 250), () {
                                  // Navigator.pushReplacement(context,
                                  //     PageRouteBuilder(
                                  //         transitionDuration: const Duration(milliseconds: 500),
                                  //         transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                                  //           animation = CurvedAnimation(parent: animation, curve: Curves.easeInCirc);
                                  //           return SlideTransition(
                                  //             position: Tween(
                                  //                 begin: const Offset(0.0, 1.0),
                                  //                 end: const Offset(0.0, 0.0))
                                  //                 .animate(animation),
                                  //             child: child,
                                  //           );
                                  //         },
                                  //         pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                  //           return const LoginScreen();
                                  //         }));
                                  SystemNavigator.pop();
                                });
                              })
                                  .onError((error, stackTrace) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString(),
                                      style: const TextStyle(fontSize: 22, color: Colors.white),), backgroundColor: Colors.red,));
                              });
                            },
                            child: const Text("Yes", style: TextStyle(color: Color(0xff0A0E3D), fontSize: 20),)
                        ),
                      ],
                    );
                  });
                },
                icon: const Icon(Icons.logout, color: Color(0xfff9f295), size: 40,)),
          )
        ],
      ),
      backgroundColor: const Color(0xff0A0E3D),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const Text("Your Profile", style: TextStyle(fontSize: 30, color: Colors.white),),
                Image.asset('assets/images/logo.png'),
                userNameTitle(),
                userNameTextField(),
                emailIdTitle(),
                emailIdTextField(),
                favArtistsTitle(),
                favArtistsTextField(),
                changeEmailPasswordButton(),
                changeUnameArtistButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userNameTitle(){
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      width: double.infinity,
      alignment: Alignment.topLeft,
      // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: const Text("Username", style: TextStyle(fontSize: 25, color: Colors.white),),
    );
  }

  Widget userNameTextField(){
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      child: TextField(
        controller: nameController,
        readOnly: !isEditable,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Color(0xff0A0E3D), width: 1.0),
            ),
            filled: true,
            fillColor: Colors.white
        ),
      ),
    );
  }

  Widget emailIdTitle(){
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      width: double.infinity,
      alignment: Alignment.topLeft,
      child: const Text("Email", style: TextStyle(fontSize: 25, color: Colors.white),),
    );
  }

  Widget emailIdTextField(){
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      child: TextField(
        controller: emailController,
        readOnly: !isEditable,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Color(0xff0A0E3D), width: 1.0),
            ),
            filled: true,
            fillColor: Colors.white
        ),
      ),
    );
  }

  Widget favArtistsTitle(){
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      width: double.infinity,
      alignment: Alignment.topLeft,
      child: const Text("Fav Artists", style: TextStyle(fontSize: 25, color: Colors.white),),
    );
  }

  Widget favArtistsTextField(){
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      child: TextField(
        controller: artistsController,
        readOnly: !isEditable,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Color(0xff0A0E3D), width: 1.0),
            ),
            filled: true,
            fillColor: Colors.white
        ),
      ),
    );
  }

  Widget changeEmailPasswordButton(){
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
      width: double.infinity,
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: (){
          Navigator.push(context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                    animation = CurvedAnimation(parent: animation, curve: Curves.linear);
                    return SlideTransition(
                      position: Tween(
                          begin: const Offset(1.0, 0.0),
                          end: const Offset(0.0, 0.0))
                          .animate(animation),
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return const ChangeEmailPasswordScreen();
                  })
          );
        },
        child: const Text("Update Email and Password", style: TextStyle(color: Colors.white, fontSize: 17),),
      ),
    );
  }

  Widget changeUnameArtistButton(){
    return Container(
      margin: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
      width: double.infinity,
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: (){
          Navigator.pushReplacement(context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                    animation = CurvedAnimation(parent: animation, curve: Curves.linear);
                    return SlideTransition(
                      position: Tween(
                          begin: const Offset(1.0, 0.0),
                          end: const Offset(0.0, 0.0))
                          .animate(animation),
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return const ChangeUnameArtistScreen();
                  })
          );
        },
        child: const Text("Update Username and Artists", style: TextStyle(color: Colors.white, fontSize: 17),),
      ),
    );
  }
}
