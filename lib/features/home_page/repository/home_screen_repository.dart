import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/repository/mal_anime_data.dart';
import 'package:show_list/features/home_page/repository/movie_db_data.dart';
import 'package:show_list/features/home_page/repository/omdb_data.dart';
import 'package:show_list/features/home_page/repository/trakt_data.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/omdb_data_model.dart';
import 'package:show_list/shared/model/trakt_data_model.dart';

final homeScreenRepositoryProvider = Provider((ref) => HomeScreenRepository());

class HomeScreenRepository {
  OmdbData? omdbData;
  TraktData? traktData;
  MovieDbData? movieDbData;
  MalAnimeData? malAnimeData;

  Future<List<TraktDataModel>?> getTrendingMovies() async {
    try {
      traktData = GetTrendingMovies();
      return await traktData?.getData();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<TraktDataModel>?> getPopularMovies() async {
    try {
      traktData = GetPopularMovies();
      return await traktData?.getData();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<TraktDataModel>?> getBoxOfficeMovies() async {
    try {
      traktData = GetBoxOfficeMovies();
      return await traktData?.getData();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<TraktDataModel>?> getMostWatchedMovies() async {
    try {
      traktData = GetMostWatchedMovies();
      return await traktData?.getData();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<TraktDataModel>?> getTrendingShows() async {
    try {
      traktData = GetTrendingShows();
      return await traktData?.getData();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<TraktDataModel>?> getPopularShows() async {
    try {
      traktData = GetPopularShows();
      return await traktData?.getData();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<TraktDataModel>?> getMostWatchedShows(
      ) async {
    try {
      traktData = GetMostWatchedShows();
      return await traktData?.getData();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<MalAnimeDataModel>> getHighestRankedAnime() async {
    malAnimeData = GetAnimeFromRanking();
    return await malAnimeData?.getData();
  }

  Future<List<MalAnimeDataModel>> getPopularAnime() async {
    malAnimeData = GetMostPopularAnime();
    return await malAnimeData?.getData();
  }

  Future<List<MalAnimeDataModel>> getTopAiringAnime() async {
    malAnimeData = GetAiringAnime();
    return await malAnimeData?.getData();
  }

  Future<List<MalAnimeDataModel>> getUpcomingAnime() async {
    malAnimeData = GetUpcomingAnime();
    return await malAnimeData?.getData();
  }

  Future<OmdbDataModel?> getOmdbData(String imdbID) async {
    try {
      omdbData = GetShowData(imdbID: imdbID);
      OmdbDataModel? data = await omdbData?.getData();
      return data;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> getImdbRating(String imdbID) async {
    try {
      movieDbData = GetImdbRating(imdbID: imdbID);
      return movieDbData?.getData();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
