import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:social_x/core/common/errors/exceptions/firebase_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/format_exceptions.dart';
import 'package:social_x/core/common/errors/exceptions/platform_exceptions.dart';
import 'package:social_x/src/user/data/models/usermodel.dart';

abstract interface class SearchRemoteDataSource {
  Future<List<UserModel>> searchUsers({required String query});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final FirebaseFirestore _firestore;

  SearchRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;
  @override
  Future<List<UserModel>> searchUsers({required String query}) async {
    try {
      final results = await _firestore
          .collection('Users')
          .where("username", isGreaterThanOrEqualTo: query)
          .get();
      List<UserModel> users = [];
      for (var item in results.docs) {
        users.add(UserModel.fromMap((item.data())));
      }
      return users;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(e.toString());
      throw 'Something went wrong. Please try again.';
    }
  }
}
