import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunemoon/Cubit/ChangeUnameCubit.dart';
import 'package:tunemoon/Cubit/ChangeUnameState.dart';
import 'package:tunemoon/Cubit/DBPlaylistCubit.dart';
import 'package:tunemoon/Cubit/DBPlaylistState.dart';
import 'package:tunemoon/Cubit/GreetingCubit.dart';
import 'package:tunemoon/Cubit/GreetingState.dart';
import 'package:tunemoon/Cubit/RecentMusicCubit.dart';
import 'package:tunemoon/Cubit/RecentMusicState.dart';
import 'package:tunemoon/Cubit/SongSuggestionCubit.dart';
import 'package:tunemoon/Cubit/SongSuggestionState.dart';
import 'package:tunemoon/SQFlite/DatabaseHelperRecentPlay.dart';
import 'package:tunemoon/Screens/PlaylistPortion/IndividualPlaylistScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String userName = "";
  List<String> selectedArtists = [];
  String uid = "";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DBPlaylistCubit()),
        BlocProvider(create: (context) => RecentMusicCubit()),
        BlocProvider(create: (context) => SongSuggestionCubit()),
        BlocProvider(create: (context) => GreetingCubit()),
        BlocProvider(create: (context) => ChangeUnameCubit())
      ],
      child: Scaffold(
        body:
        // userName == ""? const Center(child: CircularProgressIndicator()) :
        Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xff0A0E3D),
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  helloMsg(),
                  greetingMsg(),
                  yourPlaylistTitle(),
                  yourPlaylists(),
                  recentlyPlayedTitle(),
                  recentlyPlayed(),
                  suggestedForYouTitle(),
                  suggestedForYou()
                ],
              ),
            )
      )
      ),
    );
  }

  Widget helloMsg(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: BlocBuilder<ChangeUnameCubit, ChangeUnameState>(
        builder: (context, state){
          if(state is ChangeUnameLoadedState){
            userName = state.uname;
          }
          return Text("Hey $userName,", style: const TextStyle(color: Colors.white, fontSize: 30),);
        }
      ),
    );
  }

  Widget greetingMsg(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child:
      BlocBuilder<GreetingCubit, GreetingState>(
        builder: (context, state){
          if(state is GreetingMsgState) {
            return Text(
              "Good ${state.greetingMsg}", style: const TextStyle(
                color: Color(0xfff9f295), fontSize: 25),
            );
          }
          else{
            return const Text(
              "We look forward to serving you.", style: TextStyle(
                color: Color(0xfff9f295), fontSize: 20),
            );
          }
        },
      ),
    );
  }

  Widget yourPlaylistTitle(){
    return const Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Text("Your Playlists", style: TextStyle(color: Colors.white, fontSize: 30),),
    );
  }

  Widget yourPlaylists(){
    return Container(
        width: double.infinity,
        height: 75,
        child: BlocBuilder<DBPlaylistCubit, DBPlaylistState>(
            builder: (context, state){
              if(state is DBPlaylistLoadingState){
                return const Center(child: CircularProgressIndicator(color: Color(0xfff9f295),));
              }
              else if(state is DBPlaylistLoadedState){
                if(state.playlistTables.length == 1){
                  return const Text("Nothing to Show Here", style: TextStyle(fontSize: 20, color: Color(0xfff9f295),),);
                }
                else{
                  return ListView.builder(
                      itemCount: state.playlistTables.length - 1,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        return InkWell(
                          onTap: (){
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
                                      return IndividualPlaylistScreen(playlistName: state.playlistTables[index + 1],);
                                    })
                            );
                          },
                          child: Container(
                            width: 150,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xfff9f295)),
                            ),
                            child: Text(state.playlistTables[index + 1],
                              style: const TextStyle(color: Colors.white, fontSize: 22),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        );
                      }
                  );
                }
              }
              else if(state is DBPlaylistErrorState){
                return Text(state.errorMsg, style: const TextStyle(fontSize: 20, color: Color(0xfff9f295),),);
              }
              else{
                return const Text("Something Unexpected Occurs... please try again later", style: TextStyle(fontSize: 20, color: Color(0xfff9f295),),);
              }
            }
        )
    );
  }

  Widget recentlyPlayedTitle(){
    return const Padding(
      padding: EdgeInsets.only(top: 18.0, bottom: 15.0),
      child: Text("Recently Played", style: TextStyle(color: Colors.white, fontSize: 30),),
    );
  }

  Widget recentlyPlayed(){
    return Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xfff9f295))
        ),
        child: BlocBuilder<RecentMusicCubit, RecentMusicState>(
            builder: (context, state){
              if(state is RecentMusicLoadingState){
                return const Center(child: CircularProgressIndicator(color: Color(0xfff9f295),));
              }
              else if(state is RecentMusicLoadedState){
                int songsLength = state.songs?.length ?? 0;
                if(songsLength == 0){
                  return const Center(child: Text("Nothing to Show Here", style: TextStyle(color: Color(0xfff9f295), fontSize: 30),));
                }
                else{
                  return ListView.builder(
                      itemCount: songsLength,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        int itemCount = songsLength;
                        int reverseIndex = itemCount - 1 - index;
                        return Container(
                          height: double.infinity,
                          width: 170,
                          decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xfff9f295))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Image.asset('assets/images/logo.png')
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text(state.songs![reverseIndex].title,
                                        style: const TextStyle(fontSize: 17, color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(state.songs![reverseIndex].singers.toString(),
                                        style: const TextStyle(fontSize: 15, color: Colors.white70),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        );
                      }
                  );
                }
              }
              else if(state is RecentMusicErrorState){
                return Center(child: Text(state.errorMsg, style: const TextStyle(color: Color(0xfff9f295), fontSize: 30),));
              }
              else{
                return const Center(child: Text("Something Unexpected Occurs...", style: TextStyle(color: Color(0xfff9f295), fontSize: 30),));
              }
            }
        )
    );
  }

  Widget suggestedForYouTitle(){
    return const Padding(
      padding: EdgeInsets.only(top: 18.0, bottom: 15.0),
      child: Text("Suggested For You", style: TextStyle(color: Colors.white, fontSize: 30),),
    );
  }

  Widget suggestedForYou(){
    return Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xfff9f295))
        ),
        child: BlocBuilder<SongSuggestionCubit, SongSuggestionState>(
          builder: (context, state){
            if(state is SongSuggestionLoadingState){
              return const Center(child: CircularProgressIndicator(color: Color(0xfff9f295),),);
            }
            else if(state is SongSuggestionLoadedState){
              int suggestionSongsLength = state.songs?.length ?? 0;
              if(suggestionSongsLength == 0){
                return const Center(child: Text("Nothing to Show Here", style: TextStyle(color: Color(0xfff9f295), fontSize: 30),));
              }
              else{
                return ListView.builder(
                  itemCount: suggestionSongsLength,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      height: double.infinity,
                      width: 170,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xfff9f295))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Image.asset('assets/images/logo.png')
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text(state.songs[index].title!,
                                    style: const TextStyle(fontSize: 17, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(state.songs[index].singers.toString(),
                                    style: const TextStyle(fontSize: 15, color: Colors.white70),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
            else if(state is SongSuggestionErrorState){
              return Center(child: Text(state.errorMsg, style: const TextStyle(color: Color(0xfff9f295), fontSize: 30),));
            }
            else{
              return const Center(child: Text("Something Unexpected Occurs...", style: TextStyle(color: Color(0xfff9f295), fontSize: 30),));
            }
          },
        )
    );
  }
}
