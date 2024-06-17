// ignore: library_annotations
@Timeout(Duration(seconds: 5))
// All the test in this file will now use this timeout(unless we override it)

import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository);
  });
  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      expect(controller.state, const AsyncData<void>(null));
    });

    test(
      'singnOut success',
      () async {
        // Define Behavior:
        when(authRepository.signOut).thenAnswer((_) => Future.value());
        // as this uses a stream , we need to listen to the stream to get the state changes before performing the action
        expectLater(
          controller.stream,
          emitsInOrder(const [
            AsyncLoading<void>(),
            AsyncData<void>(null),
          ]),
        );
        // Perform Action:
        await controller.signOut();
        // Assertions:
        verify(authRepository.signOut).called(1);
      },
    );

    test(
      'singnOut Failure',
      () async {
        final exception = Exception('Connection failed');
        // Define Behavior:
        when(authRepository.signOut).thenThrow(exception);
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            // Predicates give us fine grained control over the values we want to test
            predicate<AsyncValue<void>>((state) {
              expect(state.hasError, true);
              return true;
            }),
          ]),
        );
        // Perform Action:
        await controller.signOut();
        // Assertions:
        verify(authRepository.signOut).called(1);
      },
    );
  });
}
