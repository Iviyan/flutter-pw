// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:pw/common/db_request.dart';
import 'package:pw/core/db/db_helper.dart';
import 'package:pw/data/model/user.dart';
import 'package:pw/domain/entity/role_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:pw/domain/repos/auth_repo.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepoImpl implements AuthRepo {

  final _db = DbHelper.instance.db;

  @override
  Future<Either<String, Roles>> signIn(String login, String password) async {
    try {
      var userQuery = await _db.query(DbRequest.tableUsers, 
        where: "login = ?", whereArgs: [login]
      );
      if (userQuery.isEmpty) return const Left("Пользователя с таким логином не существует");
      var user = User.fromMap(userQuery.single);
      if (user.password != password) return const Left("Неверный пароль");
      return Right(user.role);
    } on DatabaseException catch (err) {
      return Left(err.toString());
    }
  }

  @override
  Future<String?> signUp(String login, String password, Roles role) async {
    try {
      User user = User(login: login, password: password, role: role);
      await _db.insert(DbRequest.tableUsers, user.toMap(withId: false));
      return null;
    } on DatabaseException catch (err) {
      if (err.isUniqueConstraintError("users.login"))
        return "Пользователь с таким логином уже существует";
      return err.toString();
    }
  }

  @override
  String get table => DbRequest.tableUsers;

}