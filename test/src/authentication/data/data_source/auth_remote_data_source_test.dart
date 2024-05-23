import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/core/common/errors/exceptions/firebase_auth_exceptions.dart';
import 'package:social_x/src/authentication/data/data_source/auth_remote_data_source.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late FirebaseAuth auth;
  late AuthRemoteDataSourceImpl dataSourceImpl;
  setUp(() {
    auth = MockFirebaseAuth();
    dataSourceImpl = AuthRemoteDataSourceImpl(auth: auth);
  });

  group("Login User ----------", () {
    test("Should return userCredential when user is logged in successfully",
        () async {
      // arrange
      final email = 'test@example.com';
      final password = 'password123';
      final userCredential = MockUserCredential();

      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((invocation) async => userCredential);

      // act

      final result =
          await dataSourceImpl.login(email: email, password: password);

      // assert

      expect(result, userCredential);
    });

    test('FirebaseAuthException', () async {
      const email = 'test@example.com';
      const password = 'password';

      when(() => auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: 'invalid-credentials'));

      try {
        await dataSourceImpl.login(email: email, password: password);
        fail('Expected FirebaseAuthException');
      } catch (e) {
        if (e is TFirebaseAuthException) {
          expect(e.code, 'invalid-credentials');
          expect(e.message,
              'Invalid credentials. Please check your authentication configuration.');
        }
      }
    });
  });

  group("Register User ---------------", () {
    test("should return userCredential when user successfully register",
        () async {
      // arrange

      final userCredential = MockUserCredential();
      const email = 'kartik@test.com';
      const password = 'PARK7Y3RNJ';
      const username = 'kartik@';
      const country = 'US';

      when(() => auth.createUserWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((invocation) async => userCredential);

      // act

      final result = await dataSourceImpl.register(
          email: email,
          password: password,
          username: username,
          country: country);

      // assert

      expect(result, equals(userCredential));
    });
  });

  test("should throw an exception when user is fail to register user",
      () async {
    const email = 'test@example.com';
    const password = 'password';
    const country = 'password';
    const username = 'password';

    when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(FirebaseAuthException(code: 'invalid-credentials'));

    try {
      await dataSourceImpl.register(
          email: email,
          password: password,
          country: country,
          username: username);
    } catch (e) {
      if (e is TFirebaseAuthException) {
        expect(e.code, 'invalid-credentials');
        expect(e.message,
            'Invalid credentials. Please check your authentication configuration.');
      }
    }
  });

  group("Forgot Password ----------------", () {
    test("should throw an exception when user failed to reset password",
        () async {
      // arrange

      when(() => auth.sendPasswordResetEmail(email: any(named: 'email')))
          .thenThrow(FirebaseAuthException(code: 'invalid-credentials'));
      // assert
      try {
        await dataSourceImpl.forgotPassword(
          email: '',
        );
      } catch (e) {
        if (e is TFirebaseAuthException) {
          expect(e.code, 'invalid-credentials');
          expect(e.message,
              'Invalid credentials. Please check your authentication configuration.');
        }
      }
    });
  });
}
