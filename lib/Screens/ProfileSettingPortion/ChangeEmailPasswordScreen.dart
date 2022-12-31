import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/PasswordVisibilityBLoC/PasswordVisibilityBLoC.dart';
import 'package:tunemoon/BLoCs/PasswordVisibilityBLoC/PasswordVisibilityEvent.dart';
import 'package:tunemoon/BLoCs/PasswordVisibilityBLoC/PasswordVisibilityState.dart';

class ChangeEmailPasswordScreen extends StatefulWidget {
  const ChangeEmailPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangeEmailPasswordScreen> createState() => _ChangeEmailPasswordScreenState();
}

class _ChangeEmailPasswordScreenState extends State<ChangeEmailPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool passwordObscured = true;
  bool passwordObscured1 = true;
  @override
  void initState() {
    super.initState();
    emailController.text = firebaseAuth.currentUser!.email.toString();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordVisibilityBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xff0A0E3D),
        body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text("Change Email and Password", style: TextStyle(color: Colors.white, fontSize: 25),),
                    Image.asset('assets/images/logo.png'),
                    emailIdTextField(),
                    oldPasswordTextField(),
                    newPasswordTextField(),
                    updateButton()
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }

  Widget emailIdTextField(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.text,
        cursorColor: const Color(0xff0A0E3D),
        decoration: InputDecoration(
          hintText: "Enter the new Email Id",
          prefixIcon: const Icon(
            Icons.email,
            color: Color(0xff0A0E3D),
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Color(0xff0A0E3D), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xfff9f295), width: 2.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Widget oldPasswordTextField(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
        builder: (context, state){
          if(state is PasswordVisibleState){
            passwordObscured = false;
          }
          else{
            passwordObscured = true;
          }
          return TextField(
            controller: oldPasswordController,
            keyboardType: TextInputType.text,
            obscureText: passwordObscured,
            cursorColor: const Color(0xff0A0E3D),
            decoration: InputDecoration(
              hintText: "Enter the Old Password",
              prefixIcon: const Icon(
                Icons.lock,
                color: Color(0xff0A0E3D),
              ),
              suffixIcon: InkWell(
                onTap: (){
                  if(state is PasswordInVisibleState){
                    BlocProvider.of<PasswordVisibilityBloc>(context).add(PasswordVisibleEvent());
                  }
                  else{
                    BlocProvider.of<PasswordVisibilityBloc>(context).add(PasswordInVisibleEvent());
                  }
                },
                child: Icon(
                  passwordObscured?
                  Icons.visibility_off:
                  Icons.visibility,
                  color: const Color(0xff0A0E3D),
                ),
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Color(0xff0A0E3D), width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xfff9f295), width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget newPasswordTextField(){
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
          builder: (context, state) {
            if (state is PasswordVisibleState) {
              passwordObscured1 = false;
            }
            else {
              passwordObscured1 = true;
            }
            return TextField(
              controller: newPasswordController,
              keyboardType: TextInputType.text,
              obscureText: passwordObscured1,
              cursorColor: const Color(0xff0A0E3D),
              decoration: InputDecoration(
                hintText: "Enter the New Password",
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(0xff0A0E3D),
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    if(state is PasswordInVisibleState){
                      BlocProvider.of<PasswordVisibilityBloc>(context).add(PasswordVisibleEvent());
                    }
                    else{
                      BlocProvider.of<PasswordVisibilityBloc>(context).add(PasswordInVisibleEvent());
                    }
                  },
                  child: Icon(
                    passwordObscured1 ?
                    Icons.visibility_off :
                    Icons.visibility,
                    color: const Color(0xff0A0E3D),
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      20.0),
                  borderSide: const BorderSide(
                      color: Color(0xff0A0E3D),
                      width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color(0xfff9f295),
                      width: 2.0),
                  borderRadius: BorderRadius.circular(
                      20.0),
                ),
              ),
            );
          },
        )
    );
  }

  Widget updateButton(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xfff9f295),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
          onPressed: (){
            firebaseAuth.currentUser!.reauthenticateWithCredential(
                EmailAuthProvider.credential(
                    email: firebaseAuth.currentUser!.email.toString(),
                    password: oldPasswordController.text)
            ).then((value) {
              firebaseAuth.currentUser!.updateEmail(emailController.text)
                  .then((value) {
                firebaseAuth.currentUser!.updatePassword(newPasswordController.text)
                    .then((value) {
                  print("done pass");
                  Timer(const Duration(seconds: 1), () {
                    Navigator.pop(context);
                  });
                });
                print("done");
              })
                  .onError((error, stackTrace) => null);
            })
                .onError((error, stackTrace) => null);
          },
          child: const Text("Update", style: TextStyle(color: Colors.black, fontSize: 25),)
      ),
    );
  }
}
