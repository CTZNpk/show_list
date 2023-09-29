import 'package:sqflite/sqflite.dart';

class InitializeAndDeleteSql {
  late Database db;

  Future createNewTables() async {
    db = await openDatabase('show_list_data.db');
    await _createFollowingTable();
    await _createListTable();
    db.close();
  }

  Future deleteLocalData() async {
    await deleteDatabase('show_list_data.db');
  }

  Future _createFollowingTable() async {
    await db.execute('CREATE TABLE IF NOT EXISTS followingPageData (info TEXT, time INT)');
  }

  Future _createListTable() async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS movieList (id TEXT PRIMARY KEY, imdb_id TEXT, number_of_episodes INT, plan_type TEXT, poster_path TEXT, title TEXT, user_rating INT, vote_average TEXT, watched_episodes INT, watched_time INT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS showList (id TEXT PRIMARY KEY, imdb_id TEXT, number_of_episodes INT, plan_type TEXT, poster_path TEXT, title TEXT, user_rating INT, vote_average TEXT, watched_episodes INT, watched_time INT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS animeList (id TEXT PRIMARY KEY, poster TEXT, plan_type TEXT, title TEXT, user_rating INT, mean TEXT, num_episodes_watched INT, watched_time INT, num_episodes INT)');
  }
}
