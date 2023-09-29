import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/repository/mal_anime_data.dart';
import 'package:show_list/features/home_page/repository/movie_db_data.dart';
import 'package:show_list/features/home_page/repository/tmdb_data.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:show_list/shared/model/tmdb_datamodel.dart';

final homeScreenRepositoryProvider = Provider((ref) => HomeScreenRepository());

class HomeScreenRepository {
  TMDBData? tmdbData;
  MovieDbData? movieDbData;
  MalAnimeData? malAnimeData;

  Future<List<ShortTMDBDataModel>?> getTrendingMovies(int pageNumber) async {
    try {
      tmdbData = TrendingMovies();
      return await tmdbData?.getData(pageNumber);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<ShortTMDBDataModel>?> getPopularMovies(int pageNumber) async {
    try {
      tmdbData = PopularMovies();
      return await tmdbData?.getData(pageNumber);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<ShortTMDBDataModel>?> getNowPlayingMovies(int pageNumber) async {
    try {
      tmdbData = NowPlayingMovies();
      return await tmdbData?.getData(pageNumber);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<ShortTMDBDataModel>?> getTopRatedMovies(int pageNumber) async {
    try {
      tmdbData = TopRatedMovies();
      return await tmdbData?.getData(pageNumber);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<ShortTMDBDataModel>?> getRecommendedMovies(
      String movieID, int pageNumber) async {
    try {
      tmdbData = RecommendedMovie(movieID: movieID);
      return await tmdbData?.getData(pageNumber);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<ShortTMDBDataModel>?> getTrendingShows(int pageNumber) async {
    try {
      tmdbData = TrendingShows();
      return await tmdbData?.getData(pageNumber);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<ShortTMDBDataModel>?> getPopularShows(int pageNumber) async {
    try {
      tmdbData = PopularShow();
      return await tmdbData?.getData(pageNumber);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<ShortTMDBDataModel>?> getTopRatedShows(int pageNumber) async {
    try {
      tmdbData = TopRatedShow();
      return await tmdbData?.getData(pageNumber);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<ShortTMDBDataModel>?> getRecommendedShows(
      String showID, int pageNumber) async {
    try {
      tmdbData = RecommendedShow(showID: showID);
      return await tmdbData?.getData(pageNumber);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<ShortMalData>> getHighestRankedAnime(int pageNumber) async {
    malAnimeData = GetAnimeFromRanking();
    return await malAnimeData?.getData(pageNumber);
  }

  Future<List<ShortMalData>> getPopularAnime(int pageNumber) async {
    malAnimeData = GetMostPopularAnime();
    return await malAnimeData?.getData(pageNumber);
  }

  Future<List<ShortMalData>> getTopAiringAnime(int pageNumber) async {
    malAnimeData = GetAiringAnime();
    return await malAnimeData?.getData(pageNumber);
  }

  Future<List<ShortMalData>> getUpcomingAnime(int pageNumber) async {
    malAnimeData = GetUpcomingAnime();
    return await malAnimeData?.getData(pageNumber);
  }

  Future<TMDBDataModel?> getTmdbData(String tmdbID, ShowType showType) async {
    try {
      tmdbData = GetTMDBData(tmdbID: tmdbID, showType: showType);
      return await tmdbData!.getData(1);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

Future<MalAnimeDataModel?> getAnimeDataFromID(String malID) async {
    try {
      malAnimeData = GetAnimeDataFromID(malID: malID);
      return await malAnimeData!.getData(1);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> getImdbID(String tmdbID, ShowType showType) async {
    try {
      tmdbData = GetIMDBID(tmdbID: tmdbID, showType: showType);
      return await tmdbData!.getData(1);
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
