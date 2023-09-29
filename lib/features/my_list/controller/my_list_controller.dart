import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/my_list/repository/my_list_repository.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:show_list/shared/model/tmdb_datamodel.dart';

final myListControllerProvider = Provider((ref) {
  final myListRepository = ref.read(myListRepositoryProvider);
  return MyListController(myListRepository: myListRepository);
});

class MyListController {
  MyListController({required this.myListRepository});

  MyListRepository myListRepository;

  Future addToWatchList({
    MalAnimeDataModel? animeData,
    TMDBDataModel? movieShowData,
  }) async {
    await myListRepository.storeToWatch(
      animeData: animeData,
      movieShowData: movieShowData,
    );
  }

  Future<Map<String, ShortTMDBDataModel>?> getShowTypeDataFromFirebase(
      ShowType showType) async {
    return await myListRepository.getShowTypeDataFromFirebase(showType);
  }

  Future<Map<String, ShortMalData>?> getAnimeDataFromFirebase() async {
    return await myListRepository.getAnimeData();
  }

  Future getDataFromFirebase(String dataID, ShowType showType) async {
    return await myListRepository.getDataFromFirebaseFromID(dataID, showType);
  }
}
