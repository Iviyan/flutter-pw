import '../../domain/entity/role_entity.dart';

class Role extends RoleEntity{
  Role({required super.name});

  Map<String, dynamic> toMap() => {
    "name": name
  };

  factory Role.fromMap(Map<String, dynamic> json) => Role(name: json["name"]);
}
