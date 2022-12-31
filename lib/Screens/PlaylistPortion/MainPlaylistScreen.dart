import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/DBPlaylistCubit.dart';
import 'package:tunemoon/Cubit/DBPlaylistState.dart';
import 'package:tunemoon/SQFlite/DatabaseHelper.dart';
import 'package:tunemoon/Screens/PlaylistPortion/IndividualPlaylistScreen.dart';

class MainPlaylistScreen extends StatefulWidget {
  const MainPlaylistScreen({Key? key}) : super(key: key);

  @override
  State<MainPlaylistScreen> createState() => _MainPlaylistScreenState();
}

class _MainPlaylistScreenState extends State<MainPlaylistScreen> {
  TextEditingController playlistNameController = TextEditingController();


  void createPlaylist(){
    showDialog(context: context, builder: (context) => AlertDialog(
          backgroundColor: const Color(0xfff9f295),
          title: const Text("Playlist Name", style: TextStyle(color: Color(0xff0A0E3D)),),
          content: TextField(
            controller: playlistNameController,
            autofocus: true,
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel", style: TextStyle(color: Color(0xff0A0E3D)),)
            ),
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await DatabaseHelper.createDB(playlistNameController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Playlist Created Successfully",),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.of(context).pop();

                },
                child: const Text("Create", style: TextStyle(color: Color(0xff0A0E3D)),)
            ),
          ],
        ),
    );
    }

  void showDialogToDeletePlaylist(String playlistName){
    showDialog(context: context, builder: (content) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        backgroundColor: const Color(0xfff9f295),
        title: const Text("Delete Playlist", style: TextStyle(color: Color(0xff0A0E3D), fontSize: 25),),
        content: const Text("Are You Sure to want to Delete this Playlist?", style: TextStyle(color: Color(0xff0A0E3D), fontSize: 15),),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("No", style: TextStyle(color: Color(0xff0A0E3D), fontSize: 20),)
          ),
          TextButton(
              onPressed: (){
                Navigator.pop(context);
                DatabaseHelper.deleteDB(playlistName);
                Timer(const Duration(seconds: 1) , (){
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
                            return const MainPlaylistScreen();
                          })
                  );
                });
              },
              child: const Text("Yes", style: TextStyle(color: Color(0xff0A0E3D), fontSize: 20),)
          ),
        ],
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DBPlaylistCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Playlist", style: TextStyle(fontSize: 25),),
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
                  tooltip: "Create Playlist",
                  onPressed: () {
                    createPlaylist();
                  },
                  icon: const Icon(
                    Icons.playlist_add, color: Color(0xfff9f295),
                    size: 40,)),
            )
          ],
        ),
        backgroundColor: const Color(0xff0A0E3D),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  yourPlaylistTitle(),
                  mainPlaylist()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget yourPlaylistTitle(){
    return const Text("Your Playlists",
      style: TextStyle(fontSize: 30, color: Colors.white),);
  }

  Widget mainPlaylist(){
    return BlocBuilder<DBPlaylistCubit, DBPlaylistState>(
        builder: (context, state){
          if(state is DBPlaylistLoadingState){
            return const CircularProgressIndicator(color: Color(0xfff9f295),);
          }

          else if(state is DBPlaylistLoadedState){
            if(state.playlistTables.length == 1){
              return Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    const Text("Nothing to Show here...",
                      style: TextStyle(
                          fontSize: 20, color: Colors.white),),
                    InkWell(
                        onTap: () {
                          createPlaylist();
                        },
                        child: const Text("Create a new One",
                          style: TextStyle(fontSize: 20,
                              color: Colors.blueAccent),)
                    ),
                  ],
                ),
              );
            }
            else{
              return ListView.builder(
                  itemCount: state.playlistTables.length - 1,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
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
                                        begin: const Offset(1.0, 0.0),
                                        end: const Offset(0.0, 0.0))
                                        .animate(animation),
                                    child: child,
                                  );
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<
                                        double> secondaryAnimation) {
                                  return IndividualPlaylistScreen(
                                    playlistName: state.playlistTables[index + 1],);
                                })
                        );
                      },
                      child: Container(
                          width: double.infinity,
                          // height: 80,
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xfff9f295)),
                              borderRadius: BorderRadius.circular(
                                  15.0)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Expanded(
                                flex: 9,
                                child: Text(state.playlistTables[index + 1],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      onTap: () {
                                        showDialogToDeletePlaylist(
                                            state.playlistTables[index + 1]);
                                      },
                                      child: const Icon(
                                        Icons.playlist_remove,
                                        color: Color(0xfff9f295),)
                                  )
                              )
                            ],
                          )
                      ),
                    );
                  }
              );
            }

          }

          else if(state is DBPlaylistErrorState){
            return Text(state.errorMsg, style: const TextStyle(color: Colors.white, fontSize: 25),);
          }
          else{
            return const Text("Something Unexpected Occurs... please try again later", style: TextStyle(color: Colors.white, fontSize: 25),);
          }
        }
    );
  }
}
