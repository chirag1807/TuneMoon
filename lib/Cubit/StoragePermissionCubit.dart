import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/Cubit/StoragePermissionState.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class StoragePermissionCubit extends Cubit<StoragePermissionState>{
  StoragePermissionCubit() : super(StoragePermissionInitialState()) {
    askPermission();
  }


  void askPermission() async {
    PermissionStatus? permissionStatus;
    permissionStatus = await Permission.storage.request();
    if(permissionStatus == PermissionStatus.granted){
      fetchStorageSongs();
    }
    else{
      emit(StoragePermissionNotGrantedState());
    }
  }


  final audioQuery = OnAudioQuery();
  List<SongModel> songs = [];

  void fetchStorageSongs() async {
    try{
      songs = await audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true
      );
      print(songs.length);
      emit(StoragePermissionGrantedState(songs));
    }
    catch(error){
      emit(StoragePermissionErrorState(error.toString()));
    }
  }

}