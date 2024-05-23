import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';
import 'package:social_x/src/user/domain/usecases/get_current_user.dart';

import 'user_repo.mock.dart';

class MockFirebaseUser extends Mock implements User {}

void main() {
  late UserRepository repository;
  late GetCurrentUser usecase;

  setUp(() {
    repository = MockUserRepo();
    usecase = GetCurrentUser(repository: repository);
  });

  group("Get Current User UseCase", () {
    test("should return Firebase User when there is current user exist",
        () async {
      // arrange
      final user = MockFirebaseUser();
      when(() => repository.getCurrentUser())
          .thenAnswer((invocation) async => right(user));

      // act

      final result = await usecase.call();

      // assert

      expect(result, equals(right(user)));
    });

    test("should thrown an exception when failed to load current user",
        () async {
      // arrange
      final failure = FirebaseFailure(message: "Something went wrong");

      when(() => repository.getCurrentUser())
          .thenAnswer((invocation) async => left(failure));

      // act
      final result = await usecase.call();

      // assert

      expect(result, equals(left(failure)));
    });
  });
}
