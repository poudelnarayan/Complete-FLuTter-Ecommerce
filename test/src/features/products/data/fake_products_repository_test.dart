import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getProductList returns a list of products', () {
    final productRepository = FakeProductsRepository();
    expect(productRepository.getProductList(), kTestProducts);
  });

  test('getProductById(1) returns first item', () {
    final productRepository = FakeProductsRepository();
    expect(productRepository.getProductById('1'), kTestProducts.first);
  });

  test('getProductById(100) returns null', () {
    final productRepository = FakeProductsRepository();
    expect(
      () => productRepository.getProductById('100'),
      throwsStateError,
    );
  });
}
