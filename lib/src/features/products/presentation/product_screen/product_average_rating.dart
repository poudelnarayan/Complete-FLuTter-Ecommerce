import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';

class ProductAverageRating extends ConsumerWidget {
  const ProductAverageRating({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsyncValue = ref.watch(productProvider(productId));

    return productAsyncValue.when(
      data: (product) {
        if (product == null) {
          return const SizedBox.shrink();
        }
        return product.numRatings != 0
            ? Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  gapW8,
                  Text(
                    product.avgRating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  gapW8,
                  Expanded(
                    child: Text(
                      product.numRatings == 1
                          ? '1 rating'
                          : '${product.numRatings} ratings',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
