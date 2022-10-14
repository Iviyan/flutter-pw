import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pw/common/db_request.dart';
import 'package:pw/domain/entity/role_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../data/model/role.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._instance();

  DbHelper._instance();

  late final Directory _appDocuentDirectory;
  late final String _dbPath;
  late final Database db;
  final int _version = 1;

  Future<void> init() async {
    _appDocuentDirectory =
        await path_provider.getApplicationDocumentsDirectory();

    _dbPath = join(_appDocuentDirectory.path, "store.db");

    db = await openDatabase(
      _dbPath,
      version: _version,
      onCreate: (db, version) => onCreateDb(db),
      onUpgrade: (db, oldVersion, newVersion) => onUpgradeDb(db),
    );
  }

  Future<void> onCreateDb(Database db) async {
    for (var sql in DbRequest.createDbSqlList) {
      await db.execute(sql);
    }

    await onInitDb(db);
  }

  Future<void> onInitDb(Database db) async {
    //try {
    for (var roleName in Roles.values) {
      db.insert(DbRequest.tableRoles, Role(name: roleName.name).toMap());
    }
    //} on DatabaseException catch (e) {}
  }

  Future<void> onDropDb() async {
    await db.close();

    deleteDatabase(_dbPath);
  }

  Future<void> onUpgradeDb(Database db) async {
    var tables = await db.rawQuery('select name from sqlite_master;');
    for (var tableName in DbRequest.createDbSqlList.reversed) {
      if (tables.where((element) => element["name"] == tableName).isNotEmpty) {
        await db.execute(DbRequest.deleteTable(tableName));
      }
    }

    for (var sql in DbRequest.createDbSqlList) {
      await db.execute(sql);
    }

    await onInitDb(db);
  }
}
