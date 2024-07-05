import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';

class ReviewsService {
  ReviewsService(this.ref);
  final Ref ref;

  Future<void> submitReview({
    required ProductID productId,
    required Review review,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    assert(user != null);
    if (user == null) {
      throw AssertionError('Can\'t submit a review if the user is not signed in'.hardcoded);
    }
    await ref.read(reviewsRepositoryProvider).setReview(
          productId: productId,
          uid: user.uid,
          review: review,
        );
    await _updateProductRating(productId);
  }

  Future<void> _updateProductRating(ProductID productId) async {
    final reviews = await ref.read(reviewsRepositoryProvider).fetchReviews(productId);
    final avgRating = _avgReviewScore(reviews);
    final productRepository = ref.read(productsRepositoryProvider);
    final product = productRepository.getProductById(productId);
    if (product != null) {
      final updatedProduct = product.copyWith(
        avgRating: avgRating,
        numRatings: reviews.length,
      );
      await productRepository.setProduct(updatedProduct);
    }
  }

  double _avgReviewScore(List<Review> reviews) {
    if (reviews.isNotEmpty) {
      var total = 0.0;
      for (var review in reviews) {
        total += review.rating;
      }
      return total / reviews.length;
    } else {
      return 0.0;
    }
  }
}

final reviewsServiceProvider = Provider<ReviewsService>((ref) {
  return ReviewsService(ref);
});


/// Check if a product was previously reviewed by the user
final userReviewFutureProvider =
    FutureProvider.autoDispose.family<Review?, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref
        .watch(reviewsRepositoryProvider)
        .fetchUserReview(productId, user.uid);
  } else {
    return Future.value(null);
  }
});

/// Check if a product was previously reviewed by the user
final userReviewStreamProvider =
    StreamProvider.autoDispose.family<Review?, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref
        .watch(reviewsRepositoryProvider)
        .watchUserReview(productId, user.uid);
  } else {
    return Stream.value(null);
  }
});
