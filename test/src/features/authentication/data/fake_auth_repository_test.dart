import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeAuthRepository makeAuthRepository() {
    return FakeAuthRepository(addDelay: false);
  }

  const testEmail = 'test@test.com';
  const testPassword = 'Password';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );

  group('FakeAuthRepository', () {
    test('CurrentUser is null', () {
      final authRepository = makeAuthRepository();
      // addTearDown method calls the dispose method
      // of the authRepository object when the test is done either
      // complete or Fails
      addTearDown(authRepository.dispose);
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('SignInWithEmailAndPassword signs new user', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('CreateUserWithEmailAndPassword creates new user', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword);
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
    });

    test('SignOut signs out user', () async {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      // expect(
      //   authRepository.authStateChanges(),
      //   emitsInOrder([
      //     testUser, // This is the user that was signed in.
      //     null, // This is the user that was signed out.
      //   ]),
      // );
      expect(authRepository.currentUser, testUser);
      expect(authRepository.authStateChanges(), emits(testUser));
      await authRepository.signOut();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('sign in after dispose throws exception', () {
      final authRepository = makeAuthRepository();
      addTearDown(authRepository.dispose);
      authRepository.dispose();
      expect(
          () => authRepository.signInWithEmailAndPassword(
              testEmail, testPassword),
          throwsStateError);
    });
  });
}
