import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  final List<Product> _products = kTestProducts;

  List<Product> getProductList() {
    return _products;
  }

  Product? getProductById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 2));

    yield _products;
  }

  Stream<Product?> watchProductById(String id) {
    return watchProductsList().map((products) {
      return products.firstWhere((product) => product.id == id);
    });
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider = StreamProvider<List<Product>>((ref) {
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.watchProductsList();
});

final productsListFutureProvider = FutureProvider<List<Product>>((ref) {
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.fetchProductsList();
});
