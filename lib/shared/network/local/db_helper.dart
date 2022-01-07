import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as sys_path;

abstract class DBHelper {
  static Future<sql.Database> database() async {
    // get the right path for storing app database
    final dbPath = await sql.getDatabasesPath();
    // open database and return it
    return await sql.openDatabase(sys_path.join(dbPath, 'visual note.db'),
        onCreate: (database, version) async {
      database.execute(
          'CREATE TABLE visual_notes(id INTEGER Primary KEY,image TEXT,title TEXT,description TEXT,'
          'date TEXT,time TEXT,status INTEGER)');
    }, version: 1);
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    //access the database
    final sqlDatabase = await DBHelper.database();
    // insert this data into this table
    return await sqlDatabase.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    //access the database
    final sqlDatabase = await DBHelper.database();
    //fetch all the data records of this table
    return await sqlDatabase.query(table);
  }

  static Future<void> delete(String table, int id) async {
    //access the database
    final sqlDatabase = await DBHelper.database();
    // insert this data into this table
    await sqlDatabase.delete(table, where: 'id=?', whereArgs: [id]);
  }

  static Future<void> update(String table, Map<String, dynamic> data, int id) async {
    //access the database
    final sqlDatabase = await DBHelper.database();
    // insert this data into this table
    await sqlDatabase.update(table, data,
        where: 'id=?', whereArgs: [id], conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
}
