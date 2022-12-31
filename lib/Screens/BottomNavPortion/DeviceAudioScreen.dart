import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/StoragePermissionCubit.dart';
import 'package:tunemoon/Cubit/StoragePermissionState.dart';
import 'package:tunemoon/Screens/PlayMusic/DeviceAudioPlayScreen.dart';

class DeviceAudioScreen extends StatefulWidget {
  const DeviceAudioScreen({Key? key}) : super(key: key);

  @override
  State<DeviceAudioScreen> createState() => _DeviceAudioScreenState();
}

class _DeviceAudioScreenState extends State<DeviceAudioScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoragePermissionCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xff0A0E3D),
          body:
          deviceSongs()
      ),
    );
  }

  Widget deviceSongs(){
    return BlocBuilder<StoragePermissionCubit, StoragePermissionState>(
      builder: (context, state){
        if(state is StoragePermissionInitialState){
          return Container();
        }
        else if(state is StoragePermissionNotGrantedState){
          return const Center(child: Text("Please Grant Permission First!...", style: TextStyle(fontSize: 22, color: Colors.white),));
        }
        else if(state is StoragePermissionGrantedState){
          if(state.songs.isEmpty){
            return const Text("No Songs Found...", style: TextStyle(fontSize: 25, color: Colors.white),);
          }
          return ListView.builder(
              itemCount: state.songs.length,
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DeviceAudioPlayScreen(
                      songList: state.songs,
                      index: index,
                      indicator: 0,)
                    ));
                  },
                  child: Column(
                    children: [
                      Container(
                        color: const Color(0xff0A0E3D),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(state.songs[index].displayNameWOExt,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 25, color: Colors.white),),
                            )
                          ],
                        ),
                      ),
                      Container(width: double.infinity, height: 1.5,
                        color: const Color(0xfff9f295), margin: const EdgeInsets.only(left: 5, right: 5),)
                    ],
                  ),
                );
              }
          );
        }
        else if(state is StoragePermissionErrorState){
          return Text(state.errorMsg, style: const TextStyle(fontSize: 25, color: Colors.white),);
        }
        else{
          return const Text("Something Unexpected Occurs...", style: TextStyle(fontSize: 25, color: Colors.white),);
        }
      },
    );
  }

}
