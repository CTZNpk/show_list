import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/repository/home_screen_repository.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:show_list/shared/model/tmdb_datamodel.dart';

final homeScreenControllerProvider = Provider((ref) {
  HomeScreenRepository homeScreenRepository =
      ref.read(homeScreenRepositoryProvider);
  return HomeScreenController(homeScreenRepository: homeScreenRepository);
});

class HomeScreenController {
  HomeScreenController({
    required this.homeScreenRepository,
  });

  final HomeScreenRepository homeScreenRepository;

  Future<List<ShortTMDBDataModel>?> getTrendingMovies(int pageNumber) async {
    return await homeScreenRepository.getTrendingMovies(pageNumber);
  }

  Future<List<ShortTMDBDataModel>?> getPopularMovies(int pageNumber) async {
    return await homeScreenRepository.getPopularMovies(pageNumber);
  }

  Future<List<ShortTMDBDataModel>?> getBoxOfficeMovies(int pageNumber) async {
    return await homeScreenRepository.getNowPlayingMovies(pageNumber);
  }

  Future<List<ShortTMDBDataModel>?> getTopRatedMovies(
    int pageNumber,
  ) async {
    return await homeScreenRepository.getTopRatedMovies(pageNumber);
  }

  Future<List<ShortTMDBDataModel>?> getRecommendedMovies(
    String movieID,
    int pageNumber,
  ) async {
    return await homeScreenRepository.getRecommendedMovies(movieID, pageNumber);
  }

  Future<List<ShortTMDBDataModel>?> getTrendingShows(int pageNumber) async {
    return await homeScreenRepository.getTrendingShows(pageNumber);
  }

  Future<List<ShortTMDBDataModel>?> getTopRatedShows(int pageNumber) async {
    return await homeScreenRepository.getTopRatedShows(pageNumber);
  }

  Future<List<ShortTMDBDataModel>?> getPopularShows(int pageNumber) async {
    return await homeScreenRepository.getPopularShows(pageNumber);
  }

  Future<List<ShortTMDBDataModel>?> getRecommendedShows(
    String showID,
    int pageNumber,
  ) async {
    return await homeScreenRepository.getRecommendedShows(showID, pageNumber);
  }

  Future<List<ShortMalData>> getHighestRankedAnime(int pageNumber) async {
    return await homeScreenRepository.getHighestRankedAnime(pageNumber);
  }

  Future<List<ShortMalData>> getPopularAnime(int pageNumber) async {
    return await homeScreenRepository.getPopularAnime(pageNumber);
  }

  Future<List<ShortMalData>> getTopAiringAnime(int pageNumber) async {
    return await homeScreenRepository.getTopAiringAnime(pageNumber);
  }

  Future<List<ShortMalData>> getUpcomingAnime(int pageNumber) async {
    return await homeScreenRepository.getUpcomingAnime(pageNumber);
  }

  Future<String?> getImdbID(String tmdbID, ShowType showType) async {
    return await homeScreenRepository.getImdbID(tmdbID, showType);
  }

  Future<TMDBDataModel?> getTmdbData(String tmdbID, ShowType showType) async {
    return await homeScreenRepository.getTmdbData(tmdbID, showType);
  }

  Future<MalAnimeDataModel?> getAnimeDataFromID(String malID) async {
    return await homeScreenRepository.getAnimeDataFromID(malID);
  }

  Future<String?> getImdbRating(String imdbID) async {
    return await homeScreenRepository.getImdbRating(imdbID);
  }
}
