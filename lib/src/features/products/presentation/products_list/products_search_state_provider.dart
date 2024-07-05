import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsSearchQueryStateProvider = StateProvider<String>((ref) {
  return '';
});

final productsSearchResultsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) async {
  // 1. get the query from the `StateNotifier`
  final searchQuery = ref.watch(productsSearchQueryStateProvider);
  // 2. pass it as an argument and return the results
  return ref.watch(productsListSearchProvider(searchQuery).future);
});
