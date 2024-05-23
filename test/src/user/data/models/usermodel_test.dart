import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:social_x/src/user/data/models/usermodel.dart';
import 'package:social_x/src/user/domain/entity/user.dart';

import '../../../../helper/functions/read_json.dart';

void main() {
  group("UserModel ----------", () {
    final userModel = UserModel();
    test("should be a subclass of UserEntity", () {
      // assert

      expect(userModel, isA<UserEntity>());
    });
    test("should return a valid model from json", () {
      // arrange

      final Map<String, dynamic> userJson =
          json.decode(readJson('helper/dummy_data/user_dummy.json'));

      // act
      final result = UserModel.fromMap(userJson);

      // assert
      expect(result, equals(UserModel.fromMap(userJson)));
    });
  });
}
