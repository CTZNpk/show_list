import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/following_string_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:sqflite/sqflite.dart';

class InsertSql {
  late Database db;

  Future createListData(
      {ShortMalData? animeData, ShortTMDBDataModel? movieShowData}) async {
    db = await openDatabase('show_list_data.db');
    if (animeData != null) {
      await db.insert('animeList', animeData.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else if (movieShowData!.showType == ShowType.movie) {
      await db.insert('movieList', movieShowData.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.insert('showList', movieShowData.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    db.close();
  }

  Future createFollowingData(FollowingStringModel followingData) async {
    db = await openDatabase('show_list_data.db');
    await db.insert('followingPageData', followingData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    db.close();
  }
}
