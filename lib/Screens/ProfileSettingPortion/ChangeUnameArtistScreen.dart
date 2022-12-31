import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunemoon/BLoCs/ChangeArtistBLoC/ChangeArtistBLoC.dart';
import 'package:tunemoon/BLoCs/ChangeArtistBLoC/ChangeArtistState.dart';
import 'package:tunemoon/BLoCs/ChangeArtistBLoC/ChangeArtistEvent.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingBloC.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingEvent.dart';
import 'package:tunemoon/BLoCs/IsLoadingBloC/IsLoadingState.dart';
import 'package:tunemoon/Cubit/ChangeUnameCubit.dart';
import 'package:tunemoon/Cubit/ChangeUnameState.dart';
import 'package:tunemoon/Screens/BottomNavPortion/BottomNavBar.dart';
import 'package:tunemoon/model/SelectArtistDataClass.dart';
import 'package:tunemoon/model/UserPostDetails.dart';
import 'package:http/http.dart' as http;

class ChangeUnameArtistScreen extends StatefulWidget {
  const ChangeUnameArtistScreen({Key? key}) : super(key: key);

  @override
  State<ChangeUnameArtistScreen> createState() => _ChangeUnameArtistScreenState();
}

class _ChangeUnameArtistScreenState extends State<ChangeUnameArtistScreen> {
  TextEditingController nameController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String userName = "";
  List<String> selectedArtists = [];
  late UserPostDetails userPostDetails;
  bool isLoading = false;
  List selectArtists = [
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/a_r_rahman.png"), artistName: "A R Rahman", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Ajay_Atul.png"), artistName: "Ajay Atul", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/AlkaYagnik.png"), artistName: "Alka Yagnik", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Anuradha_paudwal.png"), artistName: "Anuradha Paudwal", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Arijit_Singh.png"), artistName: "Arijit Singh", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Arman_Malik.png"), artistName: "Arman Malik", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Atif_Aslam.png"), artistName: "Atif Aslam", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/B_Praak.png"), artistName: "B Praak", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Badshah.png"), artistName: "Badshah", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Darshan_Raval.png"), artistName: "Darshan Raval", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Honey_Singh.png"), artistName: "Honey Singh", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Javed_Ali.png"), artistName: "Javed Ali", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Jubin_Nautiyal.png"), artistName: "Jubin Nautiyal", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Kumar_Sanu.png"), artistName: "Kumar Sanu", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Neha_Kakkar.png"), artistName: "Neha Kakkar", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Shaan.png"), artistName: "Shaan", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Shreya_Ghoshal.png"), artistName: "Shreya Ghoshal", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Sonu_Nigam.png"), artistName: "Sonu Nigam", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Sunidhi_Chauhan.png"), artistName: "Sunidhi Chauhan", isChecked: false),
    SelectArtistDataClass(artistImage: Image.asset("assets/images/artists/Udit_Narayan.png"), artistName: "Udit Narayan", isChecked: false),
  ];


  Future<int> selectedArtistLength() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getStringList('selectedArtists')?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => IsLoadingBLoC()),
        BlocProvider(create: (context) => ChangeUnameCubit()),
        BlocProvider(create: (context) => ChangeArtistBLoC(selectArtists))
      ],
      child: Scaffold(
        backgroundColor: const Color(0xff0A0E3D),
        body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  changeUnameArtistTitle(),
                  changeUnameTextField(),
                  changeArtistPhotos(),
                  updateButton()
                ],
              ),
            )
        ),
      ),
    );
  }
  Future<void> postUserData(UserPostDetails userPostDetails) async {
    var baseUrl = "https://tunemoon-api.vercel.app/user";
    Uri url = Uri.parse("$baseUrl/update");
    var response = await http.post(url,
      headers: {
        "content-type": "application/json",
      },
      body: jsonEncode(userPostDetails.toMap()),
    );
    print(response.statusCode);
    print(response.body);
  }

  Widget changeUnameArtistTitle(){
    return const Expanded(
        flex: 1,
        child: Text("Change Username and Artists", style: TextStyle(color: Colors.white, fontSize: 25),)
    );
  }

  Widget changeUnameTextField(){
    return Expanded(
      flex: 2,
      child: BlocBuilder<ChangeUnameCubit, ChangeUnameState>(
        builder: (context, state){
          if(state is ChangeUnameLoadedState){
            nameController.text = state.uname;
          }
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                cursorColor: const Color(0xff0A0E3D),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Enter the new Username",
                  prefixIcon: const Icon(
                    Icons.person,
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
            ),
          );
        },
      ),
    );
  }

  Widget changeArtistPhotos(){
    return Expanded(
        flex: 11,
        child: BlocBuilder<ChangeArtistBLoC, ChangeArtistState>(
            builder: (context, state){
              if(state is ChangeArtistCheckedState){
                print("object1");
                selectArtists[state.index].isChecked = true;
                selectedArtists.add(selectArtists[state.index].artistName);
                print(selectedArtists);
              }
              if(state is ChangeArtistUnCheckedState){
                print("object2");
                selectArtists[state.index].isChecked = false;
                if(selectedArtists.contains(selectArtists[state.index].artistName)){
                  selectedArtists.remove(selectArtists[state.index].artistName);
                }
                print(selectedArtists);
              }
              if(state is ChangeArtistLoadingState){
                BlocProvider.of<ChangeArtistBLoC>(context).add(ChangeArtistLoadedEvent());
                return const Center(child: CircularProgressIndicator(color: Color(0xfff9f295),));
              }
              if(state is ChangeArtistLoadedState){
                selectArtists = state.selectArtists;
                selectedArtists = state.selectedArtists;
              }
              if(state is ChangeArtistErrorState){
                return Center(child: Text(state.errorMsg, style: const TextStyle(color: Colors.white, fontSize: 22),),);
              }
              // return const Center(child: Text("Something Unexpected Occurs...", style: TextStyle(color: Colors.white, fontSize: 22),),);
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0
                  ),
                  itemCount: selectArtists.length,
                  itemBuilder: (BuildContext context, int index){
                    return InkWell(
                      onTap: (){
                        if(selectArtists[index].isChecked == false){
                          BlocProvider.of<ChangeArtistBLoC>(context).add(ChangeArtistCheckedEvent(index));
                        }
                        else{
                          BlocProvider.of<ChangeArtistBLoC>(context).add(ChangeArtistUnCheckedEvent(index));
                        }
                      },
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xfff9f295),
                                width: 1.0
                            ),
                            borderRadius: BorderRadius.circular(2.0)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 120,
                              child: selectArtists[index].artistImage,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(selectArtists[index].artistName, style: const TextStyle(fontSize: 15, color: Colors.white),),
                                selectArtists[index].isChecked == true ?
                                Image.asset('assets/images/checklist (1).png', width: 30, height: 30,) :
                                Image.asset('assets/images/checklist.png', width: 30, height: 30,)
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
        )
    );
  }

  Widget updateButton(){
    return Expanded(
      flex: 1,
      child: BlocBuilder<IsLoadingBLoC, IsLoadingState>(
          builder: (context, state) {
            if (state is IsLoadingFalseState) {
              isLoading = false;
            }
            else {
              isLoading = true;
            }
            return Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingTrueEvent());
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    sp.setString("userName", nameController.text);
                    sp.setStringList("selectedArtists", selectedArtists);
                    userName = sp.getString("userName")!;
                    selectedArtistLength().then((value) => (value != 0)  ? {
                      userPostDetails = UserPostDetails(
                          uid: firebaseAuth.currentUser!.uid.toString(),
                          userName: userName,
                          favArtists: selectedArtists
                      ),
                      postUserData(userPostDetails),
                      BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingFalseEvent()),
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
                              })
                      )
                    } :
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please Choose Artists..."))
                      ),
                      BlocProvider.of<IsLoadingBLoC>(context).add(IsLoadingFalseEvent()),
                    }
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfff9f295),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      )
                  ),
                  child: isLoading == true ?
                  const CircularProgressIndicator(color: Colors.black,):
                  const Text("Update", style: TextStyle(fontFamily: 'KaushanScript', color: Colors.black, fontSize: 30),)
              ),
            );
          }
      ),
    );
  }
}
