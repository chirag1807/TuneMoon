import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tunemoon/SQFlite/DatabaseHelperRecentPlay.dart';
import 'package:tunemoon/SQFlite/SQFlitePlaylistDataClass.dart';

class DeviceAudioPlayScreen extends StatefulWidget {
  final List songList;
  int index;
  int indicator;
  DeviceAudioPlayScreen({Key? key, required this.songList, required this.index, required this.indicator}) : super(key: key);

  @override
  State<DeviceAudioPlayScreen> createState() => _DeviceAudioPlayScreenState();
}

class _DeviceAudioPlayScreenState extends State<DeviceAudioPlayScreen> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  Duration? duration = const Duration();
  Duration position = const Duration();
  List<Audio> audio = [];
  int i = 0;

  void changeToSecond(int seconds){
    Duration duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  @override
  void initState() {
    super.initState();
    if(widget.indicator == 0){
      setupPlaylist();
    }
    else if(widget.indicator == 1){
      setupPlaylist1();
    }
    else{
      setupPlaylist2();
    }
    addSongToRecentPlaylist();
    audioPlayer.current.listen((event) {
      duration = event?.audio.duration;
    });
    audioPlayer.currentPosition.listen((positionValue){
      setState(() {
        position = positionValue;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Duration convertTime(int timeInMilliseconds) {
    Duration timeDuration = Duration(milliseconds: timeInMilliseconds);
    return timeDuration;
  }

  void setupPlaylist() async {
    for(i=widget.index; i<widget.songList.length; i++){
        audio.add(Audio.file(widget.songList[i].uri!,
            metas: Metas(
              title: widget.songList[i].displayNameWOExt,
              artist: widget.songList[i].artist!,
              image: const MetasImage.asset('assets/images/logo.png')
            )
        )
        );
    }
    for(i=0; i<widget.index; i++){
        audio.add(Audio.file(widget.songList[i].uri!,
            metas: Metas(
              title: widget.songList[i].displayNameWOExt,
              artist: widget.songList[i].artist!,
              image: const MetasImage.asset('assets/images/logo.png')
            )
        )
        );
    }

    audioPlayer.open(
      Playlist(
        audios: audio,
      ),
      showNotification: true,
      autoStart: true,
      loopMode: LoopMode.playlist,
      playInBackground: PlayInBackground.enabled,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
    );
    // audioPlayer.playlistPlayAtIndex(widget.index);
  }

  void setupPlaylist1() async {
    for(i=widget.index; i<widget.songList.length; i++){
        audio.add(Audio.network(widget.songList[i].musicFilePath,
            metas: Metas(
                title: widget.songList[i].title,
                artist: widget.songList[i].singers.toString(),
                image: const MetasImage.asset('assets/images/logo.png')
            )
        )
        );
    }
    for(i=0; i<widget.index; i++){
        audio.add(Audio.network(widget.songList[i].musicFilePath,
            metas: Metas(
                title: widget.songList[i].title,
                artist: widget.songList[i].singers.toString(),
                image: const MetasImage.asset('assets/images/logo.png')
            )
        )
        );
    }
    audioPlayer.open(
      Playlist(
          audios: audio,
          // startIndex: widget.index
      ),
      showNotification: true,
      autoStart: true,
      loopMode: LoopMode.playlist,
      playInBackground: PlayInBackground.enabled,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
    );
    // audioPlayer.playlistPlayAtIndex(widget.index);
  }

  void setupPlaylist2() async {
    for(i=widget.index; i<widget.songList.length; i++){
        audio.add(Audio.network(widget.songList[i].musicFilePath,
            metas: Metas(
                title: widget.songList[i].title,
                artist: widget.songList[i].singers,
                image: const MetasImage.asset('assets/images/logo.png')
            )
        )
        );
    }
    for(i=0; i<widget.index; i++){
      audio.add(Audio.network(widget.songList[i].musicFilePath,
          metas: Metas(
              title: widget.songList[i].title,
              artist: widget.songList[i].singers,
              image: const MetasImage.asset('assets/images/logo.png')
          )
      )
      );
    }
    audioPlayer.open(
      Playlist(
          audios: audio,
      ),
      showNotification: true,
      autoStart: true,
      loopMode: LoopMode.playlist,
      playInBackground: PlayInBackground.enabled,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
    );
    // audioPlayer.playlistPlayAtIndex(widget.index);
  }

  playMusic() async {
    await audioPlayer.play();
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  skipPrevious() async {
    pauseMusic();
    audioPlayer.previous();
    addSongToRecentPlaylist();
    if(widget.indicator == 1) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      if(widget.songList[widget.index].singers.length == 1){
        sp.setString("actor1", widget.songList[widget.index].singers[0]);
      }
      else{
        sp.setString("actor1", widget.songList[widget.index].singers[0]);
        sp.setString("actor2", widget.songList[widget.index].singers[1]);
      }
      if(widget.songList[widget.index].actors.length == 1){
        sp.setString("actor1", widget.songList[widget.index].actors[0]);
      }
      else{
        sp.setString("actor1", widget.songList[widget.index].actors[0]);
        sp.setString("actor2", widget.songList[widget.index].actors[1]);
      }
    }
  }

  skipNext() async {
    pauseMusic();
    audioPlayer.next();
    addSongToRecentPlaylist();
    if(widget.indicator == 1) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      if(widget.songList[widget.index].singers.length == 1){
        sp.setString("actor1", widget.songList[widget.index].singers[0]);
      }
      else{
        sp.setString("actor1", widget.songList[widget.index].singers[0]);
        sp.setString("actor2", widget.songList[widget.index].singers[1]);
      }
      if(widget.songList[widget.index].actors.length == 1){
        sp.setString("actor1", widget.songList[widget.index].actors[0]);
      }
      else{
        sp.setString("actor1", widget.songList[widget.index].actors[0]);
        sp.setString("actor2", widget.songList[widget.index].actors[1]);
      }
    }
  }

void addSongToRecentPlaylist() async {
    if(widget.indicator != 0){
      if(widget.indicator == 1){
        SQFlitePlaylistDataClass sqFlitePlaylistDataClass = SQFlitePlaylistDataClass(
            sId: widget.songList[widget.index].sId,
            musicFilePath: widget.songList[widget.index].musicFilePath,
            title: widget.songList[widget.index].title,
            singers: widget.songList[widget.index].singers.toString(),
            movie: widget.songList[widget.index].movie,
            actors: widget.songList[widget.index].actors.toString()
        );
        await DatabaseHelperRecentPlay.addSong(sqFlitePlaylistDataClass);
        print("1");
      }
      else if(widget.indicator == 2) {
        await DatabaseHelperRecentPlay.addSong(widget.songList[widget.index]);
        print("2");
      }
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A0E3D),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xff0A0E3D),
            child: audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                headerTitles(),
                iconTitleArtistName(),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      sliderDurationPosition(),
                      Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                skipPrevious();
                              },
                              child: const Icon(
                                Icons.skip_previous, color: Color(0xfff9f295),
                                size: 70,),
                            ),
                            InkWell(
                              onTap: () {
                                isPlaying ? pauseMusic() : playMusic();
                              },
                              child: isPlaying ?
                                    const Icon(Icons.pause_circle, color: Color(0xfff9f295), size: 70,) :
                                const Icon(Icons.play_circle, color: Color(0xfff9f295), size: 70,)
                            ),
                            InkWell(
                              onTap: () {
                                skipNext();
                              },
                              child: const Icon(
                                Icons.skip_next, color: Color(0xfff9f295),
                                size: 70,),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
            })
        ),
      ),
    );
  }

  Widget headerTitles(){
    return Container(
      width: double.infinity,
      child: Column(
        children: const [
          Text("TuneMoon", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w600),),
          Text("Let Music Speak", style: TextStyle(fontSize: 25,
              color: Color(0xfff9f295), fontFamily: 'KaushanScript', fontWeight: FontWeight.w600),)
        ],
      ),
    );
  }

  Widget iconTitleArtistName(){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xfff9f295),
          )
      ),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 280,
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Image.asset('assets/images/logo1.png',),
          ),

          Container(
              width: double.infinity,
              alignment: Alignment.center,
              height: 50,
              decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xfff9f295)
                    ),
                  )
              ),
              child: TextScroll(
                audioPlayer.getCurrentAudioTitle,
                mode: TextScrollMode.endless,
                velocity: const Velocity(pixelsPerSecond: Offset(90, 0)),
                delayBefore: const Duration(milliseconds: 500),
                pauseBetween: const Duration(milliseconds: 0),
                style: const TextStyle(fontSize: 30, color: Colors.white),
                textAlign: TextAlign.center,
                intervalSpaces: 20,
              )
          ),

          Container(
            width: double.infinity,
            height: 50,
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Color(0xfff9f295)
                  ),
                )
            ),
            alignment: Alignment.center,
            child: Text(audioPlayer.getCurrentAudioArtist,
              style: const TextStyle(fontSize: 22, color: Colors.white70),
              maxLines: 1, overflow: TextOverflow.ellipsis,),
          )
        ],
      ),
    );
  }

  Widget sliderDurationPosition(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(position.toString().split(".")[0], style: const TextStyle(fontSize: 17, color: Colors.white),),
        Slider(
            activeColor: const Color(0xfff9f295),
            inactiveColor: Colors.white70,
            value: position.inSeconds.toDouble(),
            min: const Duration(microseconds: 0).inSeconds.toDouble(),
            max: duration!.inSeconds.toDouble() + 1.0,
            onChanged: (value){
              setState(() {
                changeToSecond(value.toInt());
                value = value;
              });
              // audioPlayer.seek(Duration(seconds: value.roundToDouble().round()));
              // value = value;
            }
        ),
        Text(duration.toString().split(".")[0], style: const TextStyle(fontSize: 17, color: Colors.white),),
      ],
    );
  }
}
