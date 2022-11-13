import 'package:dartz/dartz.dart';
import 'package:pw/domain/entity/role_entity.dart';

abstract class  AuthUseCase<SignInParams, SignUpParams> {
  Future<Either<String, Roles>> signIn(SignInParams params);
  Future<String?> signUp(SignUpParams params);
}