class RoleEntity {
  late final int id;
  final String name;

  RoleEntity({required this.name});
}

enum Roles { admin, user }
