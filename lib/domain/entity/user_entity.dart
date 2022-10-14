class UserEntity {
  late final int id;
  final String login;
  final String password;
  final int roleId;

  UserEntity({
    required this.login, 
    required this.password,
    required this.roleId
  });
}
