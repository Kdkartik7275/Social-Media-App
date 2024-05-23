import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/core/common/network/connection_checker.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';
import 'package:social_x/src/user/data/data_source/user_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ConnectionChecker connectionChecker;
  final AuthRemoteDataSource remoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  AuthRepositoryImpl(
      {required this.connectionChecker,
      required this.remoteDataSource,
      required this.userRemoteDataSource});
  @override
  ResultVoid forgotPassword({required String email}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.forgotPassword(email: email);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserCredential?> login(
      {required String email, required String password}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final user =
          await remoteDataSource.login(email: email, password: password);
      return right(user);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid logout() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.logout();
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserCredential?> register(
      {required String email,
      required String password,
      required String username,
      required String country}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final user = await remoteDataSource.register(
          email: email,
          password: password,
          username: username,
          country: country);
      if (user != null) {
        userRemoteDataSource.saveUserData(
            username: username, user: user, email: email, country: country);
      }
      return right(user);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
