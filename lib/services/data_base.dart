import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';


class DBService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'favorites.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE favorites (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        poster_path TEXT,
        release_date TEXT,
        vote_average REAL
  )
''');
        List<Map> result = await db.rawQuery("PRAGMA table_info(favorites)");
        result.forEach((row) => print(" ${row['name']} - ${row['type']}"));


      },
    );
  }

  static Future<bool> addFavorite(Movie movie) async {
    final db = await database;
    final movieMap = movie.toMap();

    return (await db.insert(
      'favorites',
      movieMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    ) == 1);
  }



  static Future<bool> removeFavorite(int id) async {
    final db = await database;
    return ( await db.delete('favorites', where: 'id = ?', whereArgs: [id]) == 1);
  }

  static Future<bool> isFavorite(int id) async {
    final db = await database;
    final result = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }



  static Future<List<Movie>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps.map((map) => Movie.fromMap(map)).toList();
  }
}