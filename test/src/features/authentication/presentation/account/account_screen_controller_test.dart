import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      final authRepository = MockAuthRepository();
      final controller = AccountScreenController(authRepository);
      expect(controller.state, const AsyncData<void>(null));
    });

    test('singnOut success', () async {
      // Setup Mocks:
      final authRepository = MockAuthRepository();
      final controller = AccountScreenController(authRepository);
      // Define Behavior:
      when(authRepository.signOut).thenAnswer((_) => Future.value());
      // Perform Action:
      await controller.signOut();
      // Assertions:
      verify(authRepository.signOut).called(1);
      expect(controller.state, const AsyncData<void>(null));
    });
  });
}
