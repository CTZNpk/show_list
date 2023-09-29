import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/repository/mal_anime_data.dart';
import 'package:show_list/features/home_page/repository/tmdb_data.dart';
import 'package:show_list/features/search_page/repository/tmdb_search.dart';
import 'package:show_list/features/search_page/repository/mal_search.dart';
import 'package:show_list/features/search_page/widgets/display_search_results.dart';
import 'package:show_list/shared/enums/show_type.dart';

final searchScreenRepositoryProvider =
    Provider((ref) => SearchScreenRepository());

class SearchScreenRepository {
  TMDBData? traktData;
  MalAnimeData? malAnimeData;

  Future searchMovieAndShowsResults(
      String query, ShowType showType, int pageNumber) async {
    if (showType == ShowType.movie) {
      traktData = TmdbSearchMovie(query: query);
    } else {
      traktData = TmdbSearchShow(query: query);
    }
    return await traktData?.getData(pageNumber);
  }

  Future searchMoviesAndShowWithFilters(FilterSearchWrapper filterSearch,
      ShowType showType, int pageNumber) async {
    if (showType == ShowType.movie) {
      traktData = TmdbSearchMovieWithFilters(filterSearch: filterSearch);
    } else {
      traktData = TmdbSearchShowWithFilters(filterSearch: filterSearch);
    }
    return await traktData?.getData(pageNumber);
  }

  Future searchAnimeShowResults(String query) async {
    malAnimeData = GetAnimeFromSearch(query: query);
    return await malAnimeData?.getData(1);
  }
}
