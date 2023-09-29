import 'package:riverpod/riverpod.dart';
import 'package:show_list/shared/model/following_string_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:show_list/shared/sql_service/initialize_delete_sql.dart';
import 'package:show_list/shared/sql_service/insert_sql.dart';
import 'package:show_list/shared/sql_service/read_sql.dart';

final sqlHelperProvider = Provider(
  (ref) {
    return SQLHelper(
        initAndDelSql: InitializeAndDeleteSql(),
        insertSql: InsertSql(),
        readSql: ReadSql());
  },
);

class SQLHelper {
  SQLHelper({
    required this.initAndDelSql,
    required this.insertSql,
    required this.readSql,
  });
  InitializeAndDeleteSql initAndDelSql;
  InsertSql insertSql;
  ReadSql readSql;

  Future createLocalTables() async {
    await initAndDelSql.createNewTables();
  }

  Future deleteLocalTables() async {
    await initAndDelSql.deleteLocalData();
  }

  Future insertIntoLocalList(
      {ShortTMDBDataModel? movieShowData, ShortMalData? animeData}) async {
    await insertSql.createListData(
        animeData: animeData, movieShowData: movieShowData);
  }

  Future insertIntoLocalFollowingData(
      FollowingStringModel followingData) async {
    await insertSql.createFollowingData(followingData);
  }

  Future<List<FollowingStringModel>> readLocalFollowingData() async {
    return await readSql.readLocalFollowingData();
  }

  Future<Map<String, ShortMalData>> readLocalAnimeData() async {
    return await readSql.readLocalAnimeData();
  }

  Future<Map<String, ShortTMDBDataModel>> readLocalMovieData() async {
    return await readSql.readLocalMovieData();
  }

  Future<Map<String, ShortTMDBDataModel>> readLocalShowData() async {
    return await readSql.readLocalShowData();
  }
}
