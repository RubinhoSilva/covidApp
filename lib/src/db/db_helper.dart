import 'package:covid/src/models/localizacao.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'bancodedados.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE tb_localizacao (idLocalizacao INTEGER PRIMARY KEY, latitude DOUBLE, longitude DOUBLE, horario TEXT)');
  }

  Future<Localizacao> add(Localizacao localizacao) async {
    var dbClient = await db;
    localizacao.idLocalizacao = await dbClient.insert('tb_localizacao', localizacao.toMap());
    return localizacao;
  }

  Future<List<Localizacao>> getLocalizacoes() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('tb_localizacao', columns: ['idLocalizacao', 'latitude', 'longitude', 'horario']);
    List<Localizacao> localizacoes = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        localizacoes.add(Localizacao.fromMap(maps[i]));
      }
    }
    return localizacoes;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'tb_localizacao',
      where: 'idLocalizacao = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Localizacao localizacao) async {
    var dbClient = await db;
    return await dbClient.update(
      'tb_localizacao',
      localizacao.toMap(),
      where: 'idLocalizacao = ?',
      whereArgs: [localizacao.idLocalizacao],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}