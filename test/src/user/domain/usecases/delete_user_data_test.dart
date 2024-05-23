import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';
import 'package:social_x/src/user/domain/usecases/delete_user_data.dart';

import 'user_repo.mock.dart';

void main() {
  late DeleteUserData usecase;
  late UserRepository repository;

  setUp(() {
    repository = MockUserRepo();
    usecase = DeleteUserData(repository: repository);
  });

  test("should call the delete user data method and return null when success",
      () async {
    // arrange

    when(() => repository.deleteUserRecord(userId: any(named: 'userId')))
        .thenAnswer((invocation) async => right(null));

    // act

    final result = await usecase.call('kadnjd');

    //assert

    expect(result, right(null));
  });

  test("should return failure when user failed to delete record", () async {
    final failure = FirebaseFailure(message: "Something went Wrong");

    // arrange

    when(() => repository.deleteUserRecord(userId: any(named: 'userId')))
        .thenAnswer((invocation) async => left(failure));

    // act

    final result = await usecase.call('');

    expect(result, left(failure));
  });
}
