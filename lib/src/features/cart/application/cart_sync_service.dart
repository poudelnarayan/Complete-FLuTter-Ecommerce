import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSyncService {
  final Ref ref;

  CartSyncService(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider,
        (previous, next) {
      final previousUser = previous?.value;
      final user = next.value;
      // previously not logged in and now logged in
      if (previousUser == null && user != null) {
        // user logged in
        // sync local cart with remote cart
      } else if (previousUser != null && user == null) {
        // user logged out
        // sync remote cart with local cart
      }
    });
  }
}

final cartSyncServiceProvider =
    Provider<CartSyncService>((ref) => CartSyncService(ref));
