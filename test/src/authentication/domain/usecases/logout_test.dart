import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';
import 'package:social_x/src/authentication/domain/usecases/logout.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;

  late Logout usecase;

  setUp(() {
    repository = MockAuthRepo();

    usecase = Logout(repository: repository);
  });

  test("should call the AuthRepository.logoutUser", () async {
    // arrange

    when(() => repository.logout())
        .thenAnswer((invocation) async => right(null));

    // act
    final result = await usecase.call();

    // assert

    expect(result, equals(right(null)));
  });
}
