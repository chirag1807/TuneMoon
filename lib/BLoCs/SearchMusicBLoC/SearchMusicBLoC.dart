import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunemoon/BLoCs/SearchMusicBLoC/SearchMusicEvent.dart';
import 'package:tunemoon/BLoCs/SearchMusicBLoC/SearchMusicState.dart';
import 'package:http/http.dart' as http;
import 'package:tunemoon/model/SearchMusicDataClass.dart';

class SearchMusicBLoC extends Bloc<SearchMusicEvent, SearchMusicState>{
  SearchMusicBLoC() : super(SearchMusicInitialState()){
    on<SearchMusicLoadingEvent>((event, emit) {
      emit(SearchMusicLoadingState());
    });

    on<SearchMusicLoadedEvent>((event, emit) async {
      String keyword = event.keyword;
      emit(SearchMusicLoadingState());
      try{
        var baseUrl = "https://tunemoon-api.vercel.app/music";
        Uri url = Uri.parse("$baseUrl/bySearch?search=$keyword");
        var response = await http.get(url);
        if(response.statusCode == 200){
          var decoded = json.decode(response.body);
          List<SearchMusicDataClass> musics = [];
          for(var music in decoded){
            SearchMusicDataClass searchMusicDataClass = SearchMusicDataClass.fromJson(music);
            musics.add(searchMusicDataClass);
          }
          for(var item in musics){
            print(item.actors);
          }
          emit(SearchMusicLoadedState(musics));
        }
        else{
          emit(SearchMusicErrorState("Something Went Wrong...Please try again later"));
        }
      }
      catch(error){
        emit(SearchMusicErrorState(error.toString()));
      }
    });

    on<SearchMusicEmptyTextFieldEvent>((event, emit) => emit(SearchMusicTextFieldEmptyState(event.keyword)));
   }
  }