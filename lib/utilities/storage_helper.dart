import 'dart:async';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';

class StorageHelper {
  static final StorageHelper _singleton = new StorageHelper._internal();

  factory StorageHelper() {
    return _singleton;
  }

  Completer<Database> _completer = Completer<Database>();
  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      return _completer.future;
    }
    return _db;
  }

  StorageHelper._internal() {
    _init();
  }

  _init() async {
    Database dbInstance = await openDatabase(
      join(await getDatabasesPath(), 'main.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS goals(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, timeToRemind INTEGER, start INTEGER)",
        );

        await db.execute(
          "CREATE TABLE IF NOT EXISTS keyVals(key TEXT PRIMARY KEY, value TEXT)",
        );

        await db.execute("CREATE UNIQUE INDEX idx_key_val ON keyVals(key)");
      },
      version: 1,
    );

    _completer.complete(dbInstance);
  }

  _save(String key, dynamic val) async {
    return (await db).rawInsert(
        'INSERT OR REPLACE INTO keyVals (key, value) VALUES (?, ?)',
        [key, jsonEncode(val)]);
  }

  Future<dynamic> _get(String key) async {
    final dbVal =
        await (await db).rawQuery('SELECT * from keyVals WHERE key = ?', [key]);
    if (dbVal == null || dbVal.length == 0) {
      return null;
    } else {
      return jsonDecode(dbVal[0]['value']);
    }
  }

  addGoal(Goal goal) async {
    final dbJson = goal.toDbJson;
    return (await db).rawInsert(
        'INSERT INTO goals (title, timeToRemind, start) VALUES (?, ?, ?)',
        [dbJson['title'], dbJson['remindAt'], dbJson['start']]);
  }

  updateGoal(Goal goal) async {
    final dbJson = goal.toDbJson;
    return (await db).rawInsert(
        'INSERT INTO goals (title, timeToRemind, start) VALUES (?, ?, ?)',
        [dbJson['title'], dbJson['remindAt'], dbJson['start']]);
  }

  deleteGoal(int id) async {
    return (await db).rawDelete('DELETE FROM goals WHERE id = ?', [id]);
  }

  fetchGoals() async {
    final List<Goal> _goals = [];
    // TODO: Make select query smart
    final dbVals = await (await db).rawQuery('SELECT * FROM goals');
    if (dbVals != null && dbVals.isNotEmpty) {
      dbVals.forEach((val) => _goals.add(Goal.fromDbJson(val)));
    }
    return _goals;
  }

  getName() async {
    return this._get(StorageKeys.name);
  }

  setName(String name) async {
    this._save(StorageKeys.name, name);
  }

  getAvatar() async {
    return this._get(StorageKeys.avatar);
  }

  setAvatar(bool isMale) async {
    this._save(StorageKeys.avatar, isMale);
  }
}
