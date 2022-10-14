import '../../domain/entity/user_entity.dart';

class User extends UserEntity{
  User({
    required super.login,
    required super.password,
    required super.roleId
  });

  Map<String, dynamic> toMap() => {
    "login": login,
    "password": password,
    "role_id": roleId
  };

  factory User.fromMap(Map<String, dynamic> json)
   => User(login: json["login"], password: json["password"], roleId: json["role_id"]);
}
