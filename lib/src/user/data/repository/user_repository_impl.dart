import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/core/common/network/connection_checker.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/data/data_source/user_remote_data_source.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ConnectionChecker connectionChecker;
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(
      {required this.connectionChecker, required this.remoteDataSource});
  @override
  ResultVoid deleteUserRecord({required String userId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.deleteUserRecord(userId: userId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<User?> getCurrentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final user = await remoteDataSource.getCurrentUser();
      if (user != null) {
        return right(user);
      } else {
        return left(FirebaseFailure(message: "User is not Logged In"));
      }
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity?> getCurrentUserData() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final user = await remoteDataSource.getCurrentUserData();
      return right(user);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid saveUserData(
      {required String username,
      required UserCredential user,
      required String email,
      required String country}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }

      await remoteDataSource.saveUserData(
          username: username, user: user, email: email, country: country);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid storeUserProfile(
      {required String path, required File image}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final imageUrl =
          await remoteDataSource.storeUserProfile(image: image, path: path);
      return right(imageUrl);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid updateSingleField({required Map<String, dynamic> json}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.updateSingleField(json: json);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity> getUserData({required String userId}) {
    try {
      return remoteDataSource.getUserData(userId: userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  ResultVoid followUser({required String userId, required String myId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.followUser(userId: userId, myId: myId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<UserEntity> blockUser(
      {required String userId, required String myUserId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      final user =
          await remoteDataSource.blockUser(userId: userId, myUserId: myUserId);
      return right(user);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid setUserToken(
      {required String token, required String userId}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(FirebaseFailure(message: "No Internet Connection"));
      }
      await remoteDataSource.setUserToken(token: token, userId: userId);
      return right(null);
    } catch (e) {
      return left(FirebaseFailure(message: e.toString()));
    }
  }
}
