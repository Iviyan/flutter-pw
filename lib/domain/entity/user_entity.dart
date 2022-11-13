import 'package:pw/domain/entity/role_entity.dart';

class UserEntity {
  late final int id;
  final String login;
  final String password;
  final Roles role;

  UserEntity({
    this.id = 0, 
    required this.login, 
    required this.password,
    required this.role
  });
}
