import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/item.dart';

class AddToCartController extends StateNotifier<AsyncValue<int>> {
  AddToCartController({required this.cartService}) : super(const AsyncData(1));
  final CartService cartService;

  void updateQuantity(int quantity) {
    state = AsyncData(quantity);
  }

  Future<void> addItem(ProductID productId) async {
    final item = Item(productId: productId, quantity: state.value!);
    // If we use only  AsyncLoading , then we no longer have a way to keep track of the state because
    // AsyncLoading doesnt carry any information about the previous  state.
    // state = const AsyncLoading();
    // so
    state = const AsyncLoading<int>().copyWithPrevious(state);
    final value = await AsyncValue.guard(() => cartService.addItem(item));
    if (value.hasError) {
      state = AsyncError(value.error!, value.stackTrace!);
    } else {
      state = const AsyncData(1);
    }
  }
}

/// withoutDispose:
/// controller is not disposed when we nevigate back
/// still alive(with previous state) when we open different page
/// so it shows the same quantity as previous when we navigate to different page
/// so the controller must be disposed
final addtoCartControllerProvider =
    StateNotifierProvider.autoDispose<AddToCartController, AsyncValue<int>>(
        (ref) {
  return AddToCartController(
    cartService: ref.watch(cartServiceProvider),
  );
});
