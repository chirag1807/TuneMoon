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
import 'package:tunemoon/Screens/BottomNavPortion/BottomNavBar.dart';
import 'package:tunemoon/Screens/UserRegLogin/ForgotPasswordScreen.dart';
import 'package:tunemoon/Screens/UserRegLogin/SelectArtistScreen.dart';
import 'package:tunemoon/Screens/UserRegLogin/SignUpScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordObscured = true;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<bool> artistSelected() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('isArtistSelected') ?? false;
  }

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
                  loginTitle(),
                  Image.asset('assets/images/logo.png'),
                  emailIdTextField(),
                  passwordTextField(),
                  forgotPasswordTitle(),
                  const Padding(padding: EdgeInsets.only(bottom: 15.0)),
                  loginButton(),
                  doNotHaveAccount(),
                  const SizedBox(height: 30,),
                  loginWithTitle(),
                  const SizedBox(height: 15,),
                  anotherLoginOptionRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken
      );

      // Getting users credential
      UserCredential result = await firebaseAuth.signInWithCredential(authCredential);
      final user = result.user;
      if (user != null) {
        googleLoginNavigator(result);
      }
    }
  }

  Widget loginTitle(){
    return const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text("Login", style: TextStyle(fontSize: 50, color: Colors.white),),
    );
  }

  Widget emailIdTextField(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.text,
        cursorColor: const Color(0xff0A0E3D),
        decoration: InputDecoration(
          hintText: "Email Id",
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

  Widget passwordTextField(){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
        builder: (context, state){
          if(state is PasswordVisibleState){
            passwordObscured = false;
          }
          else{
            passwordObscured = true;
          }
          return TextField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            obscureText: passwordObscured,
            cursorColor: const Color(0xff0A0E3D),
            decoration: InputDecoration(
              hintText: "Password",
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

  Widget forgotPasswordTitle(){
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
                    return const ForgotPasswordScreen();
                  })
          );
        },
        child: const Text("Forgot Password?",
          style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.end,),
      ),
    );
  }

  Widget loginButton(){
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
                firebaseAuth.signInWithEmailAndPassword(
                    email: emailController.text.toString(),
                    password: passwordController.text.toString())
                    .then((value) {
                  BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingFalseEvent());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("logged in Successfully"), backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 900),
                  ));
                  Timer(const Duration(seconds: 1), () {
                    artistSelected().then((value) => value==true?
                    Navigator.pushReplacement(context,
                        PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 1000),
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
                })
                    .onError((error, stackTrace) {
                  BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingFalseEvent());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()), backgroundColor: Colors.red,));
                });
              },
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xfff9f295),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  )
              ),
              child: isLoading == true ?
              const CircularProgressIndicator(color: Colors.black,):
              const Text("Login", style: TextStyle(fontFamily: 'KaushanScript', color: Colors.black, fontSize: 25),)
          ),
        );
      },
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

  Widget loginWithTitle(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:  [
        Padding(
          padding:const EdgeInsets.symmetric(horizontal:10.0),
          child:Container(
            height:1.0,
            width:60.0,
            color:const Color(0xfff9f295),),
        ),
        const Text("or Login With", style: TextStyle(fontSize: 22, color: Colors.white),),
        Padding(
          padding:const EdgeInsets.symmetric(horizontal:10.0),
          child:Container(
            height:1.0,
            width:60.0,
            color:const Color(0xfff9f295),),
        ),
      ],
    );
  }

  Widget anotherLoginOptionRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
            onTap: (){
              signInWithGoogle(context);
            },
            child: Image.asset('assets/images/google_logo.png')),
        Image.asset('assets/images/facebook_logo.png'),
        Image.asset('assets/images/twitter_logo.png'),
      ],
    );
  }

  void googleLoginNavigator(UserCredential result) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("userName", result.user!.displayName!);
    artistSelected().then((value) => value==true?
    Navigator.pushReplacement(context,
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
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
}
