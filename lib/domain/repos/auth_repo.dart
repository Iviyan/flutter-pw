import 'package:dartz/dartz.dart';
import 'package:pw/domain/entity/role_entity.dart';

abstract class AuthRepo {
  String get table;

  Future<Either<String, Roles>> signIn(String login, String password);
  Future<String?> signUp(String login, String password, Roles role);
}