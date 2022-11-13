class RoleEntity {
  late final int id;
  final String name;

  RoleEntity({this.id = 0, required this.name});
}

enum Roles {
  admin(1, "Администратор"),
  user(2, "Пользователь");

  const Roles(this.id, this.title);
  final int id;
  final String title;
}
