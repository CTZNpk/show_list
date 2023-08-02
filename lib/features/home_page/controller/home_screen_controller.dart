import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/repository/home_screen_repository.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/omdb_data_model.dart';
import 'package:show_list/shared/model/trakt_data_model.dart';

final homeScreenControllerProvider = Provider((ref) {
  HomeScreenRepository homeScreenRepository = HomeScreenRepository();
  return HomeScreenController(homeScreenRepository: homeScreenRepository);
});

class HomeScreenController {
  HomeScreenController({
    required this.homeScreenRepository,
  });

  final HomeScreenRepository homeScreenRepository;

  Future<List<TraktDataModel>?> getTrendingMovies() async {
    return await homeScreenRepository.getTrendingMovies();
  }

  Future<List<TraktDataModel>?> getPopularMovies() async {
    return await homeScreenRepository.getPopularMovies();
  }

  Future<List<TraktDataModel>?> getBoxOfficeMovies() async {
    return await homeScreenRepository.getBoxOfficeMovies();
  }

  Future<List<TraktDataModel>?> getMostWatchedMovies(
      ) async {
    return await homeScreenRepository.getMostWatchedMovies();
  }

  Future<List<TraktDataModel>?> getTrendingShows() async {
    return await homeScreenRepository.getTrendingShows();
  }

  Future<List<TraktDataModel>?> getMostWatchedShows(
      ) async {
    return await homeScreenRepository.getMostWatchedShows();
  }

  Future<List<TraktDataModel>?> getPopularShows() async {
    return await homeScreenRepository.getPopularShows();
  }

  Future<List<MalAnimeDataModel>> getHighestRankedAnime() async {
    return await homeScreenRepository.getHighestRankedAnime();
  }

  Future<List<MalAnimeDataModel>> getPopularAnime() async {
    return await homeScreenRepository.getPopularAnime();
  }

  Future<List<MalAnimeDataModel>> getTopAiringAnime() async {
    return await homeScreenRepository.getTopAiringAnime();
  }

  Future<List<MalAnimeDataModel>> getUpcomingAnime() async {
    return await homeScreenRepository.getUpcomingAnime();
  }

  Future<OmdbDataModel?> getOmdbData(
      String imdbID) async {
    return await homeScreenRepository.getOmdbData(imdbID);
  }

  Future<String?> getImdbRating(String imdbID) async {
    return await homeScreenRepository.getImdbRating(imdbID);
  }
}
