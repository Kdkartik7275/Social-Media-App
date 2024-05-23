import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';

class LoginUser implements UseCaseWithParams<UserCredential?, LoginUserParams> {
  final AuthRepository repository;

  LoginUser({required this.repository});
  @override
  ResultFuture<UserCredential?> call(LoginUserParams params) async =>
      await repository.login(email: params.email, password: params.password);
}

class LoginUserParams {
  final String email;
  final String password;

  LoginUserParams({required this.email, required this.password});
}
