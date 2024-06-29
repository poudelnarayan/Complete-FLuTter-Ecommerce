import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:flutter/foundation.dart';
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
        _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  /// moves all items from the local to the remote cart taking into the account the available quantities
  Future<void> _moveItemsToRemoteCart(String uid) async {
    // get the local cart data

    final localCartRepository = ref.read(localCartRepositoryProvider);
    final localCart = await localCartRepository.fetchCart();
    if (localCart.items.isNotEmpty) {
      // get the remote cart data
      final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
      final remoteCart = await remoteCartRepository.fetchCart(uid);
      final localItemsToAdd = localCart.toItemsList();
      // add all the local items to the remote cart
      final updatedRemoteCart = remoteCart.addItems(localItemsToAdd);
      // write the updated remote cart data to the repository
      await remoteCartRepository.setCart(uid, updatedRemoteCart);
      // Remove all items from the local cart
    }
  }
}

final cartSyncServiceProvider =
    Provider<CartSyncService>((ref) => CartSyncService(ref));
