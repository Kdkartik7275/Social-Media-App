import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';
import 'package:social_x/src/user/domain/usecases/block_user.dart';

import 'user_repo.mock.dart';

void main() {
  late UserRepository repository;

  late BlockUser usecase;

  setUp(() {
    repository = MockUserRepo();

    usecase = BlockUser(repository: repository);
  });

  const userId = 'njnjn';
  const myUserId = 'kartik';

  final user = UserEntity();

  test("should return userEntity when user is Blocked", () async {
    // arrange

    when(() => repository.blockUser(userId: userId, myUserId: myUserId))
        .thenAnswer((invocation) async => right(user));

    // act

    final result =
        await usecase.call(BlockUserParams(userId: userId, myUserId: myUserId));

    // assert

    expect(result, right(user));
  });

  test("should throw an exception when user is failed to block", () async {
    // arrange

    final failure = FirebaseFailure(message: 'Failed to block user');
    when(() => repository.blockUser(userId: userId, myUserId: myUserId))
        .thenAnswer((invocation) async => left(failure));

    // act
    final result =
        await usecase.call(BlockUserParams(userId: userId, myUserId: myUserId));

    // assert

    expect(result, left(failure));
  });
}
