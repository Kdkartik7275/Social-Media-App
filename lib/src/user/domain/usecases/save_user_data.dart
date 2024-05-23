import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class SaveUserData implements UseCaseWithParams<void, SaveUserDataParams> {
  final UserRepository repository;

  SaveUserData({required this.repository});
  @override
  ResultFuture<void> call(SaveUserDataParams params) async =>
      await repository.saveUserData(
          username: params.username,
          user: params.user,
          email: params.email,
          country: params.country);
}

class SaveUserDataParams {
  final String username;
  final String email;
  final UserCredential user;
  final String country;

  SaveUserDataParams(
      {required this.username,
      required this.email,
      required this.country,
      required this.user});
}
