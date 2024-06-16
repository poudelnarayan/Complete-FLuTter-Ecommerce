import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductsRepository makeProductsRepository() {
    return FakeProductsRepository(addDelay: false);
  }

  group('FakeProductRepository', () {
    test('getProductList returns a list of products', () {
      final productRepository = makeProductsRepository();
      expect(productRepository.getProductList(), kTestProducts);
    });

    test('getProductById(1) returns first item', () {
      final productRepository = makeProductsRepository();
      expect(productRepository.getProductById('1'), kTestProducts.first);
    });

    test('getProductById(100) returns null', () {
      final productRepository = makeProductsRepository();
      expect(
        productRepository.getProductById('100'),
        null,
      );
    });

    test('fetchProductsList returns global list', () async {
      final productRepository = makeProductsRepository();
      expect(
        await productRepository.fetchProductsList(),
        kTestProducts,
      );
    });

    test('watchProdctsList emits global list ', () {
      final productRepository = makeProductsRepository();
      expect(
        productRepository.watchProductsList(),
        emits(kTestProducts),
      );
    });

    test('watchProduct(1) emits first item', () {
      final productRepository = makeProductsRepository();
      expect(
        productRepository.watchProductById('1'),
        emits(kTestProducts.first),
      );
    });

    test('watchProduct(100) emist null', () {
      final productRepository = makeProductsRepository();
      expect(
        productRepository.watchProductById('100'),
        emits(null),
      );
    });
  });
}
