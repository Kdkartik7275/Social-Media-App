import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';
import 'package:social_x/src/authentication/domain/usecases/forgot_password.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;

  late ForgotPassword usecase;

  setUp(() {
    repository = MockAuthRepo();

    usecase = ForgotPassword(repository: repository);
  });

  test("should call the AuthRepository.forgotPassword", () async {
    // arrange

    when(() => repository.forgotPassword(email: any(named: 'email')))
        .thenAnswer((invocation) async => right(null));

    // act
    final result = await usecase.call('kartik@test.com');

    // assert

    expect(result, equals(right(null)));
  });
}
