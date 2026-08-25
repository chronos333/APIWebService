import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/movie.dart';

class DatabaseService {

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(
      await getDatabasesPath(),
      'cinefavorite.db',
    );

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            posterPath TEXT,
            rating REAL DEFAULT 0
          )
        ''');
      },
    );
  }

  // ADICIONAR
  static Future<void> addFavoriteMovie(
    Movie movie,
  ) async {
    final db = await database;

    await db.insert(
      'favorites',
      movie.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  // LISTAR
  static Future<List<Movie>>
      getFavoriteMovies() async {

    final db = await database;

    final result = await db.query(
      'favorites',
    );

    return result
        .map(
          (map) => Movie.fromMap(map),
        )
        .toList();
  }

  // DELETAR
  static Future<void> deleteFavoriteMovie(
    int id,
  ) async {
    final db = await database;

    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // RATING
  static Future<void> updateMovieRating(
    int id,
    double rating,
  ) async {
    final db = await database;

    await db.update(
      'favorites',
      {
        'rating': rating,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}