import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';
import 'package:social_x/src/user/domain/usecases/get_current_user_data.dart';

import 'user_repo.mock.dart';

void main() {
  late GetCurrentUserData usecase;
  late UserRepository repository;

  setUp(() {
    repository = MockUserRepo();
    usecase = GetCurrentUserData(repository: repository);
  });

  test('should return userEntity when method is called', () async {
    // arrange

    final user = UserEntity();

    when(() => repository.getCurrentUserData())
        .thenAnswer((invocation) async => right(user));

    // act

    final result = await usecase.call();

    // assert

    expect(result, right(user));
  });
}
