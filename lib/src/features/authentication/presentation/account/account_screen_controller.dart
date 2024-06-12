// Controllers should never depend on the BuildContext or anything to do with UI

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controllers are used for : managing the state of the screen, handling user interactions , Mediate between the UI and the repository
/// controllers are similar to View models in MVVM architecture , Blocs in BLoC architecture

/// Controllers using StateNotifier(Riverpod) are similar to:
/// ValueNotifier/ChangeNotifier in FlutterSDK
/// Cubit in Bloc

/// Async notifier is an alternative to StateNotifier that is designed to work with AsyncValue.

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  /// StateNotifier always needs an initial value , this needs to be set with the constructor using super()
  AccountScreenController(this.authRepository)
      : super(const AsyncValue<void>.data(null));
  final FakeAuthRepository authRepository;
  Future<bool> signOut() async {
    try {
      // set the state to loading
      state = const AsyncValue<void>.loading();
      // signout (usingg auth repository)
      await authRepository.signOut();
      // set the state to data (if success)
      state = const AsyncValue<void>.data(null);
      return true;
    } catch (e, st) {
      // set the state to error (if error)
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

// create a provider for the controller
final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository);
});
