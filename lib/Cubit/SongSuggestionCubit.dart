import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunemoon/Cubit/SongSuggestionState.dart';
import 'package:tunemoon/model/SearchMusicDataClass.dart';
import 'package:http/http.dart' as http;
import 'package:tunemoon/config.dart';

class SongSuggestionCubit extends Cubit<SongSuggestionState> {
  SongSuggestionCubit() : super(SongSuggestionLoadingState()) {
    fetchSuggestionSongs();
  }

  List<SearchMusicDataClass> suggestionSongs = [];

  void fetchSuggestionSongs() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String singer1 =
          sp.getString("singer1") ?? sp.getStringList("selectedArtists")![0];
      String singer2;
      if (sp.getStringList("selectedArtists")!.length < 2) {
        singer2 =
            sp.getString("singer2") ?? sp.getStringList("selectedArtists")![1];
      } else {
        singer2 = sp.getString("singer2") ?? "Yo Yo Honey Singh";
      }
      String actor1 = sp.getString("actor1") ?? "Shahrukh Khan";
      String actor2 = sp.getString("actor2") ?? "Akshay Kumar";

      var baseUrl = "$apiBaseUrl/music";
      Uri url = Uri.parse(
          "$baseUrl/suggestionSearch?singer1=$singer1&singer2=$singer2&actor1=$actor1&actor2=$actor2");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        int i = 10;
        for (var music in decoded) {
          if (i > 0) {
            SearchMusicDataClass searchMusicDataClass =
                SearchMusicDataClass.fromJson(music);
            suggestionSongs.add(searchMusicDataClass);
            --i;
          } else {
            break;
          }
        }
        emit(SongSuggestionLoadedState(suggestionSongs));
      }
      else{
        emit(SongSuggestionErrorState("Something Went Wrong"));
      }
    } catch (error) {
      emit(SongSuggestionErrorState(error.toString()));
    }
  }
}
