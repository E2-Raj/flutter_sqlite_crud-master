import 'dart:io';

import 'package:flutter_sqlite_crud/student_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;
  String id = 'id';
  String imageData = 'imageData';
  String pic = 'pic';
  String table = "student";
  String isolate = 'isolate';
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  /*
  Future<Database> get db async {
    if (_db != null) {
      print('data for db:$db');
      return _db;
    }
    _db = await initDatabase();
    print('start db:$db');
    return _db;
  }
*/

  Future<Database> get database async {
    if (_db != null) return _db;
    // lazily instantiate the db the first time it is accessed
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    try {
      print('INITDATABASE');
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      print('doc:$documentsDirectory.path');
      String path = join(documentsDirectory.path, "student.db");
      return await openDatabase(path, version: 2, onCreate: _onCreate);
    } catch (e) {
      print('error is: ${e.toString()}');
    }
  }

/*


  initDatabase() async {
    try {
      print('1');
      //WidgetsFlutterBinding.ensureInitialized();
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      print('docdir: $documentDirectory');
      print('doc:${documentDirectory.path}');
      String path = join(documentDirectory.path, 'student.db');
      print('path: $path');
      var db = await openDatabase(path, version: 1, onCreate: _onCreate);
      print('initdatabase: $db');
      return db;
    }

    */

/*
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'student.db');
      return await openDatabase(path, version: globalVariables.databaseVersion);
    }


*/
/*
    catch (e) {
      print('error of databse:${e.toString()}');
    }
  }
  */

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE student(id INTEGER , imageData BLOB NOT NULL,pic INTEGER, isolate TEXT)');
  }

  /* Future<int> add(Student student) async {
    var dbClient = await db;
    print('database for add:$db');
    return await dbClient.insert('student', student.toMap());
  }
*/
  Future<int> add(Student menuIcon) async {
    print('for add');
    try {
      print('for add1');
      Database db = await instance.database;
      print('INSERT');
      return await db.insert('student', menuIcon.toMap());
    } catch (e) {
      print('add error:${e.toString()}');
    }
    //  conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Student>> getPictures() async {
    Database dbClient = await database;
    List<Map<String, dynamic>> maps = await dbClient
        .query('student', columns: ['id', 'imageData', 'pic', 'isolate']);
    List<Student> pictures = [];
    if (maps.length > 0) {
      print('get images');
      return List.generate(maps.length, (i) {
        print('images for sqflite');
        return Student(
          id: maps[i][id],
          imageData: maps[i][imageData],
          pic: maps[i][pic],
          isolate: maps[i][isolate],
        );
      });
    } else {
      return null;
    }

    for (int i = 0; i < maps.length; i++) {
      // students.add(Student.fromMap(maps[i]));
      //   pictures.add(Student(maps[i]["id"], maps[i]["picture"]));
    }
  }

  Future<int> getCount() async {
    //database connection
    Database db = await this.database;
    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM student'));
    print('count of database: $count');
    return count;
  }

  Future<int> delete(int id) async {
    var dbClient = await database;
    return await dbClient.delete(
      'student',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Student student) async {
    var dbClient = await database;
    return await dbClient.update(
      'student',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}
