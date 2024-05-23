import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';

abstract interface class AuthRepository {
  ResultFuture<UserCredential?> login(
      {required String email, required String password});
  ResultFuture<UserCredential?> register(
      {required String email,
      required String password,
      required String username,
      required String country});

  ResultVoid logout();
  ResultVoid forgotPassword({required String email});
}
