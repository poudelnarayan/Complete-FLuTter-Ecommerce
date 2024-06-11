import 'package:ecommerce_app/src/common_widgets/shimmers.dart';
import 'package:ecommerce_app/src/features/cart/presentation/add_to_cart/add_to_cart_widget.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/home_app_bar.dart';
import 'package:ecommerce_app/src/features/products/presentation/product_screen/leave_review_action.dart';
import 'package:ecommerce_app/src/features/products/presentation/product_screen/product_average_rating.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/product_reviews/product_reviews_list.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/common_widgets/empty_placeholder_widget.dart';
import 'package:ecommerce_app/src/utils/currency_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/custom_image.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_two_column_layout.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';

/// Shows the product page for a given product ID.
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Consumer(
        builder: (context, ref, _) {
          final productValue = ref.watch(productProvider(productId));
          return AsyncValueWidget<Product?>(
            value: productValue,
            dataBuilder: (product) => product == null
                ? EmptyPlaceholderWidget(
                    message: 'Product not found'.hardcoded,
                  )
                : CustomScrollView(
                    slivers: [
                      ResponsiveSliverCenter(
                        padding: const EdgeInsets.all(Sizes.p16),
                        child: ProductDetails(product: product),
                      ),
                      ProductReviewsList(productId: productId),
                    ],
                  ),
            shimmerWidget: productScreenShimmer,
          );
        },
      ),
    );
  }
}

/// Shows all the product details along with actions to:
/// - leave a review
/// - add to cart
class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final priceFormatted = kCurrencyFormatter.format(product.price);
    return ResponsiveTwoColumnLayout(
      startContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: CustomImage(imageUrl: product.imageUrl),
        ),
      ),
      spacing: Sizes.p16,
      endContent: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(product.title,
                  style: Theme.of(context).textTheme.titleLarge),
              gapH8,
              Text(product.description),
              // Only show average if there is at least one rating
              if (product.numRatings >= 1) ...[
                gapH8,
                ProductAverageRating(product: product),
              ],
              gapH8,
              const Divider(),
              gapH8,
              Text(priceFormatted,
                  style: Theme.of(context).textTheme.headlineSmall),
              gapH8,
              LeaveReviewAction(productId: product.id),
              const Divider(),
              gapH8,
              AddToCartWidget(product: product),
            ],
          ),
        ),
      ),
    );
  }
}

const Widget productScreenShimmer = Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 20),
      BannerPlaceholder(height: 300, width: double.infinity),
      SizedBox(height: 30),
      TitlePlaceholder(width: 200.0),
      SizedBox(height: 5),
      SmallcontentPlaceholder(width: 170),
      SizedBox(height: 5),
      SmallcontentPlaceholder(width: 170),
      SizedBox(height: 20),
      SmallcontentPlaceholder(width: 170, height: 30),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SmallcontentPlaceholder(width: 170),
          SmallcontentPlaceholder(width: 170),
        ],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SmallcontentPlaceholder(width: 170),
          SmallcontentPlaceholder(width: 170),
        ],
      ),
      SizedBox(height: 20),
      Center(child: SmallcontentPlaceholder(width: 170, height: 40)),
      SizedBox(height: 10),
    ]);
