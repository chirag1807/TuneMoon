import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/DBPlaylistCubit.dart';
import 'package:tunemoon/Cubit/DBPlaylistState.dart';
import 'package:tunemoon/SQFlite/DatabaseHelper.dart';
import 'package:tunemoon/SQFlite/SQFlitePlaylistDataClass.dart';

class AddtoPlaylistScreen extends StatefulWidget {
  final SQFlitePlaylistDataClass sqFlitePlaylistDataClass;
  const AddtoPlaylistScreen({Key? key, required this.sqFlitePlaylistDataClass}) : super(key: key);

  @override
  State<AddtoPlaylistScreen> createState() => _AddtoPlaylistScreenState();
}

class _AddtoPlaylistScreenState extends State<AddtoPlaylistScreen> {
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
              await DatabaseHelper.createDB(playlistNameController.text);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Playlist Created Successfully",),
                backgroundColor: Colors.green,
              ));
              Navigator.of(context).pop();
            },
            child: const Text("Create", style: TextStyle(color: Color(0xff0A0E3D)),)
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DBPlaylistCubit(),
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
                  const Text("Add to...", style: TextStyle(fontSize: 30, color: Colors.white),),

                  addToPlaylist(),

                  createNewPlaylist()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addToPlaylist(){
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
                    const Text("Nothing to Show here...", style: TextStyle(fontSize: 20, color: Colors.white),),
                    InkWell(
                        onTap: (){
                          createPlaylist();
                        },
                        child: const Text("Create a new One", style: TextStyle(fontSize: 20, color: Colors.blueAccent),)
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
                  itemBuilder: (BuildContext context, int index){
                    return InkWell(
                      onTap: (){
                        DatabaseHelper.addSong(widget.sqFlitePlaylistDataClass, state.playlistTables[index+1]);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Songs Added Successfully..."),
                          backgroundColor: Colors.green,));
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          width: double.infinity,
                          // height: 80,
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
                                child: Text(state.playlistTables[index+1],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(color: Colors.white, fontSize: 30),
                                ),
                              ),
                              const Expanded(
                                  flex: 1,
                                  child: Icon(Icons.playlist_play_rounded, color: Color(0xfff9f295),)
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

  Widget createNewPlaylist(){
    return InkWell(
        onTap: (){
          createPlaylist();
        },
        child: const Text("Create a New One...", style: TextStyle(color: Colors.blueAccent, fontSize: 20),)
    );
  }

}
