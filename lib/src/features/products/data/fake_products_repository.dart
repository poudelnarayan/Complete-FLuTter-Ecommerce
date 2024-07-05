import 'dart:async';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_products_repository.g.dart';

class FakeProductsRepository {
  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;

  /// Preload with the default list of products when the app starts
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));

  List<Product> getProductList() {
    return _products.value;
  }

  Product? getProductById(String id) {
    return _getProduct(_products.value, id);
  }

  Future<List<Product>> fetchProductsList() async {
    return Future.value(_products.value);
  }

  Stream<List<Product>> watchProductsList() {
    return _products.stream;
  }

  /// Search for products where the title contains the search query
  Future<List<Product>> searchProducts(String query) async {
    assert(
      _products.value.length <= 100,
      'Client-side search should only be performed if the number of products is small. '
      'Consider doing server-side search for larger datasets.',
    );
    // Get all products
    final productsList = await fetchProductsList();
    // Match all products where the title contains the query
    return productsList
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Stream<Product?> watchProductById(String id) {
    return watchProductsList().map((products) {
      return _getProduct(products, id);
    });
  }

  /// Update product or add a new one
  Future<void> setProduct(Product product) async {
    await delay(addDelay);
    final products = _products.value;
    final index = products.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      // if not found, add as a new product
      products.add(product);
    } else {
      // else, overwrite previous product
      products[index] = product;
    }
    _products.value =
        List<Product>.from(products); // Create a new list to trigger listeners
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

@riverpod
FakeProductsRepository productsRepository(ProductsRepositoryRef ref) {
  return FakeProductsRepository(addDelay: false);
}

@riverpod
Stream<List<Product>> productsListStream(ProductsListStreamRef ref) {
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.watchProductsList();
}

@riverpod
FutureOr<List<Product>> productsListFuture(ProductsListFutureRef ref) {
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.fetchProductsList();
}

@riverpod
Stream<Product?> product(ProductRef ref, ProductID id) {
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.watchProductById(id);
}

@riverpod
Future<List<Product>> productsListSearch(
    ProductsListSearchRef ref, String query) async {
  final link = ref.keepAlive();
  Timer(const Duration(seconds: 5), () {
    link.close();
  });

  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.searchProducts(query);
}
