import 'package:on_audio_query/on_audio_query.dart';

abstract class StoragePermissionState{}

class StoragePermissionInitialState extends StoragePermissionState{}

class StoragePermissionGrantedState extends StoragePermissionState{
  List<SongModel> songs;
  StoragePermissionGrantedState(this.songs);
}

class StoragePermissionNotGrantedState extends StoragePermissionState{}

class StoragePermissionErrorState extends StoragePermissionState{
  String errorMsg;
  StoragePermissionErrorState(this.errorMsg);
}