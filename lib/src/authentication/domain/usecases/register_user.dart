import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';

class RegisterUser
    implements UseCaseWithParams<UserCredential?, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUser({required this.repository});

  @override
  ResultFuture<UserCredential?> call(RegisterUserParams params) async =>
      await repository.register(
          email: params.email,
          password: params.password,
          username: params.username,
          country: params.country);
}

class RegisterUserParams {
  final String email;
  final String username;
  final String password;
  final String country;

  RegisterUserParams(
      {required this.email,
      required this.username,
      required this.password,
      required this.country});
}
