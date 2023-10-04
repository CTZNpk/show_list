import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/my_list/controller/my_list_controller.dart';
import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:show_list/shared/model/tmdb_datamodel.dart';
import 'package:show_list/shared/sql_service/sql_services.dart';

final mainLayoutRepositoryProvider = ChangeNotifierProvider(
  (ref) => MainLayoutRepository(ref: ref),
);

class MainLayoutRepository extends ChangeNotifier {
  MainLayoutRepository({required this.ref});

  ChangeNotifierProviderRef<Object?> ref;
  Map<String, ShortTMDBDataModel> movieList = {};
  Map<String, ShortTMDBDataModel> showList = {};
  Map<String, ShortMalData> animeList = {};

  Map<String, dynamic> getDataFromAPlanType(
      ShowType showType, PlanType planType) {
    Map<String, dynamic> toWatchList = {};
    Map<String, dynamic> fromList;
    if (showType == ShowType.movie) {
      fromList = movieList;
    } else if (showType == ShowType.show) {
      fromList = showList;
    } else {
      fromList = animeList;
    }

    for (var movie in fromList.values) {
      if (movie.planType == planType) {
        if (showType == ShowType.anime) {
          toWatchList[movie.malID] = movie;
        } else {
          toWatchList[movie.tmdbID] = movie;
        }
      }
    }
    return toWatchList;
  }

  void changeDataAndNotify(dynamic data, ShowType showType) {
    if (showType == ShowType.movie) {
      movieList[data.tmdbID] = data;
      ref.read(sqlHelperProvider).insertIntoLocalList(movieShowData: data);
    } else if (showType == ShowType.show) {
      showList[data.tmdbID] = data;
      ref.read(sqlHelperProvider).insertIntoLocalList(movieShowData: data);
    } else {
      ref.read(sqlHelperProvider).insertIntoLocalList(animeData: data);
      animeList[data.malID] = data;
    }
    notifyListeners();
  }

  Map<String, dynamic> getData(ShowType showType) {
    if (showType == ShowType.movie) {
      return movieList;
    } else if (showType == ShowType.show) {
      return showList;
    } else {
      return animeList;
    }
  }

  Future addToMovieList(TMDBDataModel movieData) async {
    await ref
        .read(myListControllerProvider)
        .addToWatchList(movieShowData: movieData.toShortTMDBDataModel());

    movieList[movieData.tmdbID] = movieData.toShortTMDBDataModel();
    ref
        .read(sqlHelperProvider)
        .insertIntoLocalList(movieShowData: movieData.toShortTMDBDataModel());

    notifyListeners();
  }

  Future addToShowList(TMDBDataModel showData) async {
    await ref
        .read(myListControllerProvider)
        .addToWatchList(movieShowData: showData.toShortTMDBDataModel());
    showList[showData.tmdbID] = showData.toShortTMDBDataModel();
    ref
        .read(sqlHelperProvider)
        .insertIntoLocalList(movieShowData: showData.toShortTMDBDataModel());
    notifyListeners();
  }

  Future addToAnimeList(MalAnimeDataModel animeData) async {
    await ref
        .read(myListControllerProvider)
        .addToWatchList(animeData: animeData.toShortMalData());
    animeList[animeData.malId] = animeData.toShortMalData();
    ref
        .read(sqlHelperProvider)
        .insertIntoLocalList(animeData: animeData.toShortMalData());
    notifyListeners();
  }

  void resetLists() {
    movieList = {};
    animeList = {};
    showList = {};
  }

  Future requestDataFromLocalLists() async {
    movieList = await ref.read(sqlHelperProvider).readLocalMovieData();
    showList = await ref.read(sqlHelperProvider).readLocalShowData();
    animeList = await ref.read(sqlHelperProvider).readLocalAnimeData();
  }

  Future requestDataFromFirebase() async {
    movieList = await ref
            .read(myListControllerProvider)
            .getShowTypeDataFromFirebase(ShowType.movie) ??
        {};
    for (var movie in movieList.values) {
      await ref
          .read(sqlHelperProvider)
          .insertIntoLocalList(movieShowData: movie);
    }
    showList = await ref
            .read(myListControllerProvider)
            .getShowTypeDataFromFirebase(ShowType.show) ??
        {};
    for (var show in showList.values) {
      await ref
          .read(sqlHelperProvider)
          .insertIntoLocalList(movieShowData: show);
    }
    animeList =
        await ref.read(myListControllerProvider).getAnimeDataFromFirebase() ??
            {};
    for (var anime in animeList.values) {
      await ref.read(sqlHelperProvider).insertIntoLocalList(animeData: anime);
    }

    notifyListeners();
  }
}
