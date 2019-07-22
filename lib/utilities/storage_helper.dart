import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:twenty_one_days/screens/goals_list/goals_list.models.dart';

class Singleton {
  static final Singleton _singleton = new Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Future<Database> db;

  Singleton._internal() {
    _init();
  }

  _init() async {
    await openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE goals(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, timeToRemind TEXT)",
        );
      },
      version: 1,
    );
  }

  addGoal(Goal goal) async {
    final dbJson = goal.toDbJson;
    return (await db).rawInsert(
        'INSERT INTO goals (title, timeToRemind) VALUES (?, ?)',
        [dbJson['title'], dbJson['remindAt']]);
  }

  updateGoal(Goal goal) async {
    final dbJson = goal.toDbJson;
    return (await db).rawInsert(
        'INSERT INTO goals (title, timeToRemind) VALUES (?, ?)',
        [dbJson['title'], dbJson['remindAt']]);
  }
}
