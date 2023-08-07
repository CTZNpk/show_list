import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/repository/mal_anime_data.dart';
import 'package:show_list/features/home_page/repository/trakt_data.dart';
import 'package:show_list/features/search_page/repository/mal_search.dart';
import 'package:show_list/features/search_page/repository/trakt_search.dart';
import 'package:show_list/shared/enums/show_type.dart';

final searchScreenRepositoryProvider =
    Provider((ref) => SearchScreenRepository());

class SearchScreenRepository {
  TraktData? traktData;
  MalAnimeData? malAnimeData;

  Future searchMovieAndShowsResults(String query, ShowType showType) async {
    if (showType == ShowType.movie) {
      traktData = TraktSearchMovie(query: query);
    } else {
      traktData = TraktSearchShow(query: query);
    }
    return await traktData?.getData();
  }

  Future searchAnimeShowResults(String query) async {
    malAnimeData = GetAnimeFromSearch(query: query);
    return await malAnimeData?.getData();
  }
}
