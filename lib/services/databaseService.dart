import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null)
      return _db!;
    else {
      _db = await getDatabase();
      return _db!;
    }
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = '$databaseDirPath/sudokuDb.db';
    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE sudoku(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR NOT NULL,
          result INTEGER,
          date VARCHAR NOT NULL,
          level INTEGER
        );''');
      },
    );
    return database;
  }
}
