import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobile_parts_app/models/category_model.dart';
import 'package:mobile_parts_app/models/part_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mobile_parts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB); // Reset version to 1 for new app
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE parts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    await _seedCategories(db);
  }

  Future _seedCategories(Database db) async {
    final categories = [
      'LCD / Screen',
      'Battery',
      'Charging Port',
      'Camera',
      'Speaker',
      'Back Glass',
      'Motherboard',
      'Housing / Body',
      'Accessories',
    ];

    for (var name in categories) {
      await db.insert('categories', {'name': name});
    }
  }

  // Categories CRUD
  Future<int> createCategory(CategoryModel category) async {
    final db = await instance.database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<CategoryModel>> readAllCategories() async {
    final db = await instance.database;
    final result = await db.query('categories', orderBy: 'name ASC');
    return result.map((json) => CategoryModel.fromMap(json)).toList();
  }

  Future<int> deleteCategory(int id) async {
    final db = await instance.database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<int> updateCategory(CategoryModel category) async {
    final db = await instance.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }


  // Parts CRUD
  Future<int> createPart(PartModel part) async {
    final db = await instance.database;
    return await db.insert('parts', part.toMap());
  }

  Future<PartModel> readPart(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'parts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PartModel.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<PartModel>> readAllParts({String? query, int? categoryId, int limit = 20, int offset = 0}) async {
    final db = await instance.database;
    String? whereClause;
    List<dynamic>? whereArgs;

    if (query != null && query.isNotEmpty) {
      whereClause = 'name LIKE ?';
      whereArgs = ['%$query%'];
    }

    if (categoryId != null) {
      if (whereClause != null) {
        whereClause += ' AND category_id = ?';
        whereArgs!.add(categoryId);
      } else {
        whereClause = 'category_id = ?';
        whereArgs = [categoryId];
      }
    }

    final result = await db.query(
      'parts',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'id DESC', // Newest first
      limit: limit,
      offset: offset,
    );

    return result.map((json) => PartModel.fromMap(json)).toList();
  }

  Future<int> updatePart(PartModel part) async {
    final db = await instance.database;
    return db.update(
      'parts',
      part.toMap(),
      where: 'id = ?',
      whereArgs: [part.id],
    );
  }

  Future<int> deletePart(int id) async {
    final db = await instance.database;
    return await db.delete(
      'parts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
