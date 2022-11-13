import 'package:pw/data/model/model_extension.dart';
import 'package:pw/domain/entity/role_entity.dart';
import 'package:pw/domain/entity/user_entity.dart';

class User extends UserEntity{
  User({
    super.id = 0,
    required super.login,
    required super.password,
    required super.role
  });

  Map<String, dynamic> toMap({bool withId = true}) => {
    "login": login,
    "password": password,
    "role_id": role.id
  }.withId(id, cancel: !withId);

  factory User.fromMap(Map<String, dynamic> json) {
    int roleId = json["role_id"] as int;
    return User(
      id: json["id"], 
      login: json["login"],
      password: json["password"], 
      role: Roles.values.singleWhere((e) => e.id == roleId)
    );
  }
}
