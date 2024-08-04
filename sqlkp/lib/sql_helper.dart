// sql_helper.dart
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        title TEXT, 
        description TEXT, 
        weight REAL DEFAULT 0.0, 
        height REAL DEFAULT 0.0, 
        age INTEGER,
        gender TEXT,
        birthdate TEXT,
        imagePath TEXT,
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'databaseapp.db',
      version: 5, // Increment the version number
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
      onUpgrade: (sql.Database database, int oldVersion, int newVersion) async {
        if (oldVersion < 5) {
          await database.execute("ALTER TABLE items ADD COLUMN birthdate TEXT");
          await database.execute("ALTER TABLE items ADD COLUMN imagePath TEXT");
        }
      },
    );
  }

  static Future<int> createItemWithImage(
      String title,
      String? description,
      double weight,
      double height,
      String gender,
      String birthdate,
      String imagePath) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'weight': weight,
      'height': height,
      'gender': gender,
      'birthdate': birthdate,
      'imagePath': imagePath,
    };

    final id = await db.insert(
      'items',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items');
  }

  static Future<int> updateItem(int id, String title, String? description,
      double weight, double height, String gender, String birthdate) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'weight': weight,
      'height': height,
      'gender': gender,
      'birthdate': birthdate,
      'updatedAt': DateTime.now().toString(),
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item $err");
    }
  }
}
