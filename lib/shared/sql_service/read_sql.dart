import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/following_string_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:sqflite/sqflite.dart';

class ReadSql {
  late Database db;

  Future<List<FollowingStringModel>> readLocalFollowingData() async {
    db = await openDatabase('show_list_data.db');
    List<Map<String, dynamic>> followingMap =
        await db.query('followingPageData');
    await db.close();
    return List.generate(
      followingMap.length,
      (index) {
        return FollowingStringModel.fromMap(followingMap[index]);
      },
    );
  }

  Future<Map<String,ShortMalData>> readLocalAnimeData() async {
    db = await openDatabase('show_list_data.db');
    List<Map<String, dynamic>> animeDataMap = await db.query('animeList');
    await db.close();
    Map<String, ShortMalData> animeData = {};
    for (var data in animeDataMap) {
      final malData = ShortMalData.fromMap(data);
      animeData[malData.malID!] = malData;
    }
    return animeData;
  }

  Future<Map<String, ShortTMDBDataModel>> readLocalMovieData() async {
    db = await openDatabase('show_list_data.db');
    List<Map<String, dynamic>> movieDataMap = await db.query('movieList');
    await db.close();
    Map<String, ShortTMDBDataModel> movieData = {};
    for (var data in movieDataMap) {
      final tmdbData = ShortTMDBDataModel.fromMap(data, ShowType.movie);
      movieData[tmdbData.tmdbID] = tmdbData;
    }
    return movieData;
  }

  Future<Map<String, ShortTMDBDataModel>> readLocalShowData() async {
    db = await openDatabase('show_list_data.db');
    List<Map<String, dynamic>> movieDataMap = await db.query('showList');
    await db.close();
    Map<String, ShortTMDBDataModel> movieData = {};
    for (var data in movieDataMap) {
      final tmdbData = ShortTMDBDataModel.fromMap(data, ShowType.show);
      movieData[tmdbData.tmdbID] = tmdbData;
    }
    return movieData;
  }
}
