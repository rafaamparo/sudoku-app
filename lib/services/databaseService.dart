import 'package:sqflite/sqflite.dart';
import 'package:sudoku/models/jogo.dart';

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
      version: 1,
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

  Future<Jogo> addPartida(String nomeJogador, int nivel) async {
    final data = DateTime.now();
    final dataFormatada =
        '${data.day}/${data.month}/${data.year} at ${data.hour}:${data.minute}:${data.second}';
    final db = await this.database;
    await db.rawInsert(
        'INSERT INTO sudoku(name, result, date, level) VALUES(?, ?, ?, ?)',
        [nomeJogador, 0, dataFormatada, nivel]);
    final partidaCriada = await db.rawQuery(
        'SELECT * FROM sudoku WHERE name = ? AND date = ?',
        [nomeJogador, dataFormatada]);
    final partida = Jogo(
        id: partidaCriada[0]['id'] as int,
        name: partidaCriada[0]['name'] as String,
        result: partidaCriada[0]['result'] as int,
        date: partidaCriada[0]['date'] as String,
        level: partidaCriada[0]['level'] as int);
    return partida;
  }

  void updateResultadoPartida(int idPartida, int resultado) async {
    final db = await this.database;
    await db.rawUpdate(
        'UPDATE sudoku SET result = ? WHERE id = ?', [resultado, idPartida]);
  }

  Future<List<Jogo>> buscarPartidas({int dificuldade = -1}) async {
    final db = await this.database;
    if (dificuldade != -1) {
      final partidas = await db.rawQuery(
          'SELECT * FROM sudoku WHERE level = ? ORDER BY date DESC',
          [dificuldade]);
      var listaPartidas = <Jogo>[];
      for (var partida in partidas) {
        listaPartidas.add(Jogo(
            id: partida['id'] as int,
            name: partida['name'] as String,
            result: partida['result'] as int,
            date: partida['date'] as String,
            level: partida['level'] as int));
      }
      return listaPartidas;
    }
    final partidas = await db.rawQuery('SELECT * FROM sudoku');
    var listaPartidas = <Jogo>[];
    for (var partida in partidas) {
      listaPartidas.add(Jogo(
          id: partida['id'] as int,
          name: partida['name'] as String,
          result: partida['result'] as int,
          date: partida['date'] as String,
          level: partida['level'] as int));
    }
    return listaPartidas;
  }
}
