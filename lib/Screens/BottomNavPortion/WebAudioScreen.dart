import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/InternetBloC/InternetState.dart';
import 'package:tunemoon/BLoCs/SearchMusicBLoC/SearchMusicBLoC.dart';
import 'package:tunemoon/BLoCs/SearchMusicBLoC/SearchMusicEvent.dart';
import 'package:tunemoon/BLoCs/SearchMusicBLoC/SearchMusicState.dart';
import 'package:tunemoon/SQFlite/DatabaseHelper.dart';
import 'package:tunemoon/SQFlite/SQFlitePlaylistDataClass.dart';
import 'package:tunemoon/Screens/PlayMusic/DeviceAudioPlayScreen.dart';
import 'package:tunemoon/Screens/PlaylistPortion/MainPlaylistScreen.dart';
import 'package:tunemoon/Screens/PlaylistPortion/AddtoPlaylistScreen.dart';
import 'package:tunemoon/model/SearchMusicDataClass.dart';
import 'package:tunemoon/BLoCs/InternetBloC/InternetBloC.dart';

class WebAudioScreen extends StatefulWidget {
  const WebAudioScreen({Key? key}) : super(key: key);

  @override
  State<WebAudioScreen> createState() => _WebAudioScreenState();
}

class _WebAudioScreenState extends State<WebAudioScreen> {
  TextEditingController searchFieldController = TextEditingController();
  List<SearchMusicDataClass> musics = [];
  String searchKeyword = "";
  bool isLoading = false;
  DatabaseHelper? databaseHelper;
  SQFlitePlaylistDataClass? sqFlitePlaylistDataClass;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InternetBloc()),
        BlocProvider(create: (context) => SearchMusicBLoC())
      ],
      child: Scaffold(
          body:
          BlocListener<InternetBloc, InternetState>(
            listener: (context, state){
              if(state is InternetGainedState){
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Connection is Active..."),
                      backgroundColor: Colors.green,
                    )
                );
              }
              else if(state is InternetLostState){
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Connection is Lost...Please turn on your Internet to continue"),
                      backgroundColor: Colors.red,
                    )
                );
              }
            },
            child: Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xff0A0E3D),
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchMusicTextField(),
                      searchedMusics()
                    ],
                  ),
                )
            ),
          )
      ),
    );
  }

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  Widget searchMusicTextField(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: BlocBuilder<SearchMusicBLoC, SearchMusicState>(
        builder: (context, state){

          return TextField(
            controller: searchFieldController,
            keyboardType: TextInputType.text,
            cursorColor: const Color(0xff0A0E3D),
            decoration: InputDecoration(
              hintText: "Search Music",
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xff0A0E3D),
              ),
              suffixIcon: InkWell(
                onTap: (){},
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.playlist_play_rounded, color: Color(0xff0A0E3D),),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Open Playlist", style: TextStyle(color: Color(0xff0A0E3D)),)
                        ],
                      ),
                    ),
                  ],
                  offset: const Offset(-15, 30),
                  elevation: 2,
                  color: const Color(0xfff9f295),
                  onSelected: (value) {
                    if (value == 1) {
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
                                return const MainPlaylistScreen();
                              })
                      );
                    }
                  },
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
            onChanged: (value){
              if(value.isEmpty){
                BlocProvider.of<SearchMusicBLoC>(context).add(SearchMusicEmptyTextFieldEvent("Please Search Something..."));
              }
            },
            onSubmitted: (value) async {
              if(value != "") {
                value = capitalizeAllWord(value);
                // musics = await getSearchMusic(value);
                BlocProvider.of<SearchMusicBLoC>(context).add(SearchMusicLoadedEvent(value));
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Search Song First")));
              }
            },
          );
        },
      ),
    );
  }

  Widget searchedMusics(){
    return BlocBuilder<SearchMusicBLoC, SearchMusicState>(
        builder: (context, state){
          if(state is SearchMusicInitialState){
            return Container();
          }
          else if(state is SearchMusicLoadingState){
            return const Center(child: CircularProgressIndicator(color: Color(0xfff9f295),));
          }
          else if(state is SearchMusicLoadedState){
            if(state.musics.isEmpty){
              return const Center(child: Text("Sorry...Could Not Find Music", style: TextStyle(color: Colors.white, fontSize: 20),));
            }
            else{
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: state.musics.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index){
                        return InkWell(
                          onTap: (){
                            print(index);
                            print(state.musics.length);

                            Navigator.push(context, MaterialPageRoute(builder: (context)=> DeviceAudioPlayScreen(
                              songList: state.musics,
                              index: index,
                              indicator: 1,)
                            ));
                          },
                          child: Container(
                            width: double.infinity,
                            // height: 80,
                            margin: const EdgeInsets.only(bottom: 15.0),
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
                                      Text(state.musics[index].title!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 25, color: Colors.white),
                                      ),
                                      Text(state.musics[index].actors.toString(),
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
                                              Icon(Icons.playlist_play_rounded, color: Color(0xff0A0E3D),),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Add to Playlist", style: TextStyle(color: Color(0xff0A0E3D)),)
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
                                          print(state.musics[index]);
                                          sqFlitePlaylistDataClass = SQFlitePlaylistDataClass(
                                              sId: state.musics[index].sId,
                                              musicFilePath: state.musics[index].musicFilePath,
                                              title: state.musics[index].title,
                                              singers: state.musics[index].singers.toString(),
                                              movie: state.musics[index].movie,
                                              actors: state.musics[index].actors.toString()
                                          );
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
                                                    return AddtoPlaylistScreen(sqFlitePlaylistDataClass: sqFlitePlaylistDataClass!,);
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
                  ),
                ),
              );
            }
          }
          else if(state is SearchMusicErrorState){
            return Center(child: Text(state.errorMsg, style: const TextStyle(color: Colors.white, fontSize: 20),));
          }
          else if(state is SearchMusicTextFieldEmptyState){
            return Center(child: Text(state.keyword, style: const TextStyle(color: Colors.white, fontSize: 20),));
          }
          else{
            return const Center(child: Text("Something Unexpected Occurs...please try again later", style: TextStyle(color: Colors.white, fontSize: 20),));
          }
        }
    );
  }

}
