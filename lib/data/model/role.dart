import '../../domain/entity/role_entity.dart';

class Role extends RoleEntity{
  Role({super.id, required super.name});

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name
  };

  factory Role.fromMap(Map<String, dynamic> json) => Role(id: json["id"], name: json["name"]);
}
