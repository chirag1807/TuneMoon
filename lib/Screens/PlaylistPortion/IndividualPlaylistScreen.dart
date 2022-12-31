import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/PlaylistSongsCubit.dart';
import 'package:tunemoon/Cubit/PlaylistSongsState.dart';
import 'package:tunemoon/SQFlite/DatabaseHelper.dart';
import 'package:tunemoon/Screens/PlayMusic/DeviceAudioPlayScreen.dart';
import 'package:tunemoon/Screens/PlaylistPortion/MainPlaylistScreen.dart';

class IndividualPlaylistScreen extends StatefulWidget {
  final String playlistName;
  const IndividualPlaylistScreen({Key? key, required this.playlistName}) : super(key: key);

  @override
  State<IndividualPlaylistScreen> createState() => _IndividualPlaylistScreenState();
}

class _IndividualPlaylistScreenState extends State<IndividualPlaylistScreen> {

  void showDialogToDeletePlaylist(){
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
                DatabaseHelper.deleteDB(widget.playlistName);
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
      create: (context) => PlaylistSongsCubit(widget.playlistName),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.playlistName, style: const TextStyle(fontSize: 25),),
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
                  tooltip: "Delete Playlist",
                  onPressed: (){
                    showDialogToDeletePlaylist();
                  },
                  icon: const Icon(Icons.playlist_remove, color: Color(0xfff9f295), size: 40,)),
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
                  const Text("Your Songs", style: TextStyle(fontSize: 30, color: Colors.white),),

                  individualPlaylist()
                ],
              ),
            )
          ),
        ),
        ),
    );
  }


  Widget individualPlaylist(){
    return BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
        builder: (context, state){
          if(state is PlaylistSongsLoadingState){
            return const CircularProgressIndicator(color: Color(0xfff9f295),);
          }
          else if(state is PlaylistSongsLoadedState){
            if(state.playlistSongs.isEmpty){
              return Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    const Text("Playlist is Empty...", style: TextStyle(fontSize: 25, color: Colors.white),),
                    InkWell(
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
                                    return const MainPlaylistScreen();
                                  })
                          );
                        },
                        child: const Text("Add a Songs", style: TextStyle(fontSize: 20, color: Colors.blueAccent),)
                    ),
                  ],
                ),
              );
            }
            else{
              return ListView.builder(
                  itemCount: state.playlistSongs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DeviceAudioPlayScreen(
                          songList: state.playlistSongs,
                          index: index,
                          indicator: 2,)
                        ));
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xfff9f295)),
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(state.playlistSongs[index].title!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 25, color: Colors.white),
                                  ),
                                  Text(state.playlistSongs[index].actors!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 17, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: const [
                                          Icon(Icons.remove_circle_outline, color: Color(0xff0A0E3D),),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Delete From Playlist", style: TextStyle(color: Color(0xff0A0E3D)),)
                                        ],
                                      ),
                                    ),
                                  ],
                                  offset: const Offset(-15, 30),
                                  elevation: 2,
                                  color: const Color(0xfff9f295),
                                  icon: const Icon(Icons.more_vert, color: Color(0xfff9f295),),
                                  onSelected: (value) {
                                    if (value == 1) {
                                      DatabaseHelper.deleteSong(state.playlistSongs[index], widget.playlistName);
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
                                    }
                                  },
                                )
                            )
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
          }
          else if(state is PlaylistSongsErrorState){
            print(state.errorMsg);
            return Text(state.errorMsg, style: const TextStyle(color: Colors.white, fontSize: 25),);
          }
          else{
            return const Text("Something Unexpected Occurs... please try again later", style: TextStyle(color: Colors.white, fontSize: 25),);
          }
        }
    );
  }
}
