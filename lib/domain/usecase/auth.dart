import 'package:dartz/dartz.dart';
import 'package:pw/core/usecase/auth_use_case.dart';
import 'package:pw/domain/entity/role_entity.dart';
import 'package:pw/domain/repos/auth_repo.dart';

class Auth implements AuthUseCase<SignInParams, SignUpParams> {
  final AuthRepo authRepo;

  Auth(this.authRepo);

  @override
  Future<Either<String, Roles>> signIn(SignInParams params) => authRepo.signIn(params.login, params.password);

  @override
  Future<String?> signUp(SignUpParams params) => authRepo.signUp(params.login, params.password, params.role);
  
}

class SignInParams {
  final String login;
  final String password;

  SignInParams(this.login, this.password);
}

class SignUpParams {
  final String login;
  final String password;
  final Roles role;

  SignUpParams(this.login, this.password, this.role);
}