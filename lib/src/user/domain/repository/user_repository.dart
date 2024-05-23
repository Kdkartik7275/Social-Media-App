import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/entity/user.dart';

abstract interface class UserRepository {
  ResultVoid saveUserData(
      {required String username,
      required UserCredential user,
      required String email,
      required String country});

  ResultVoid updateSingleField({required Map<String, dynamic> json});

  ResultVoid storeUserProfile({required String path, required File image});

  ResultFuture<User?> getCurrentUser();
  ResultFuture<UserEntity?> getCurrentUserData();
  ResultVoid deleteUserRecord({required String userId});
  Stream<UserEntity> getUserData({required String userId});

  ResultVoid followUser({required String userId, required String myId});

  ResultFuture<UserEntity> blockUser(
      {required String userId, required String myUserId});

  ResultVoid setUserToken({required String token, required String userId});
}
