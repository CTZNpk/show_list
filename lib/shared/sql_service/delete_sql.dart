import 'package:sqflite/sqflite.dart';

class DeleteSql {
  late Database db;

  Future deleteFollowingDataBeforeTime(DateTime time) async {
    db = await openDatabase('show_list_data.db');
    db.delete('followingPageData ',
        where: 'time < ${time.millisecondsSinceEpoch}');

    db.close();
  }
}
