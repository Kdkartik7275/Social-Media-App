import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/core/common/network/connection_checker.dart';
import 'package:social_x/src/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:social_x/src/authentication/data/repository/auth_repository_impl.dart';
import 'package:social_x/src/user/data/data_source/user_remote_data_source.dart';

class MockAuthRemoteSource extends Mock implements AuthRemoteDataSource {}

class MockUserRemoteSource extends Mock implements UserRemoteDataSource {}

class MockUserCredential extends Mock implements UserCredential {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

void main() {
  group("AuthRepositoryImplementation ---------", () {
    late AuthRemoteDataSource remoteDataSource;
    late ConnectionChecker connectionChecker;
    late UserRemoteDataSource userRemoteDataSource;
    late AuthRepositoryImpl repositoryImpl;
    setUp(() {
      remoteDataSource = MockAuthRemoteSource();
      userRemoteDataSource = MockUserRemoteSource();
      connectionChecker = MockConnectionChecker();
      repositoryImpl = AuthRepositoryImpl(
          connectionChecker: connectionChecker,
          remoteDataSource: remoteDataSource,
          userRemoteDataSource: userRemoteDataSource);
    });
    const email = 'kartik@test.com';
    const password = 'Park@674267';
    const username = 'Kartik';
    const country = 'In';
    group("Login User", () {
      test('should return userCredential when user successfully logged In',
          () async {
        // arrange

        final userCredential = MockUserCredential();
        when(() => connectionChecker.isConnected).thenAnswer((_) async => true);
        when(() => remoteDataSource.login(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((invocation) async => userCredential);

        // act
        final result =
            await repositoryImpl.login(email: email, password: password);

        // assert
        expect(result.isRight(), true);
        expect(result.getOrElse((l) => null), userCredential);
        verify(() => remoteDataSource.login(email: email, password: password))
            .called(1);
      });

      test('should throw an error if user failed to login', () async {
        when(() => remoteDataSource.login(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenThrow(Exception('Login Failed'));

        final result =
            await repositoryImpl.login(email: email, password: password);

        expect(result.fold((l) => l, (_) => null), isA<FirebaseFailure>());
      });

      test("Check if there is internet connection or not", () async {
        // arrange

        when(() => connectionChecker.isConnected).thenAnswer((_) async => true);

        // act

        final result =
            await repositoryImpl.login(email: email, password: password);

        // assert

        expect(result.isLeft(), true);
      });
    });

    group("Register User", () {
      test('should return userCredential when user successfully registered',
          () async {
        // arrange

        when(() => connectionChecker.isConnected)
            .thenAnswer((_) async => false);
        when(() => remoteDataSource.register(
                email: any(named: 'email'),
                password: any(named: 'password'),
                username: any(named: 'username'),
                country: any(named: 'country')))
            .thenAnswer((invocation) async => null);

        // act

        final result = await repositoryImpl.register(
            email: email,
            password: password,
            username: username,
            country: country);

        // assert

        expect(result.isRight(), false);
        expect(result.getOrElse((l) => null), null);
      });

      test('should throw an error if user failed to register', () async {
        when(() => remoteDataSource.register(
                email: any(named: 'email'),
                password: any(named: 'password'),
                country: any(named: 'country'),
                username: any(named: 'username')))
            .thenThrow(Exception('User Registration Failed'));

        final result = await repositoryImpl.register(
            email: email,
            password: password,
            country: country,
            username: username);

        expect(result.fold((l) => l, (_) => null), isA<FirebaseFailure>());
      });

      test("Check if there is internet connection or not", () async {
        // arrange

        when(() => connectionChecker.isConnected).thenAnswer((_) async => true);

        // act

        final result = await repositoryImpl.register(
            email: email,
            password: password,
            country: country,
            username: username);

        // assert

        expect(result.isLeft(), true);
      });
    });
  });
}
