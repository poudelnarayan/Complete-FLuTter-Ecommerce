import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testEmail = "test@test.com";
  const testPassword = "testPassword";
  group('submit', () {
    test(
      '''
    Given formType is SignIn
    When signInWithEmailAndPassword succeeds
    Then return true
    And state is AsyncData
''',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository,
        );
        // behaviour

        when(() => authRepository.signInWithEmailAndPassword(
            testEmail, testPassword)).thenAnswer(
          (_) => Future.value(),
        );

        //expect later

        expectLater(
          controller.stream,
          emitsInOrder(
            [
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncLoading<void>(),
              ),
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncData<void>(null),
              ),
            ],
          ),
        );

        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, true);
      },
      timeout: const Timeout(
        Duration(seconds: 5),
      ),
    );

    test(
      '''
    Given formType is SignIn
    When signInWithEmailAndPassword fails
    Then return false
    And state is AsyncError
''',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository,
        );
        final exception = Exception("Connection failed");
        // behaviour

        when(() => authRepository.signInWithEmailAndPassword(
            testEmail, testPassword)).thenThrow(exception);

        //expect later

        expectLater(
          controller.stream,
          emitsInOrder(
            [
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncLoading<void>(),
              ),
              predicate<EmailPasswordSignInState>((state) {
                expect(state.formType, EmailPasswordSignInFormType.signIn);
                expect(state.value.hasError, true);
                return true;
              })
            ],
          ),
        );

        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, false);
      },
      timeout: const Timeout(
        Duration(seconds: 5),
      ),
    );

    test(
      '''
    Given formType is register
    When createUserWithEmailAndPassword succeeds
    Then return true
    And state is AsyncData
''',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository,
        );
        // behaviour

        when(() => authRepository.createUserWithEmailAndPassword(
            testEmail, testPassword)).thenAnswer(
          (_) => Future.value(),
        );

        //expect later

        expectLater(
          controller.stream,
          emitsInOrder(
            [
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncLoading<void>(),
              ),
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncData<void>(null),
              ),
            ],
          ),
        );

        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, true);
      },
      timeout: const Timeout(
        Duration(seconds: 5),
      ),
    );

    test(
      '''
    Given formType is register
    When createUserWithEmailAndPassword fails
    Then return false
    And state is AsyncError
''',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository,
        );
        final exception = Exception("Connection failed");
        // behaviour

        when(() => authRepository.createUserWithEmailAndPassword(
            testEmail, testPassword)).thenThrow(exception);

        //expect later

        expectLater(
          controller.stream,
          emitsInOrder(
            [
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncLoading<void>(),
              ),
              predicate<EmailPasswordSignInState>((state) {
                expect(state.formType, EmailPasswordSignInFormType.register);
                expect(state.value.hasError, true);
                return true;
              })
            ],
          ),
        );

        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, false);
      },
      timeout: const Timeout(
        Duration(seconds: 5),
      ),
    );
  });

  group('updateFormType', () {
    test('''
      Given formType is signIn
      when called with register
      then state formType is register
''', () {
      final authRepository = MockAuthRepository();
      final controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.signIn,
        authRepository: authRepository,
      );

      controller.updateFormType(EmailPasswordSignInFormType.register);

      expect(
          controller.state,
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncValue.data(null),
          ));
    });

    test('''
      Given formType is register
      when called with signIn
      then state formType is signIn
''', () {
      final authRepository = MockAuthRepository();
      final controller = EmailPasswordSignInController(
        formType: EmailPasswordSignInFormType.register,
        authRepository: authRepository,
      );

      controller.updateFormType(EmailPasswordSignInFormType.signIn);

      expect(
          controller.state,
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncValue.data(null),
          ));
    });
  });
}
