import 'dart:async';
import 'package:elifbauygulamasi/models/bitisik.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Log.dart';
import '../models/game.dart';
import '../models/harf.dart';
import '../models/harfharake.dart';
import '../models/letter.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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

  void createDb(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,lastname TEXT,phone TEXT,
        address TEXT,username TEXT,password TEXT,email TEXT,isadmin INTEGER,isVerified INTEGER,hesapAcik INTEGER)''');
    await db.execute(
        '''CREATE TABLE letters(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, annotation TEXT, image_path BLOB, music_path BLOB)''');
    await db.execute(
        '''CREATE TABLE harflersekil(id INTEGER PRIMARY KEY AUTOINCREMENT, harfname TEXT, harfannotation TEXT, harfimage_path BLOB, harfmusic_path BLOB)''');
    await db.execute(
        '''CREATE TABLE harflerharake(id INTEGER PRIMARY KEY AUTOINCREMENT, harfharakename TEXT, 
        harfharakeannotation TEXT, harfharakeimage_path BLOB, harfharakemusic_path BLOB,harfTur INT)''');
    await db.execute(
        '''CREATE TABLE sureler(id INTEGER PRIMARY KEY AUTOINCREMENT, sureadi TEXT, 
        sureanlami TEXT,sureanlamiarapca TEXT,suremusic_path BLOB,hangisure INT)''');
    await db.execute(
        '''CREATE TABLE birlestirme(id INTEGER PRIMARY KEY AUTOINCREMENT, harfinadi TEXT, 
        harfinaciklamasi TEXT,ses_path BLOB, image_path BLOB)''');
    await db.execute(
        '''CREATE TABLE game(id INTEGER PRIMARY KEY AUTOINCREMENT,kullaniciId INTEGER ,level TEXT, 
       durum INTEGER,seviyeKilit INTEGER)''');
    await db.execute(
        '''CREATE TABLE log (id INTEGER PRIMARY KEY AUTOINCREMENT, kullaniciId INTEGER,
        girisTarih TEXT,cikisTarih TEXT,kayitTarih TEXT,
        name TEXT,lastname TEXT,username TEXT,durum INTEGER,yapilanIslem TEXT,
        yapilanIslemders TEXT,yapilanIslemoyun TEXT,
        FOREIGN KEY (kullaniciId) 
        REFERENCES users(id) ON DELETE CASCADE)''');
  }

  Future<List<Log>> getLog() async {
    Database? db = await this.db;
    var result = await db.query("log");
    return List.generate(result.length, (i) {
      return Log.fromObject(result[i]);
    });
  }

  Future<List<Log>> getLogusername(String kullaniciAdi) async {
    Database? db = await this.db;
    var result =
        await db.query("log", where: 'username = ?', whereArgs: [kullaniciAdi]);
    return List.generate(result.length, (i) {
      return Log.fromObject(result[i]);
    });
  }

  Future<int> insertLog(
    Log log,
  ) async {
    Database? db = await this.db;
    var result = await db.insert("log", log.toMap());
    return result;
  }

  Future<int> deleteLog(int id) async {
    Database? db = await this.db;
    var result = await db.rawDelete("delete from log where id= $id");
    return result;
  }

  Future<int> updateLog(Log log) async {
    Database? db = await this.db;
    var result = await db
        .update(" log ", log.toMap(), where: "id=?", whereArgs: [log.id]);
    return result;
  }

  Future<List<Game>> getGame() async {
    Database? db = await this.db;
    var result = await db.query("game");
    return List.generate(result.length, (i) {
      return Game.fromObject(result[i]);
    });
  }

  Future<int> insertGame(
    Game game,
  ) async {
    Database? db = await this.db;
    var result = await db.insert("game", game.toMap());
    return result;
  }

  Future<int> deleteGame(int id) async {
    Database? db = await this.db;
    var result = await db.rawDelete("delete from game where id= $id");
    return result;
  }

  Future<int> updateGame1(Game game, String level) async {
    Database? db = await this.db;
    var result = await db.update(
      "game",
      game.toMap(),
      where: "kullaniciId = ? AND level = ?",
      whereArgs: [game.kullaniciId, level],
    );
    return result;
  }

  Future<List<BitisikHarfler>> getBitisikHarf() async {
    Database? db = await this.db;
    var result = await db.query("birlestirme");
    return List.generate(result.length, (i) {
      return BitisikHarfler.fromObject(result[i]);
    });
  }

  Future<int> insertBitisikHarf(
    BitisikHarfler harf,
  ) async {
    Database? db = await this.db;
    var result = await db.insert("birlestirme", harf.toMap());
    return result;
  }

  Future<int> deleteBitisikHarf(int id) async {
    Database? db = await this.db;
    var result = await db.rawDelete("delete from birlestirme where id= $id");
    return result;
  }

  Future<int> updateBitisikHarf(BitisikHarfler harf) async {
    Database? db = await this.db;
    var result = await db.update(" birlestirme ", harf.toMap(),
        where: "id=?", whereArgs: [harf.id]);
    return result;
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

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<int> insert(User user) async {
    int isAdmin = user.email!.endsWith('@elifba.com') ? 1 : 0;
    int isVerified = user.email!.endsWith('@elifba.com')
        ? 1
        : (user.isVerified != null ? 1 : 0);
    String hashedPassword = hashPassword(user.password!);
    Database? db = await this.db;
    var result = await db.insert("users", {
      "username": user.username,
      "password": hashedPassword,
      "email": user.email,
      "name": user.name,
      "address": user.address,
      "lastname": user.lastname,
      "phone": user.phone,
      "isadmin": isAdmin,
      "isVerified": isVerified, // true için 1, false   için 0 olarak kaydet
    });
    return result;
  }

  Future<int> delete(int id) async {
    Database? db = await this.db;
    var result = await db.rawDelete("delete from users where id= $id");
    return result;
  }

  Future<int> update(User user) async {
    Database? db = await this.db;
    String hashedPassword = hashPassword(user.password!);
    var result = await db.update(
        " users ", {...user.toMap(), 'password': hashedPassword},
        where: "id=?", whereArgs: [user.id]);
    return result;
  }

  Future<int> updateUserhesap(User user) async {
    Database? db = await this.db;
    var result = await db?.update(
      "users",
      {
        "hesapAcik": 1,
      },
      where: "id = ?",
      whereArgs: [user.id],
    );
    return result ?? 0;
  }

  Future<int> updateUser(User user) async {
    Database? db = await this.db;
    var result = await db.update(
      "users",
      {
        "username": user.username,
        "email": user.email,
        "name": user.name,
        "address": user.address,
        "lastname": user.lastname,
        "phone": user.phone,
        "isadmin": 0,
        "isVerified": 1,
        "hesapAcik": 0,
      },
      where: "id = ?",
      whereArgs: [user.id],
    );
    return result;
  }
  Future<User?> getUserByUsername(String username) async {
    final db = await this.db;
    final maps = await db.query('users', where: 'username = ?', whereArgs: [username]);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }

    return null;
  }

  Future<User?> autoLoginCompany() async {
    Database? db = await this.db;

    var compRes = await db!.query('users',
        where: 'hesapAcik = ?',
        whereArgs: [1],
        limit: 1);

    if (compRes.isNotEmpty) {
      var user = User.fromObject(compRes.first);
      user.hesapAcik = 1;
      await db.update('users', user.toMap(),
          where: 'id = ?', whereArgs: [user.id]);
      return user;
    }
    return null;
  }

  Future<User?> checkUser(String username, String password) async {
    final db = await dbProvider.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashPassword(password)],
    );
    if (result != null && result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }
  Future<int> updateUserhesapById(int userId, int newValue) async {
    Database? db = await this.db;
    var result = await db.update(
      "users",
      {"hesapAcik": newValue},
      where: "id = ?",
      whereArgs: [userId],
    );
    return result;
  }
  Future<User?> getUserWithHesapDurum(int hesapDurum) async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'hesapDurum = ?',
      whereArgs: [hesapDurum],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }

    return null;
  }

  Future<User?> getCurrentUser() async {
    Database? db = await this.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'users',
      where: 'hesapAcik = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (result != null && result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<User?> getUserByEmail(String mail) async {
    final db = await dbProvider.db;
    final result =
        await db.query('users', where: 'email = ?', whereArgs: [mail]);
    if (result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<User?> getUserByLogEmail(String kullaniciAdi) async {
    final db = await dbProvider.db;
    final result = await db
        .query('users', where: 'username = ?', whereArgs: [kullaniciAdi]);
    if (result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<User?> getUserByPassword(String password, int id) async {
    final db = await dbProvider.db;
    final result = await db.query('users',
        where: 'password = ?', whereArgs: [hashPassword(password)]);
    if (result.isNotEmpty) {
      return User.fromObject(result.first);
    } else {
      return null;
    }
  }

  Future<Game?> getGameById(
    int id,
  ) async {
    final db = await dbProvider.db;
    final gameMap = await db.query(
      'game',
      where: 'kullaniciId = ?',
      whereArgs: [id],
    );
    if (gameMap.isNotEmpty) {
      return Game.fromObject(gameMap.first);
    } else {
      return null;
    }
  }

  Future<User?> getUserById(
    int id,
  ) async {
    final db = await dbProvider.db;
    final userMap = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (userMap.isNotEmpty) {
      return User.fromObject(userMap.first);
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

  Future<bool> mailkontrolet(String mail) async {
    final db = await dbProvider.db;
    if (db == null) {
      throw Exception('Veritabanı bağlantısı kurulamadı');
    }
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [mail],
    );
    return result.isNotEmpty;
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

  Future<int?> getGameStatusByUserIdAndLevel(
      int kullaniciId, String level) async {
    Database? db = await this.db;
    var result = await db.query(
      'game',
      where: 'kullaniciId = ? AND level = ?',
      whereArgs: [kullaniciId, level],
    );

    if (result.isEmpty) {
      return null; // No matching record found
    }

    final Map<String, dynamic> row = result.first;
    return row['durum'] as int?;
  }

  Future<int?> getGameStatusByUserIdAndLevelkilit(
      int kullaniciId, int level) async {
    Database? db = await this.db;
    var result = await db.query(
      'game',
      where: 'kullaniciId = ? AND level = ?',
      whereArgs: [kullaniciId.toString(), level.toString()],
    );

    if (result.isEmpty) {
      return null; // No matching record found
    }

    final Map<String, dynamic> row = result.first;
    int seviyeKilit = row['seviyeKilit'] as int;
    return seviyeKilit;
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

  Future<Game?> queryGame(int userId) async {
    Database? db = await this.db;
    var games = await db.query('game',
        where: 'kullaniciId = ?', whereArgs: [userId], limit: 1);

    if (games.isNotEmpty) {
      return Game.fromMap(games.first);
    }

    return null;
  }

  Future<bool> checkGameExists(int? userId) async {
    var result = await queryGame(userId!);
    return result != null;
  }

  Future<Log?> Loggiris(int userId) async {
    Database? db = await this.db;
    var log = await db.query('log',
        where: 'kullaniciId = ?', whereArgs: [userId], limit: 1);

    if (log.isNotEmpty) {
      return Log.fromMap(log.first);
    }

    return null;
  }

  Future<bool> checklog(int? userId) async {
    var result = await Loggiris(userId!);
    return result != null;
  }

  Future<int> deleteUserLog(int id) async {
    Database? db = await this.db;
    await db!.execute("DELETE FROM users WHERE id = $id;");
    await db.execute("DELETE FROM log WHERE kullaniciId = $id;");
    int result = await db.rawUpdate("VACUUM");
    return result;
  }
}
