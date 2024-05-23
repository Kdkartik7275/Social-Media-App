import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';
import 'package:social_x/src/authentication/domain/usecases/login_user.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late AuthRepository repository;

  late LoginUser usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = LoginUser(repository: repository);
  });
  test("Should call the AuthRepository.loginUser", () async {
    // arrange

    final mockUserCredential = MockUserCredential();
    final params =
        LoginUserParams(email: 'kartik@test.com', password: 'Park@7275');

    when(() => repository.login(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((invocation) async => right(mockUserCredential));

    // act

    final result = await usecase.call(params);

    // assert

    expect(result, right(mockUserCredential));
  });
}
