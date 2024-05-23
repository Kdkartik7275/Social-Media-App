import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';
import 'package:social_x/src/authentication/domain/usecases/register_user.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late RegisterUser registerUser;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepo();

    registerUser = RegisterUser(repository: repository);
  });

  test("Auth Repository.registerUser", () async {
    final params = RegisterUserParams(
        email: 'kartik@test.com',
        username: "Kartikkdx",
        password: "Park@7275",
        country: "India");
    // ARRANGE
    final mockUserCredential = MockUserCredential();
    when(() => repository.register(
        email: any(named: 'email'),
        password: any(named: 'password'),
        username: any(named: 'username'),
        country: any(named: 'country'))).thenAnswer((invocation) async {
      return right(mockUserCredential);
    });

    // ACT

    final result = await registerUser.call(params);

    // ASSERT

    expect(
        result, equals(right<dynamic, MockUserCredential>(mockUserCredential)));
    verify(() => repository.register(
        email: params.email,
        password: params.password,
        username: params.username,
        country: params.country)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
