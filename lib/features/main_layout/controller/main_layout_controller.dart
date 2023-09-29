import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/main_layout/repository/main_layout_repository.dart';
import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/tmdb_datamodel.dart';

final mainLayoutControllerProvider = Provider(
  (ref) {
    var mainRepository = ref.watch(mainLayoutRepositoryProvider);
    return MainLayoutController(mainLayoutRepository: mainRepository);
  },
);

class MainLayoutController {
  MainLayoutController({required this.mainLayoutRepository});

  final MainLayoutRepository mainLayoutRepository;

  Map<String, dynamic> getDataFromAPlanType(
      ShowType showType, PlanType planType) {
    return mainLayoutRepository.getDataFromAPlanType(showType, planType);
  }

  void changeDataAndNotify(dynamic data, ShowType showType) {
    mainLayoutRepository.changeDataAndNotify(data, showType);
  }

  Map<String, dynamic> getDataFromShowType(ShowType showType) {
    return mainLayoutRepository.getData(showType);
  }

  Future addToMovieList(TMDBDataModel movieData) async {
    return mainLayoutRepository.addToMovieList(movieData);
  }

  Future addToShowList(TMDBDataModel showData) async {
    return mainLayoutRepository.addToShowList(showData);
  }

  Future addToAnimeList(MalAnimeDataModel animeData) async {
    return mainLayoutRepository.addToAnimeList(animeData);
  }

  void resetLists() {
    mainLayoutRepository.resetLists();
  }

  Future requestDataFromLocalSql() async {
    await mainLayoutRepository.requestDataFromLocalLists();
  }

  Future requestDataFromFirebase() async {
    await mainLayoutRepository.requestDataFromFirebase();
  }
}
