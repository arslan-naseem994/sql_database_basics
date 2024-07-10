import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDatabase();
    return _db;
  }

// Inside your DBHelper class
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationCacheDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE student (email TEXT)');
  }

  Future<void> insert(String emailadd) async {
    var dbClient = await db;
    await dbClient!.insert(
      'student',
      {'email': emailadd.toString()},
    );
  }

  Future<List<Map<String, dynamic>>> getemail() async {
    final dbClient = await db;
    return dbClient!.query('student');
  }

  Future<int> delete(String email) async {
    var dbClient = await db;
    return await dbClient!
        .delete('student', where: 'email = ?', whereArgs: [email]);
  }
}





// _onCreate(Database db, int version) async {
//     await db.execute(
//         'CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )');
//   }


 Future<int> updateQuantity(Cart cart) async {
    var dbClient = await db;
    return await dbClient!
        .update('cart', cart.toMap(), where: 'id = ?', whereArgs: [cart.id]);
  }