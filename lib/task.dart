import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'package:sqflite/sqflite.dart';

class Task {
  final String title;
  final String description;
  final String category;

  const Task(
      {required this.title, required this.description, required this.category});

  Task.copy(Task from) :
    title = from.title,
    description = from.description,
    category = from.category;


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Task{title: $title, desc: $description, cat: $category}';
  }
}

class TaskProvider {
  static const String tableName = 'tasks';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnCategory = 'category';

  static Future<sql.Database> database() async {
    return openDatabase(join(await getDatabasesPath(), 'tasks.db'), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE tasks(title TEXT PRIMARY KEY, description TEXT, category TEXT)');
    });
  }

  static Future<void> insertTask(Task task) async {
    final db = await database();
    db.insert(
      tableName,
      task.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Task>> getAllTasks() async {
    // Get a reference to the database.
    final db = await database();
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Task(
          title: maps[i]['title'],
          description: maps[i]['description'],
          category: maps[i]['category']);
    });
  }

  Future<Task?> getTask(String title) async {
    final db = await database();
    List<Map> maps = await db.query(tableName,
        columns: [columnTitle, columnCategory, columnDescription],
        where: '$columnTitle = ?',
        whereArgs: [title]);
    if (maps.length > 0) {
      Map map = maps.first;
      return Task(
          title: map[columnTitle],
          description: columnDescription,
          category: columnCategory);
    }
    return null;
  }

  static Future<void> updateTask(Task task) async {
    final db = await database();

    await db.update(
      tableName,
      task.toMap(),
      where: 'title = ?',
      whereArgs: [task.title],
    );
  }

  static Future<void> deleteTask(String title) async {
    final db = await database();

    await db.delete(
      tableName,
      where: 'title = ?',
      // Pass the id as a whereArg to prevent SQL injection.
      whereArgs: [title],
    );
  }

  static Future close() async {
    final db = await database();
    db.close();
  }
}
