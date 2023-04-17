import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/harf.dart';
import '../models/harfharake.dart';
import '../models/letter.dart';
import '../models/user.dart';

class DbHelper {
  static final DbHelper dbProvider = DbHelper();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initializeDb();
    return _db!;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "elif.db");
    var elifDb = openDatabase(dbPath, version: 1, onCreate: createDb);
    return elifDb;
  }

  List<Map<String, dynamic>> _randomImages = [];

  Future<void> getRandomImages() async {
    // Veritabanına bağlan
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'your_database_name.db'),
    );
    final List<Map<String, dynamic>> allImages = await db.query('letters');
    _randomImages = allImages..shuffle();
    _randomImages = _randomImages.sublist(0, 10);
    await db.close();
  }

  List<String> getRandomImagePaths() {
    return _randomImages
        .map((Letter) => Letter['image_path'].toString())
        .toList();
  }

  void createDb(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,lastname TEXT,phone TEXT,address TEXT,username TEXT,password TEXT,email TEXT,isadmin INT)''');
    await db.execute(
        '''CREATE TABLE letters(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, annotation TEXT, image_path BLOB, music_path BLOB)''');
    await db.execute(
        '''CREATE TABLE harflersekil(id INTEGER PRIMARY KEY AUTOINCREMENT, harfname TEXT, harfannotation TEXT, harfimage_path BLOB, harfmusic_path BLOB)''');
    await db.execute(
        '''CREATE TABLE harflerharake(id INTEGER PRIMARY KEY AUTOINCREMENT, harfharakename TEXT, 
        harfharakeannotation TEXT, harfharakeimage_path BLOB, harfharakemusic_path BLOB,harfTur INT)''');
  }

  Future<List<Harfharake>> getHarfharake() async {
    Database? db = await this.db;
    var result = await db.query("harflerharake");
    return List.generate(result.length, (i) {
      return Harfharake.fromObject(result[i]);
    });
  }

  Future<int> insertHarfharake(
    Harfharake harf,
  ) async {
    Database? db = await this.db;
    var result = await db.insert("harflerharake", harf.toMap());
    return result;
  }

  Future<int> deleteHarfharake(int id) async {
    Database? db = await this.db;
    var result = await db.rawDelete("delete from harflerharake where id= $id");
    return result;
  }

  Future<int> updateHarfharake(Harfharake harf) async {
    Database? db = await this.db;
    var result = await db.update(" harflerharake ", harf.toMap(),
        where: "id=?", whereArgs: [harf.id]);
    return result;
  }

  Future<List<Harf>> getHarf() async {
    Database? db = await this.db;
    var result = await db.query("harflersekil");
    return List.generate(result.length, (i) {
      return Harf.fromObject(result[i]);
    });
  }

  Future<int> insertHarf(
    Harf harf,
  ) async {
    Database? db = await this.db;
    var result = await db.insert("harflersekil", harf.toMap());
    return result;
  }

  Future<int> deleteHarf(int id) async {
    Database? db = await this.db;
    var result = await db.rawDelete("delete from harflersekil where id= $id");
    return result;
  }

  Future<int> updateHarf(Harf harf) async {
    Database? db = await this.db;
    var result = await db.update(" harflersekil ", harf.toMap(),
        where: "id=?", whereArgs: [harf.id]);
    return result;
  }

  Future<List<Letter>> getLetters() async {
    Database? db = await this.db;
    var result = await db.query("letters");
    return List.generate(result.length, (i) {
      return Letter.fromObject(result[i]);
    });
  }

  Future<int> insertLetter(
    Letter letter,
  ) async {
    Database? db = await this.db;
    var result = await db.insert("letters", letter.toMap());
    return result;
  }

  Future<int> deleteLetter(int id) async {
    Database? db = await this.db;
    var result = await db.rawDelete("delete from letters where id= $id");
    return result;
  }

  Future<int> updateLetter(Letter letter) async {
    Database? db = await this.db;
    var result = await db.update(" letters ", letter.toMap(),
        where: "id=?", whereArgs: [letter.id]);
    return result;
  }

  Future<List<User>> getUser(id) async {
    Database? db = await this.db;
    var result = await db.query("users");
    return List.generate(result.length, (i) {
      return User.fromObject(result[i]);
    });
  }

  Future<int> insert(User user) async {
    Database? db = await this.db;
    var result = await db.insert("users", user.toMap());
    return result;
  }

  Future<int> delete(int id) async {
    Database? db = await this.db;
    var result = await db.rawDelete("delete from users where id= $id");
    return result;
  }

  Future<int> update(User user) async {
    Database? db = await this.db;
    var result = await db
        .update(" users ", user.toMap(), where: "id=?", whereArgs: [user.id]);
    return result;
  }

  Future<User?> checkUser(String username, String password) async {
    final db = await dbProvider.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result != null && result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<User?> checkUserGoogle(String username, String password) async {
    final db = await dbProvider.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result != null && result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<void> makeAdmin() async {
    final db = await openDatabase('elif.db');
    await db.update(
      'users',
      {'isadmin': 1},
      where: 'email LIKE ?',
      whereArgs: ['%@elifba.com'],
    );
  }

  Future<User?> checkEmail(String email) async {
    final db = await dbProvider.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'users',
      where: 'email = ? ',
      whereArgs: [email],
    );
    if (result != null && result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<User?> checkDeneme() async {
    final db = await dbProvider.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
  }

  Future<bool> kullaniciAdiKontrolEt(String kullaniciAdi) async {
    final db = await dbProvider.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [kullaniciAdi],
    );
    return result.isNotEmpty;
  }

  Future<List<Harfharake>> getharfustun() async {
    Database? db = await this.db;
    var result = await db!.query("harflerharake", where: "harfTur = '1'");
    return List.generate(
      result.length,
      (index) {
        return Harfharake.fromObject(result[index]);
      },
    );
  }

  Future<List<Harfharake>> getharfesre() async {
    Database? db = await this.db;
    var result = await db!.query("harflerharake", where: "harfTur = '2'");
    return List.generate(
      result.length,
      (index) {
        return Harfharake.fromObject(result[index]);
      },
    );
  }

  Future<List<Harfharake>> getharfotre() async {
    Database? db = await this.db;
    var result = await db!.query("harflerharake", where: "harfTur = '3'");
    return List.generate(
      result.length,
      (index) {
        return Harfharake.fromObject(result[index]);
      },
    );
  }
}
