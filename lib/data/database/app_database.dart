import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scent_match.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Django'daki migration işleminin Flutter karşılığı
    await db.execute('''
      CREATE TABLE perfumes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        top_notes TEXT,
        middle_notes TEXT,
        base_notes TEXT,
        gender TEXT,
        description TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE user_collection (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        perfume_id INTEGER NOT NULL,
        added_at TEXT NOT NULL,
        FOREIGN KEY (perfume_id) REFERENCES perfumes (id) ON DELETE CASCADE
      )
    ''');
  }
}