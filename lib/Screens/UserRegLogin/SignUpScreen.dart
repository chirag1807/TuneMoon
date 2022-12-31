import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingBloC.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingEvent.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingState.dart';
import 'package:tunemoon/BLoCs/PasswordVisibilityBLoC/PasswordVisibilityBLoC.dart';
import 'package:tunemoon/BLoCs/PasswordVisibilityBLoC/PasswordVisibilityEvent.dart';
import 'package:tunemoon/BLoCs/PasswordVisibilityBLoC/PasswordVisibilityState.dart';
import 'package:tunemoon/Screens/UserRegLogin/LoginScreen.dart';
import 'package:tunemoon/Screens/UserRegLogin/SelectArtistScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passwordObscured = true;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PasswordVisibilityBloc()),
        BlocProvider(create: (context) => IsLoadingBLoC())
      ],
      child: Scaffold(
        backgroundColor: const Color(0xff0A0E3D),
        body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xff0A0E3D),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    signUpTitle(),
                    Image.asset('assets/images/logo.png'),
                    userNameTextField(),
                    emailIdTextField(),
                    passwordTextField(),
                    signUpButton(),
                    alreadyHaveAccount(),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }

  Widget signUpTitle(){
    return const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text("Sign Up", style: TextStyle(fontSize: 50, color: Colors.white),),
    );
  }

  Widget userNameTextField(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: nameController,
        decoration: InputDecoration(
            hintText: "UserName",
            prefixIcon: const Icon(
              Icons.account_circle,
              color: Color(0xff0A0E3D),
            ),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            )
        ),
      ),
    );
  }

  Widget emailIdTextField(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: "Email Id",
            prefixIcon: const Icon(
              Icons.email,
              color: Color(0xff0A0E3D),
            ),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            )
        ),
      ),
    );
  }

  Widget passwordTextField(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
        builder: (context, state) {
          if (state is PasswordVisibleState) {
            passwordObscured = false;
          }
          else {
            passwordObscured = true;
          }
          return TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            obscureText: passwordObscured,
            decoration: InputDecoration(
                hintText: "Password",
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
                    passwordObscured ?
                    Icons.visibility_off :
                    Icons.visibility,
                    color: const Color(0xff0A0E3D),
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                )
            ),
          );
        },
      ),
    );
  }

  Widget signUpButton(){
    return BlocBuilder<IsLoadingBLoC, IsLoadingState>(
      builder: (context, state) {
        if (state is IsLoadingFalseState) {
          isLoading = false;
        }
        else {
          isLoading = true;
        }
        return Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15.0),
          child: ElevatedButton(
              onPressed: () async {
                BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingTrueEvent());
                SharedPreferences sp = await SharedPreferences
                    .getInstance();
                sp.setString(
                    "userName", nameController.text.toString());
                firebaseAuth.createUserWithEmailAndPassword(
                    email: emailController.text.toString(),
                    password: passwordController.text
                        .toString())
                    .then(
                        (value) {
                      BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingFalseEvent());
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                          const SnackBar(content: Text(
                              "Account Created Successfully"),
                            backgroundColor: Colors.green,)
                      );
                      Timer(const Duration(seconds: 2), () {
                        Navigator.pushReplacement(context,
                            PageRouteBuilder(
                                transitionDuration: const Duration(
                                    milliseconds: 500),
                                transitionsBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<
                                        double> secondaryAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.linear);
                                  return SlideTransition(
                                    position: Tween(
                                        begin: const Offset(
                                            1.0, 0.0),
                                        end: const Offset(
                                            0.0, 0.0))
                                        .animate(animation),
                                    child: child,
                                  );
                                },
                                pageBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<
                                        double> secondaryAnimation) {
                                  return const SelectArtistScreen();
                                })
                        );
                      });
                    })
                    .onError((error, stackTrace) {
                  BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingFalseEvent());
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.toString()),
                        backgroundColor: Colors.red,));
                });
              },
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xfff9f295),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  )
              ),
              child: isLoading == true ?
              const CircularProgressIndicator(
                color: Colors.black,) :
              const Text("Sign Up", style: TextStyle(
                  fontFamily: 'KaushanScript',
                  color: Colors.black,
                  fontSize: 25),)
          ),
        );
      },
    );
  }

  Widget alreadyHaveAccount(){
    return Container(
      padding: const EdgeInsets.only(right: 15.0),
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: (){
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
                    return const LoginScreen();
                  })
          );
        },
        child: const Text("Already have an Account?",
          style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.end,),
      ),
    );
  }
}
