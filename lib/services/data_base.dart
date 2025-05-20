import 'dart:convert';
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
          backdrop_path TEXT,
          overview TEXT,
          poster_path TEXT,
          release_date TEXT,
          vote_average REAL,
          original_language TEXT,
          popularity REAL,
          genres TEXT,
          runtime INTEGER
        )
      ''');

        await db.execute('''
        CREATE TABLE watchlist (
          id INTEGER PRIMARY KEY,
          title TEXT,
          backdrop_path TEXT,
          overview TEXT,
          poster_path TEXT,
          release_date TEXT,
          vote_average REAL,
          original_language TEXT,
          popularity REAL,
          genres TEXT,
          runtime INTEGER
        )
      ''');
      },
    );
  }


  static Future<bool> addFavorite(Movie movie) async {
    final db = await database;
    final movieMap = movie.toMap();

    if (movieMap['genres'] != null) {
      movieMap['genres'] = jsonEncode(movieMap['genres']);
    }

    final result = await db.insert(
      'favorites',
      movieMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('Ajout du film ${movie.title} avec succès ? $result');
    return result > 0;
  }

  static Future<bool> removeFavorite(int id) async {
    final db = await database;
    return (await db.delete('favorites', where: 'id = ?', whereArgs: [id])) == 1;
  }

  static Future<bool> isFavorite(int id) async {
    final db = await database;
    final result = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  static Future<List<Movie>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return maps.map((map) {
      // Décoder les genres JSON en List<String>
      if (map['genres'] != null && map['genres'] is String) {
        map['genres'] = List<String>.from(jsonDecode(map['genres']));
      }
      return Movie.fromMap(map);
    }).toList();
  }

  // Ajouter à la watchlist
  static Future<bool> addToWatchlist(Movie movie) async {
    final db = await database;
    return await db.insert(
      'watchlist',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ) > 0;
  }

  static Future<bool> removeFromWatchlist(int id) async {
    final db = await database;
    return await db.delete('watchlist', where: 'id = ?', whereArgs: [id]) > 0;
  }

  static Future<bool> isInWatchlist(int id) async {
    final db = await database;
    final result = await db.query('watchlist', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  static Future<List<Movie>> getWatchlist() async {
    final db = await database;
    final maps = await db.query('watchlist');
    return maps.map((map) => Movie.fromMap(map)).toList();
  }

}
