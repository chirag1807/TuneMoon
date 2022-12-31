import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingBloC.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingEvent.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingState.dart';
import 'package:tunemoon/Screens/UserRegLogin/LoginScreen.dart';
import 'package:tunemoon/Screens/UserRegLogin/SignUpScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IsLoadingBLoC(),
      child: Scaffold(
        backgroundColor: const Color(0xff0A0E3D),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xff0A0E3D),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    forgotPasswordTitle(),
                    Image.asset('assets/images/logo.png'),
                    const SizedBox(height: 20,),
                    enterEmailTitle(),
                    emailIdTextField(),
                    passwordResetSendButton(),
                    backToLogin(),
                    const SizedBox(width: 10,),
                    doNotHaveAccount(),
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordTitle(){
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text("Forgot Password", style: TextStyle(fontSize: 45, color: Colors.white),),
    );
  }

  Widget enterEmailTitle(){
    return Container(
        padding: const EdgeInsets.only(left: 15.0),
        alignment: Alignment.topLeft,
        child: const Text("Enter Email id", style: TextStyle(fontSize: 20, color: Colors.white),)
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

  Widget passwordResetSendButton(){
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
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: ElevatedButton(
              onPressed: (){
                BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingTrueEvent());
                firebaseAuth.sendPasswordResetEmail(email: emailController.text.toString())
                    .then((value) {
                  BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingFalseEvent());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("We have Sent Password Reset Link to your Email Address..."), duration: Duration(seconds: 3), backgroundColor: Color(0xfff9f295),));
                })
                    .onError((error, stackTrace) {
                  BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingFalseEvent());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()), backgroundColor: Colors.red, duration: const Duration(seconds: 2),));
                });
              },
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xfff9f295),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  )
              ),
              child: isLoading == true?
              const CircularProgressIndicator(color: Colors.black,) :
              const Text("Send", style: TextStyle(fontFamily: 'KaushanScript', color: Colors.black, fontSize: 30),),
            ),
          );
        }
    );
  }
  Widget backToLogin(){
    return Container(
      padding: const EdgeInsets.only(right: 15.0),
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: (){
          Navigator.pushReplacement(context,
              PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 1),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                    animation = CurvedAnimation(parent: animation, curve: Curves.linear);
                    return SlideTransition(
                      position: Tween(
                          begin: const Offset(-1.0, 0.0),
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
        child: const Text("Back to Login",
          style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.end,),
      ),
    );
  }

  Widget doNotHaveAccount(){
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
                          begin: const Offset(-1.0, 0.0),
                          end: const Offset(0.0, 0.0))
                          .animate(animation),
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return const SignUpScreen();
                  })
          );
        },
        child: const Text("Don't have an Account?",
          style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.end,),
      ),
    );
  }
}
