import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/posts/data/models/post_model.dart';

class DatabaseHelper {
  static Database? _database;

  static const _databaseName = 'app_database.db';
  static const _databaseVersion = 1;

  static const tablePosts = 'posts';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT NOT NULL,
        body TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertPost(PostModel post) async {
    final db = await database;

    return await db.insert(
      tablePosts,
      post.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PostModel>> getPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tablePosts,
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (i) {
      return PostModel.fromJson(maps[i]);
    });
  }
}
