import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getProductList returns a list of products', () {
    final productRepository = FakeProductsRepository();
    expect(productRepository.getProductList(), kTestProducts);
  });
}
